/**
 * Search for the Kember Identity!
 *
 * @author: Tim Cheeseman
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <openssl/md5.h>
#include <gmp.h>

#define MD5_BITS	128		/* 128 bit hash */
#define MD5_BYTES	MD5_BITS / 8	/* 16 byte hash */
#define MD5_STR_LEN	MD5_BITS / 4	/* 32 character hash string */
#define HEX_BASE	16		/* hex radix */

/**
 * Convert a byte array into a hex string.
 *
 * @param buf:
 *	the buffer to hold the hex string. must have space for at least
 * 	num_bytes * 2 chars as each byte represents 2 hex characters
 *
 * @param byte_array:
 *	the byte array to be converted into a hex string
 *
 * @param num_bytes:
 *	the size of the byte array
 *
 * @return:
 *	the number of bytes successfully converted to hex chars
 */
int hex_str(char* buf, unsigned char byte_array[], size_t num_bytes);

/**
 * Start at a random md5 hash and search through all possible hashes to find
 * a string that hashes to itself.
 */
int main(void)
{
	/* there are 2^128 possible md5 hashes */
	mpz_t max;
	mpz_init(max);
	mpz_ui_pow_ui(max, 2, MD5_BITS);

	/* initialize PRNG with MT algorithm and seed with time */
	gmp_randstate_t rand_state;
	gmp_randinit_mt(rand_state);
	gmp_randseed_ui(rand_state, time(NULL));
	
	/* pick a random one to start with and free PRNG memory */
	mpz_t start;
	mpz_init(start);
	mpz_urandomb(start, rand_state, MD5_BITS);
	gmp_randclear(rand_state);

	printf("Starting with random string: \"");
	mpz_out_str(stdout, HEX_BASE, start);
	printf("\"\n");
	
	/* current hash */
	mpz_t current;
	mpz_init_set(current, start);

	/* get ready to calculate hashes */
	MD5_CTX md5_ctx;
	unsigned char input[MD5_BYTES];
	unsigned char digest[MD5_BYTES];
	char input_str[MD5_STR_LEN + 1];
	char digest_str[MD5_STR_LEN + 1];

	/* search from start until max */
	while(mpz_cmp(current, max) < 0)
	{
		/* initialize MD5 and get current as an unsigned char[] */
		MD5_Init(&md5_ctx);
		mpz_export(input, NULL, 1, 1, 0, 0, current);
		
		/* hash the input string */
		hex_str(input_str, input, MD5_BYTES);
		MD5_Update(&md5_ctx, input_str, MD5_STR_LEN);
		MD5_Final(digest, &md5_ctx);

		/* check for a match */
		if(strncmp(input, digest, MD5_BYTES) == 0)
		{
			/* we have a winner! */
			hex_str(digest_str, digest, MD5_BYTES);
			printf("md5(\"%s\") = \"%s\"\n", input_str, digest_str);
		}

		/* keep looking */
		mpz_add_ui(current, current, 1);
	}

	/* now search backwards from start */
	mpz_set(current, start);
	mpz_sub_ui(current, current, 1);

	while(mpz_cmp_ui(current, 0) >= 0)
	{
		/* initialize MD5 and get current as an unsigned char[] */
		MD5_Init(&md5_ctx);
		mpz_export(input, NULL, 1, 1, 0, 0, current);
		
		/* hash the input string */
		hex_str(input_str, input, MD5_BYTES);
		MD5_Update(&md5_ctx, input_str, MD5_STR_LEN);
		MD5_Final(digest, &md5_ctx);

		/* check for a match */
		if(strncmp(input, digest, MD5_BYTES) == 0)
		{
			/* we have a winner! */
			hex_str(digest_str, digest, MD5_BYTES);
			printf("md5(\"%s\") = \"%s\"\n", input_str, digest_str);
		}

		/* keep looking */
		mpz_sub_ui(current, current, 1);
	}

	/* clean up */
	mpz_clear(max);
	mpz_clear(start);
	mpz_clear(current);
}

int hex_str(char* buf, unsigned char byte_array[], size_t num_bytes)
{
	int i;

	for(i = 0; i < num_bytes; i++)
		snprintf(buf + (i * 2), 3, "%02x", byte_array[i]);

	return i;
}


