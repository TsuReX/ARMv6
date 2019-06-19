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

#define STOP_TRIES	10
#define DATA_SIZE	64

uint32_t exit_flag = 0;
int32_t fd = -1;

int32_t configure_uart(int32_t fd) {

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
	options.c_cflag = B115200 | CS8 | CLOCAL | CREAD;		//<Set baud rate
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

uint16_t calc_crc16 (uint8_t *buffer, uint32_t size)
{
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
	configure_uart(fd);

	printf("Start reading\n");
	while (exit_flag == 0) {

		memset(data, 0, DATA_SIZE);
        ret_val = recv_data(fd, DATA_SIZE - 1, (uint8_t*)&data);	

		if (ret_val > 0) {

			printf("%s", data);
			process_data(data);
			
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

void process_data(char* data) {

	int32_t ret_val = 0;

	if(strstr(data, "MC_ALIVE") != NULL) {
		char boot_mode1[] = "MC_BOOT_MODE_1\r\n";
		ret_val = send_data(fd, strlen(boot_mode1), (uint8_t*)&boot_mode1);
		printf("Status MC_ALIVE was received successfuly\n");
		if (ret_val == strlen(boot_mode1))
			printf("OK: Command MC_BOOT_MODE_1 was sent\n");
		else
			printf("ERROR: Command MC_BOOT_MODE_1 wasn't sent. ret_val=%d\n", ret_val);
	}

	if(strstr(data, "MC_AWAIT_SPI_CMD") != NULL) {
		char spi_id[] = "MC_SPI_DETECT\r\n";
		ret_val = send_data(fd, strlen(spi_id), (uint8_t*)&spi_id);
		printf("Status MC_SPI_CMD_DONE was received successfuly\n");
		if (ret_val == strlen(spi_id))
			printf("OK: Command MC_SPI_DETECT was sent\n");
		else
			printf("ERROR: Command MC_SPI_DETECT wasn't sent. ret_val=%d\n", ret_val);
	}

	if(strstr(data, "MC_SPI_FLASH_DETECTED 01 20 18 4D") != NULL) {
		char spi_erase[] = "MC_SPI_ERASE\r\n";
		ret_val = send_data(fd, strlen(spi_erase), (uint8_t*)&spi_erase);
		printf("Status MC_SPI_FLASH_DETECTED was received successfuly\n");
		if (ret_val == strlen(spi_erase))
			printf("OK: Command MC_SPI_ERASE was sent\n");
		else
			printf("ERROR: Command MC_SPI_ERASE wasn't sent. ret_val=%d\n", ret_val);
	}

/*	if(strstr(data, "MC_SPI_ERASE_DONE") != NULL) {
	char spi_erase[] = "MC_SPI_WRITE\r\n";
	ret_val = send_data(fd, strlen(spi_id), (uint8_t*)&spi_id);
	printf("Status MC_SPI_FLASH_DETECTED was received successfuly\n");
	if (ret_val == strlen(spi_id))
		printf("OK: Command MC_SPI_WRITE was sent\n");
	else
		printf("ERROR: Command MC_SPI_WRITE wasn't sent. ret_val=%d\n", ret_val);
	}
*/

}
