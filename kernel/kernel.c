void print(char* message);

void kernel_main() {
	char* video_mem = (char*)0xb8000;
	int i;
	print("C kernel loaded!!");
	while(1){}
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