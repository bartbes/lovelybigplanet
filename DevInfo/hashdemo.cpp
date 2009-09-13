#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	int enclength;
	char *data;
	if (argc == 1)
	{
		printf("Usage: %s [-f] <text | filename>\n", argv[0]);
		return 1;
	} else if (argc == 3) {
		FILE *f = fopen(argv[2], "r");
		fseek(f, 0, SEEK_END);
		enclength = ftell(f);
		fseek(f, 0, SEEK_SET);
		data = new char[enclength+1];
		fread(data, 1, enclength, f);
		fclose(f);
	} else {
		enclength = strlen(argv[1]);
		data = new char[enclength+1];
		strcpy(data, argv[1]);
	}
	int length = 12;
	int looplength = enclength + length - enclength%length;
	unsigned char result[13];
	memset(result, 0, 13);
	for (int i = 0; i < looplength; i++)
	{
		result[i%length] ^= ((data[i%enclength] >> (i/length)) + i);
	}
	//printf("Result: %s\n", result);
    for (int i = 0; i < length; i++)
	{
		printf("%02x", result[i]);
	}
	printf("\n");
	delete[] data;
}
