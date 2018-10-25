#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <unistd.h>	//Used for UART
#include <fcntl.h>	//Used for UART
#include <termios.h>//Used for UART


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

int32_t main(uint32_t argc, char *argv[]) {

	if (argc < 2) {
		printf("Invalid arguments count\n");
		return 1;
	}
	int32_t fd = -1;

    //	O_NDELAY / O_NONBLOCK (same function) - Enables nonblocking mode. When set read requests on the file can return immediately with a failure status
    //											if there is no input immediately available (instead of blocking). Likewise, write requests can also return
    //											immediately with a failure status if the output can't be written immediately.
    //
    //	O_NOCTTY - When set and path identifies a terminal device, open() shall not cause the terminal device to become the controlling terminal for the process.
	fd = open(argv[1], O_RDWR | O_NOCTTY | O_NDELAY);		//Open in non blocking read/write mode
	if ( fd == -1 ) {
		printf("Error - Unable to open UART.  Ensure it is not in use by another application\n");
		return 2;
	}

	printf("Configure uart\n");
	configure_uart(fd);

	printf("Start reading\n");
	int32_t exit = 0;
	while ( exit !=0 ) {
		uint32_t data = 0;
		uint32_t rx_length = read(fd, (void*)&data, 4);
		if ( rx_length < 0 ) {
			//An error occured (will occur if there are no bytes)
			printf("Reading finished with error: %d\n", errno);
			return 3;
		}
		else if ( rx_length == 0 ) {
			printf("No data\n");
		}
		else {
			//Bytes received;
			printf("Read data: 0x%08X\n", data);
		}
		sleep(1);
	}
	close(fd);
	return 0;
}
