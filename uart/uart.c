#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>	//Used for UART
#include <fcntl.h>	//Used for UART
#include <termios.h>//Used for UART
#include <stdlib.h>
#include <signal.h>
#include <string.h>

//#include "printregs.h"

void process_data(char* data);
void process_spi(char* data);

#define STOP_TRIES	20
#define DATA_SIZE	128

uint32_t exit_flag = 0;
int32_t fd = -1;

int32_t configure_uart(int32_t fd, uint32_t speed) {

	//CONFIGURE THE UART
	//The flags (defined in /usr/include/termios.h - see http://pubs.opengroup.org/onlinepubs/007908799/xsh/termios.h.html):
	//	Baud rate:- B1200, B2400, B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B500000, B576000, B921600, B1000000, B1152000, B1500000, B2000000, B2500000, B3000000, B3500000, B4000000
	//	CSIZE:- CS5, CS6, CS7, CS8
	//	CLOCAL - Ignore modem status lines
	//	CREAD - Enable receiver
	//	IGNPAR = Ignore characters with parity errors
	//	ICRNL - Map CR to NL on input (Use for ASCII comms where you want to auto correct end of line characters - don't use for bianry comms!)
	//	PARENB - Parity enable
	//	PARODD - Odd parity (else even)
	struct termios options;
	tcgetattr(fd, &options);
//	options.c_cflag = B115200 | CS8 | CLOCAL | CREAD;		//<Set baud rate
	options.c_cflag = speed | CS8 | CLOCAL | CREAD;		//<Set baud rate
	options.c_iflag = IGNPAR;
	options.c_oflag = 0;
	options.c_lflag = 0;

	tcflush(fd, TCIFLUSH);
	tcsetattr(fd, TCSANOW, &options);

	return 0;
}

void handleSignal(int32_t sigNum) {
	
	switch (sigNum) {
		case SIGINT:
		printf("\nEvent: Someone wants to stop application\n");
		exit_flag = 1;
		break;
	default:
		printf("\nEvent: Unregistered signal received: %d\n", sigNum);
		exit(-1);
		break;
	}
}

int32_t register_stop_handler() {

	struct sigaction act;
	act.sa_handler = handleSignal;
	return sigaction(SIGINT, &act, NULL);

}

uint16_t calc_crc16 (uint8_t *buffer, uint32_t size) {
	uint16_t crc = 0, i, j;
	for (j = 0; j < size; ++j) {
		crc ^= buffer[j] << 8;
		for (i = 0; i < 8; ++i) {
			uint16_t next = crc << 1;
			if (crc & 0x8000)
				next ^= 0x1021;
			crc = next;
		}
	}
	return crc;
}

int32_t send_data(int32_t file_descr, uint32_t size, uint8_t* buffer) {

	int32_t ret_val = 0;
    uint32_t count = 0;
    uint32_t sent_bytes = 0;

	if (buffer == NULL)
		return -3;

	do {

        ret_val = write(file_descr, (void*)(buffer + sent_bytes), size - sent_bytes);

	    if (ret_val < 0) {
		    if (errno == EAGAIN) {
			    usleep(100000);
                ++count;
		    } else {

				printf("Sending finished with error: %d\n", errno);
				perror("Error");
				return -1;
			}
	    }
        else if (ret_val == 0) {
            printf("Connection was closed\n");
            perror("Cause");
            return -2;
        }
        else {
            sent_bytes += ret_val;
            count = 0;
        }

    } while (size != sent_bytes && count != STOP_TRIES);

    if (count == STOP_TRIES) {
        return sent_bytes;
    }

	return sent_bytes;
}

int32_t recv_data(int32_t file_descr, uint32_t size, uint8_t* buffer) {
    
    int32_t ret_val = 0;
    uint32_t count = 0;
    uint32_t recv_bytes = 0;

	if (buffer == NULL)
		return -3;

	do {

        ret_val = read(file_descr, (void*)(buffer + recv_bytes), size - recv_bytes);

	    if (ret_val < 0) {
		    if (errno == EAGAIN) {
			    usleep(10000);
                ++count;
		    } else if (errno != 0) {

				printf("Reading finished with error: %d\n", errno);
				perror("Error");
				return -1;
			}
	    }
        else if (ret_val == 0) {
            perror("Event");
            return -2;
        }
        else {
            recv_bytes += ret_val;
            count = 0;
        }

    } while (size != recv_bytes && count != STOP_TRIES);

    if (count == STOP_TRIES) {
        return recv_bytes;
    }

	return recv_bytes;
}

