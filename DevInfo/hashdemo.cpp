#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("Usage: %s <text>\n", argv[0]);
		return 1;
	}
	int enclength = strlen(argv[1]);
	int length = 12;
	int looplength = enclength + length - enclength%length;
	unsigned char result[13];
	memset(result, 0, 13);
	for (int i = 0; i < looplength; i++)
	{
		result[i%length] ^= ((argv[1][i%enclength] >> (i/length)) + i);
	}
	//printf("Result: %s\n", result);
    for (int i = 0; i < length; i++)
	{
		printf("%02x", result[i]);
	}
	printf("\n");
}
