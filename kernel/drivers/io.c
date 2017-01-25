#include "io.h"

uint8_t in_byte (uint16_t port) 
{
	uint8_t data;
    asm volatile ("inb %[port], %[data]"
        : [data] "=a" (data)
        : [port] "dN" (port));

    return data;
}

void out_byte (uint16_t port, uint8_t data) 
{
	asm volatile ("outb %[data], %[port]"
		: /*no output*/
		: [data] "a" (data),
		  [port] "dN" (port));
}

uint16_t in_word (uint16_t port) 
{
	uint16_t data;
    asm volatile ("inw %[port], %[data]"
        : [data] "=a" (data)
        : [port] "dN" (port));

    return data;
}

void out_word (uint16_t port, uint16_t data)
{
	asm volatile ("outw %[data], %[port]"
		: /*no output*/
		: [data] "a" (data),
		  [port] "dN" (port));
}