int32_t main(uint32_t argc, char *argv[]) {

	int32_t ret_val = 0;
    char data[DATA_SIZE];

	if (argc < 2) {
		printf("Invalid arguments count\n");
		return 1;
	}

	// O_NDELAY / O_NONBLOCK (same function) - Enables nonblocking mode. 
	// When set read requests on the file can return immediately with a failure status
	// if there is no input immediately available (instead of blocking). 
	// Likewise, write requests can also return immediately 
	// with a failure status if the output can't be written immediately. 
	// O_NOCTTY - When set and path identifies a terminal device, 
	// open() shall not cause the terminal device to become the controlling terminal 
	// for the process. 

	fd = -1;
	fd = open(argv[1], O_RDWR | O_NOCTTY | O_NDELAY); // Open in non blocking read/write mode

	if ( fd == -1 ) {
		printf("Error - Unable to open UART.  Ensure it is not in use by another application\n");
		return 2;
	}

	printf("Register stop handler\n");
	register_stop_handler();

	printf("Configure uart\n");
	configure_uart(fd, B115200);

	printf("Start reading\n");
	while (exit_flag == 0) {

		memset(data, 0, DATA_SIZE);
        ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);	

		if (ret_val > 0) {

			printf("%s", data);
			process_spi(data);
//			process_data(data);
			
		} else if (ret_val == 0) {

			continue;

		} else if (ret_val < 0) {
			break;
		}
		ret_val = 0xFF;
	}
	printf("Connection was closed\n");
	close(fd);
	return 0;
}

int32_t send_frame(int32_t file_descr, uint8_t *data, uint32_t size_to_send) {
	uint8_t			byte = 0;
	uint32_t		i = 0;
	const uint8_t	START = 0xC0;
	const uint8_t	STOP[2] = {0xDB, 0xDB}; 
	const uint8_t	C0[2] = {0xDB, 0xDC};
	const uint8_t	DB[2] = {0xDB, 0xDD};
	uint32_t		buffer_ind = 0;
	uint8_t			*buffer = (uint8_t*)malloc(size_to_send * 2 + 3);

	if (buffer == NULL)
		return -1;

	if (size_to_send == 0) {
		free(buffer);
		return 0;
	}

	buffer[buffer_ind] = START;
	++buffer_ind;

	for (; i < size_to_send; ++i) {

		byte = data[i];

		if (byte == 0xC0) {
			buffer[buffer_ind] = C0[0];
			buffer[buffer_ind + 1] = C0[1];
			buffer_ind += 2;
			continue;

		} else if (byte == 0xDB) {
			buffer[buffer_ind] = DB[0];
			buffer[buffer_ind + 1] = DB[1];
			buffer_ind += 2;
			continue;
		}

		buffer[buffer_ind] = byte;
		++buffer_ind;
	}

		buffer[buffer_ind] = STOP[0];
		buffer[buffer_ind + 1] = STOP[1];
		buffer_ind += 2;
	
	printf("This data will be sent: ");
	i = 0;
	for (; i < buffer_ind; ++i) {
		printf("%02X ", buffer[i]);
	}
	printf("\n");
	
	send_data(fd, buffer_ind, buffer);
	free(buffer);
	return buffer_ind;
}

