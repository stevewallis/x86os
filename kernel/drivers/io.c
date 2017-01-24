#include "io.h"

uint8_t port_byte_in (uint16_t port) 
{
	uint8_t data;
    asm volatile ("inb %[port], %[data]"
        : [data] "=a" (data)
        : [port] "dN" (port));

    return data;
}

void port_byte_out (uint16_t port, uint8_t data) 
{
	asm volatile ("outb %[data], %[port]"
		: /*no output*/
		: [data] "a" (data),
		  [port] "dN" (port));
}

uint16_t port_word_in (uint16_t port) 
{
	uint16_t data;
    asm volatile ("inw %[port], %[data]"
        : [data] "=a" (data)
        : [port] "dN" (port));

    return data;
}

void port_word_out (uint16_t port, uint16_t data)
{
	asm volatile ("outw %[data], %[port]"
		: /*no output*/
		: [data] "a" (data),
		  [port] "dN" (port));
}