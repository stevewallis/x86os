#include <stdint.h>
#include "drivers/io.h"

void print(char* message);
void glitch();

void kernel_main() {
	char* video_mem = (char*)0xb8000;
	int i;
	//print("C kernel loaded!!");
	while(1){
		glitch();
	}
}


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