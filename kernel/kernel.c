#include <stdint.h>
#include "drivers/io.h"

#define FRAMEBUF_CMD_PORT	0x3d4
#define FRAMEBUF_DATA_PORT	0x3d5

void glitch() {
	char* video_buffer = (char*)0xb8000;
	static int i = 0;
	video_buffer[i%(80*50)] = i;

	i++;
}

void print(char* message) {
	char* video_buffer = (char*)0xb8000;
	char* next = message;
	while (*next) {
		*video_buffer = *next;
		next++;
		video_buffer+=2;
	}
}

void kernel_main() {
	char* video_mem = (char*)0xb8000;
	int i;
	//print("C kernel loaded!!");
	
	/*
	while(1){
		glitch();
	}*/

	// get framebuffer cursor position
	uint16_t cursor_position;
	
	out_byte(FRAMEBUF_CMD_PORT, 14); //Cursor High Byte
	cursor_position = (in_byte(FRAMEBUF_DATA_PORT) << 8);
	out_byte(FRAMEBUF_CMD_PORT, 15); //Cursor Low Byte
	cursor_position += in_byte(FRAMEBUF_DATA_PORT);

	uint8_t color = 0x0;
	while(1) {
		cursor_position++;
		if (cursor_position > 2000) cursor_position = 0;

		out_byte(FRAMEBUF_CMD_PORT, 14); //Cursor High Byte
		out_byte(FRAMEBUF_DATA_PORT, ((cursor_position >> 8) & 0x00ff));
		out_byte(FRAMEBUF_CMD_PORT, 15); //Cursor Low Byte
		out_byte(FRAMEBUF_DATA_PORT, cursor_position & 0x00ff);

		//write a char at the cursor, why not
		int vga_position = cursor_position*2;

		video_mem[vga_position] = 'X';
		video_mem[vga_position+1] = color;

		color++;
		if (color > 0x0f) color = 0x0;

		//for (int i = 0; i < 10000; ++i) {}
	}
}