void process_spi(char* data) {

	int32_t		ret_val = 0;
	size_t		cmd_len = 0;
	char		cmd[2048];

	if (strstr(data, "MC_ALIVE") != NULL) {

		strcpy(cmd, "MC_BOOT_MODE_1\r\n");

		cmd_len = strlen(cmd);
		ret_val = send_data(fd, cmd_len, (uint8_t*)&cmd);
		cmd[cmd_len - 2] = 0;
		if (ret_val == cmd_len)
			printf("OK: Command %s was sent\n", cmd);
		else
			printf("ERROR: Command %s wasn't sent. ret_val=%d\n", cmd, ret_val);

	}

	if (strstr(data, "MC_COMMAND_AWAITING") != NULL) {

		sprintf(cmd, "MC_SPI_WRITE %04X\r\n", pages);

		cmd_len = strlen(cmd);
		ret_val = send_data(fd, cmd_len, (uint8_t*)&cmd);
		cmd[cmd_len - 1] = 0;
		if (ret_val == cmd_len)
			printf("OK: Command %s was sent\n", cmd);
		else
			printf("ERROR: Command %s wasn't sent. ret_val=%d\n", cmd, ret_val);
	}

	if (strstr(data, "MC_SPI_WRITE 0004 ACK") != NULL) {
	
		uint32_t data = 0x12345678;

		ret_val = send_frame(fd, (uint8_t*)&data, sizeof(data));
		if (ret_val > 0)
			printf("OK: Data 0x%08X was sent\n", data);
		else
			printf("ERROR: Data 0x%08X wasn't sent. ret_val=%d\n", data, ret_val);
	}

	if (strstr(data, "REPLY ACK") != NULL) {

		uint32_t data = 0xABCDEF90;

		ret_val = send_frame(fd, (uint8_t*)&data, sizeof(data));
		if (ret_val > 0)
			printf("OK: Data 0x%08X was sent\n", data);
		else
			printf("ERROR: Data 0x%08X wasn't sent. ret_val=%d\n", data, ret_val);
	}

	if (strstr(data, "REPLY NACK") != NULL) {
		printf("OK: Data was rejected\n");
	}

	return;
/******************************/
	if (strstr(data, "MC_SPI_WRITE 0001 ACK") != NULL) {

		uint8_t		spi_data[37] = {0xC0,1,2,3,4,5,6,7,8,   1,0xDB,0xDC,3,4,5,6,7,8,    1,0xDB,0xDD,3,4,5,6,7,8,     1,2,3,4,5,6,7,8, 0xDB,0xDB};
		uint32_t	i = 0; 
		ret_val = send_data(fd, 37, (uint8_t*)&spi_data);

		if (ret_val == 37) {
			printf("Data: ");
			for (; i < 37; ++i) {
				printf("%02X ", spi_data[i]);
			}
			printf("\n");
		}
	/*	if (ret_val == 37)
			printf("OK: Data was sent\n");
		else
			printf("ERROR: Data wasn't sent. ret_val=%d\n", ret_val);
	*/
	}

	if ((strstr(data, "BEG") != NULL)/* && (strstr(data, "END") != NULL)*/) {

		uint32_t i = 0;
		uint8_t *ptr = 0;

		ptr = strstr(data, "BEG");

		printf("Data: ");
		for (ptr += 3; i < 32; ++i) {
			printf("%02X ", ptr[i]);
		}
		printf("\n");
	}

		if (strstr(data, "END") != NULL) {

		uint32_t i = 0;
		uint8_t *ptr = 0;

		ptr = strstr(data, "END");

		printf("Data: ");
		for (ptr += 3; i < 37; ++i) {
			printf("%02X ", ptr[i]);
		}
		printf("\n");
	}
}

void process_data(char* data) {

	int32_t ret_val = 0;

	if(strstr(data, "MC_ALIVE") != NULL) {
//		printf("Status MC_ALIVE was received successfuly\n");

		char boot_mode1[] = "MC_BOOT_MODE_1\r\n";
		ret_val = send_data(fd, strlen(boot_mode1), (uint8_t*)&boot_mode1);

		if (ret_val == strlen(boot_mode1))
			printf("OK: Command MC_BOOT_MODE_1 was sent\n");
		else
			printf("ERROR: Command MC_BOOT_MODE_1 wasn't sent. ret_val=%d\n", ret_val);
	}

	if(strstr(data, "MC_AWAIT_SPI_CMD") != NULL) {
//		printf("Status MC_SPI_CMD_DONE was received successfuly\n");

		char spi_id[] = "MC_SPI_DETECT\r\n";
		ret_val = send_data(fd, strlen(spi_id), (uint8_t*)&spi_id);

		if (ret_val == strlen(spi_id))
			printf("OK: Command MC_SPI_DETECT was sent\n");
		else
			printf("ERROR: Command MC_SPI_DETECT wasn't sent. ret_val=%d\n", ret_val);
	}

	if(strstr(data, "MC_SPI_FLASH_DETECTED") != NULL) {
//		printf("Status MC_SPI_FLASH_DETECTED was received successfuly\n");

		char spi_erase[] = "MC_SPI_ERASE\r\n";
		ret_val = send_data(fd, strlen(spi_erase), (uint8_t*)&spi_erase);

		if (ret_val == strlen(spi_erase))
			printf("OK: Command MC_SPI_ERASE was sent\n");
		else
			printf("ERROR: Command MC_SPI_ERASE wasn't sent. ret_val=%d\n", ret_val);
	}

	if(strstr(data, "MC_SPI_ERASE_DONE") != NULL) {
//		printf("Status MC_SPI_ERASE_DONE was received successfuly\n");

		char spi_write[] = "MC_SPI_WRITE 00000001\r\n";
		ret_val = send_data(fd, strlen(spi_write), (uint8_t*)&spi_write);

		printf("Configure uart\n");
//		configure_uart(fd, B1500000);
	}
	
	if(strstr(data, "MC_NEXT_DATA") != NULL) {
		char spi_data[512];
		memset(spi_data, 0xA5, sizeof(spi_data));
		ret_val = send_data(fd, strlen(spi_data), (uint8_t*)&spi_data);
		printf("OK: Data was sent\n");

	}

}

