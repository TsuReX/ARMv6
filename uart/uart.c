#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>	//Used for UART
#include <fcntl.h>	//Used for UART
#include <termios.h>//Used for UART
#include <stdlib.h>
#include <signal.h>

#include "printregs.h"

const uint32_t STOP_TRIES = 10;

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

uint32_t exit_flag = 0;
void handleSignal(int32_t sigNum) {

	switch (sigNum) {
		case SIGINT:
		printf("\nSomeone wants to stop application\n");
		exit_flag = 1;
		break;
	default:
		printf("\nUnregistered signal received: %d\n", sigNum);
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
			    usleep(300000);
                ++count;
		    }
		    //An error occured (will occur if there are no bytes)
		    printf("Reading finished with error: %d\n", errno);
		    return -1;
	    }
        else if (ret_val == 0) {
            // TODO
            printf("ret_val == 0 !!!!!!!!!!!\n");
            return -10;
        }
        else {
            recv_bytes += ret_val;
            count = 0;
        }

    } while (size != recv_bytes && count != STOP_TRIES);

    if (count == STOP_TRIES) {
        return -2;            
    }

	return recv_bytes;
}

/*
int32_t check_header(header_t *header) {
	
	if (header == NULL)
		return -2;

	if (header->crc16 == calc_crc16((uint8_t*)(header + sizeof(uint32_t)), sizeof(header_t))) {
		return 0;
	}

	return -1;
}

int32_t check_data(uint8_t *data, uint32_t size) {
	
	if (data == NULL)
		return -3;

	if (size <= sizeof(uint32_t)){
			return -2;
	}

	if (*(uint32_t*)(data + size - sizeof(uint32_t)) == calc_crc16(data, size - sizeof(uint32_t))) {
		return 0;
	}

	return -1; 
}
*/

int32_t main(uint32_t argc, char *argv[]) {

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
	int32_t fd = -1;
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

    int32_t ret_val = 0;
	while (exit_flag == 0) {

		header_t header;
		ret_val = recv_data(fd, sizeof(header_t), (uint8_t*)&header);
		// TODO Handle broken connection error
        if (ret_val != sizeof(header_t)) {
            // usleep(300000); TODO
            printf("DBG: 1\n");
            continue;
        }

		/********************/

		/* FOR DEBUG */
		if (header.size > 128) {
			printf("Data amount is greather than 128 bytes\n");
			continue;
		}

        uint8_t* data = (uint8_t*)malloc(header.size);
        if (data == NULL) {
			// TODO correct output text
			printf("Not enough memory\n");
			return -1;
		}

        ret_val = recv_data(fd, header.size, data);

        if (ret_val != header.size) {
            // usleep(300000); TODO
            free(data);
            printf("DBG: 2\n");
            continue;
        }

		/********************/

        tail_t tail;
        ret_val = recv_data(fd, sizeof(tail_t), (uint8_t*)&tail);

        if (ret_val != sizeof(tail_t)) {
            // usleep(300000); TODO
            free(data);
            printf("DBG: 3\n");
            continue;
        }

		/********************/

        if (tail.tail_magic != 0xABC5DEF9) {
			free(data);
			printf("DBG: 4\n");
			continue;
		}

        process_data(data, &header);

        free(data);

	}
	close(fd);
	return 0;
}
