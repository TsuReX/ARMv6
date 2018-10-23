#include "stdio.h"
#include "stdint.h"
#include "unistd.h"	//Used for UART
#include "fcntl.h"	//Used for UART
#include "termios.h"	//Used for UART


int32_t configure_uart(int32_t fd){

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


int32_t check_uart_start() {

    int fd = -1;

    //	O_NDELAY / O_NONBLOCK (same function) - Enables nonblocking mode. When set read requests on the file can return immediately with a failure status
    //											if there is no input immediately available (instead of blocking). Likewise, write requests can also return
    //											immediately with a failure status if the output can't be written immediately.
    //
    //	O_NOCTTY - When set and path identifies a terminal device, open() shall not cause the terminal device to become the controlling terminal for the process.
    fd = open("/dev/ttyAMA0", O_RDWR | O_NOCTTY | O_NDELAY);		//Open in non blocking read/write mode
    if (fd == -1) {
	printf("Error - Unable to open UART.  Ensure it is not in use by another application\n");
    }


    int count = write(fd, &tx_buffer[0], (p_tx_buffer - &tx_buffer[0]));		//Filestream, bytes to write, number of bytes to write
    if (count < 0)
    {
	printf("UART TX error\n");
    }
    
    // Read up to 255 characters from the port if they are there
    unsigned char rx_buffer[256];
    int rx_length = read(fd, (void*)rx_buffer, 255);		//Filestream, buffer to store in, number of bytes to read (max)
    if (rx_length < 0)
    {
	//An error occured (will occur if there are no bytes)
    }
    else if (rx_length == 0)
    {
	//No data waiting
    }
    else
    {
	//Bytes received
	rx_buffer[rx_length] = '\0';
	printf("%i bytes read : %s\n", rx_length, rx_buffer);
    }





    //----- CLOSE THE UART -----
    close(fd);

    return 0;
}


int32_t check_uart_stop() {

    return 0;
}


int main() {


	return 0;
}