int32_t spi_flash_write() {
	
	int32_t 	ret_val = 0;
    char 		data[DATA_SIZE];
	size_t		cmd_len = 0;
	char		cmd[2048];
	uint32_t	pages = 4;
	
	if (argc < 2) {
		printf("Invalid arguments count\n");
		return 1;
	}

	// O_NDELAY / O_NONBLOCK (same function) - Enables nonblocking mode. 
	// When set read requests on the file can return immediately with a failure status
	// if there is no input immediately available (instead of blocking). 
	// Likewise, write requests can also return immediately 
	// with a failure status if the output can't be written immediately. 
	// O_NOCTTY - When set and path identifies a terminal device, 
	// open() shall not cause the terminal device to become the controlling terminal 
	// for the process. 

	fd = -1;
	fd = open(argv[1], O_RDWR | O_NOCTTY | O_NDELAY); // Open in non blocking read/write mode

	if ( fd == -1 ) {
		printf("Error - Unable to open UART.  Ensure it is not in use by another application\n");
		return 2;
	}

	printf("Register stop handler\n");
	register_stop_handler();

	printf("Configure uart\n");
	configure_uart(fd, B115200);

	printf("Start communicating\n");

// 1	

	ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);
	if (strstr(data, "MC_ALIVE") != NULL) {

		strcpy(cmd, "MC_BOOT_MODE_1\r\n");

		cmd_len = strlen(cmd);
		ret_val = send_data(fd, cmd_len, (uint8_t*)&cmd);
		cmd[cmd_len - 2] = 0;
		if (ret_val == cmd_len) {
			printf("OK: Command %s was sent\n", cmd);
		} else {
			printf("ERROR: Command %s wasn't sent. ret_val=%d\n", cmd, ret_val);
			return -1;
		}
	
	} else {
		printf("Device isn't ready to receive BOOT_MODE\n");
		return -2;
	}

// 2

	memset(data, 0, DATA_SIZE);
	ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);
	if (strstr(data, "MC_COMMAND_AWAITING") != NULL) {

		sprintf(cmd, "MC_SPI_WRITE %04X\r\n", pages);

		cmd_len = strlen(cmd);
		ret_val = send_data(fd, cmd_len, (uint8_t*)&cmd);
		cmd[cmd_len - 1] = 0;
		if (ret_val == cmd_len) {
			printf("OK: Command %s was sent\n", cmd);
		} else {
			printf("ERROR: Command %s wasn't sent. ret_val=%d\n", cmd, ret_val);
			return -3;
		}
	} else {
		printf("Device isn't ready to receive MC_SPI_WRITE\n");
		return -4;
	}

// 3

	memset(data, 0, DATA_SIZE);
	char nack[128];
	char ack[128];

	sprintf(ack, "MC_SPI_WRITE %04X ACK", pages);
	sprintf(nack, "MC_SPI_WRITE %04X NACK", pages);

	ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);

	if (strstr(data, ack) != NULL) {
		printf("Device is ready to receive 0x%04X pages\n", pages);
	} else if (strstr(data, nack) != NULL) {
		printf("Device isn't ready to receive 0x%04X pages\n", pages);
		return -5
	}

// 4

	uint32_t page = 0;
	uint32_t page_size = 1;
	for (; page < pages; ++page) {

// 4.1
		ret_val = send_frame(fd, (uint8_t*)page_size, sizeof(page_size));

		sprintf(ack, "PAGE_SIZE %04X ACK", page_size);
		sprintf(nack, "PAGE_SIZE %04X NACK", page_size);

		ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);

		if (strstr(data, ack) != NULL) {
			printf("Device is ready to receive 0x%04X bytes of 0x%04X page\n", page_size, page);
		} else if (strstr(data, nack) != NULL) {
			printf("Device isn't ready to receive 0x%04X bytes of 0x%04X page\n", page_size, page);
			return -6
		}

// 4.2
		memset(data, page_size, page_size);

		ret_val = send_frame(fd, (uint8_t*)page_size, sizeof(page_size));

		sprintf(ack, "PAGE_DATA ACK");
		sprintf(nack, "PAGE_DATA NACK");

		ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);

		if (strstr(data, ack) != NULL) {
			printf("Device received 0x%04X page\n", page_size, page);
		} else if (strstr(data, nack) != NULL) {
			printf("Device didn't receive 0x%04X page\n", page_size, page);
			return -7
		}
	}

	printf("Connection was closed\n");
	close(fd);
	return 0;
}
