#include <stdio.h>
#include <stdlib.h>
#include <openssl/md5.h>

#define BUF_SIZE 16

void populate(unsigned char *message)
{
	int i;
	unsigned short int num;
	char* pmessage = &message[0];
	srand(time(NULL));
	for (i = 0; i < 8; i++) {
		num = ((double)rand()/((double)(RAND_MAX)+(double)(1)))*65536;
		*pmessage = num;
		pmessage += 2;
	}
}

inline void increment(char* pbuf)
{
	int i;
	for (i = 0; i < BUF_SIZE; i++) {
		*pbuf++;
		if (*pbuf != 0) {
			break;
		}
		pbuf++;
	}
}

int main()
{
	unsigned char message[BUF_SIZE];
	unsigned char md5[BUF_SIZE];
	int i;
	MD5_CTX md5_state;

	populate(message);
	do {	
		MD5_Init(&md5_state);
		MD5_Update(&md5_state, message, BUF_SIZE);
		MD5_Final(md5, &md5_state);

		increment((char *)message);
		length++;
	} while (memcmp(message,md5,16) != 0);

	printf("md5 is:");
	for(i =0; i < BUF_SIZE; i++)
		printf("%02x",md5[i]);
	printf("\n");

	return 0;
} 
