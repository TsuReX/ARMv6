#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>	//Used for UART
#include <fcntl.h>	//Used for UART
#include <termios.h>//Used for UART
#include <stdlib.h>
#include <signal.h>

#include "printregs.h"

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

uint32_t exit_flag = 0;
void handleSignal(int32_t sigNum) {
	
	switch (sigNum) {
		case SIGINT:
		printf("Someone wants to stop application\n");
		exit_flag = 1;
		break;
	default:
		printf("Unregistered signal received: %d\n", sigNum);
		exit(-1);
		break;
	}
}

int32_t register_stop_handler() {

	struct sigaction act;
	act.sa_handler = handleSignal;
	return sigaction(SIGINT, &act, NULL);

}

int32_t handle_pkg(pkg_t *pkg) {
	printf("Package: type = 0x%08X, data = 0x%08X\n", pkg->type, pkg->data);
	if (pkg->type == MEMPRINT) {
		uint8_t *data = (uint8_t*)malloc(pkg->data);
		int32_t rx_length = read(fd, (void*)&data, pkg->data);
		// TODO Handle reading error
		uint32_t words_count = (pkg->data - sizeof(uint32_t)) >> 2;
		uint32_t bytes_count = (pkg->data - sizeof(uint32_t)) & 0x3;
		printf("Package type = 0x%08X\n", pkg->type);
		printf("Package data = 0x%08X\n", pkg->data);
		printf("Start address = 0x%X\n", *(uint32_t*)data);
		printf("Words count = 0x%X\n", words_count);
		printf("Bytes count = 0x%X\n", bytes_count);
		uint32_t i = 0;
		uint32_t* words_ptr = data + sizeof(uint32_t);
		uint32_t word_address = *(uint32_t*)data;
		for (;i < words_count; ++i, word_address += 4, ++words_ptr) {
			printf("0x%08X : 0x%08X\n", word_address, *words_ptr);
		}
		switch(bytes_count) {
			case 1:
				printf("0x%08X : 0x%02X\n", word_address, *words_ptr & 0xFF);
				break;
			case 2:
				printf("0x%08X : 0x%04X\n", word_address, *words_ptr & 0xFFFF);
				break;
			case 3:
				printf("0x%08X : 0x%06X\n", word_address, *words_ptr & 0xFFFFFF);
				break;
			default:
				break;
			}
		}
		free(data);
	}
	return 0;
}

int32_t recv_data(int32_t file_descr, uint8_t* buffer, uint32_t size) {
    
    int32_t ret_val = 0;
    uint32_t count = 0;
    uint32_t recv_bytes = 0;
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

    } while (size != recv_bytes && count != STOP_TRIES)
    
    if (count == STOP_TRIES) {
        return -2;            
    }

    return recv_bytes;
}

int32_t check_header(header_t *header) {
    // TODO    
    return -1;
}

int32_t check_data(uint8_t *data, uint32_t size) {
    // TODO    
    return -1;
}

int32_t process_data(uint8_t *data, uint32_t size) {
    // TODO
    return -1;
}

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
        ret_val = recv_data(fd, sizeof(header_t), &header);
		
        if (ret_val != sizeof(header_t)) {
            // usleep(300000); TODO           
            continue;
        }
        
        if (check_header(&header) != 0) {
            continue;
        }
        
        if (header.size == 0) {
            printf("header.size == 0\n");
            continue;        
        }
        uint8_t* data = (uint8_t*)malloc(header.size);
        
        ret_val = recv_data(fd, header->size, data);
        
        if (ret_val != header->size) {
            // usleep(300000); TODO          
            free(data);            
            continue;
        }
        
        if (check_data(data, header->size) != 0) {
            free(data);            
            continue;
        }
        
        process_data(data, header->size /* - sizeof(uint32_t) */);
        
        free(data);

	}
	close(fd);
	return 0;
}
