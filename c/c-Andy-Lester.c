/* Stolen shamelessly from c-Chaz-Schlarp.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define PROGRESS_MOD (1024*64)

const unsigned int T[64] = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
};

const unsigned int passdata[128] = {
    0, 7, 1, 12, 2, 17, 3, 22, 4, 7, 5, 12, 6, 17, 7, 22, 8, 7, 9, 12, 10, 17, 11, 22, 12, 7, 13, 12, 14, 17, 15, 22,
    1, 5, 6, 9, 11, 14, 0, 20, 5, 5, 10, 9, 15, 14, 4, 20, 9, 5, 14, 9, 3, 14, 8, 20, 13, 5, 2, 9, 7, 14, 12, 20,
    5, 4, 8, 11, 11, 16, 14, 23, 1, 4, 4, 11, 7, 16, 10, 23, 13, 4, 0, 11, 3, 16, 6, 23, 9, 4, 12, 11, 15, 16, 2, 23,
    0, 6, 7, 10, 14, 15, 5, 21, 12, 6, 3, 10, 10, 15, 1, 21, 8, 6, 15, 10, 6, 15, 13, 21, 4, 6, 11, 10, 2, 15, 9, 21
};

typedef struct md5_state_s {
    unsigned int count[2];
    unsigned int abcd[4];
    unsigned char buf[64];
} md5_state_t;

static void md5_process(md5_state_t *pms, const unsigned char *data)
{
    unsigned int a = pms->abcd[0];
    unsigned int b = pms->abcd[1];
    unsigned int c = pms->abcd[2];
    unsigned int d = pms->abcd[3];
    unsigned int t;
    unsigned int xbuf[16];
    const unsigned int *X;
    int pass = 0;

    if(!((data - (const unsigned char *)0) & 3)) {
        X = (const unsigned int *)data;
    }
    else {
        memcpy(xbuf, data, 64);
        X = xbuf;
    }
    for(pass = 0; pass < 16; pass++) {
#define SET(a, b, c, d, k, s, Ti) t = a + (pass < 4 ? (((b) & (c)) | (~(b) & (d))) : (pass < 8 ? (((b) & (d)) | ((c) & ~(d))) : (pass < 12 ? ((b) ^ (c) ^ (d)) : ((c) ^ ((b) | ~(d)))))) + X[k] + Ti; a = (((t) << (s)) | ((t) >> (32 - (s)))) + b
        SET(a, b, c, d, passdata[pass*8+0], passdata[pass*8+1], T[pass*4+0]);
        SET(d, a, b, c, passdata[pass*8+2], passdata[pass*8+3], T[pass*4+1]);
        SET(c, d, a, b, passdata[pass*8+4], passdata[pass*8+5], T[pass*4+2]);
        SET(b, c, d, a, passdata[pass*8+6], passdata[pass*8+7], T[pass*4+3]);
#undef SET
    }
    pms->abcd[0] += a;
    pms->abcd[1] += b;
    pms->abcd[2] += c;
    pms->abcd[3] += d;
}

void md5_init(md5_state_t *pms)
{
    pms->count[0] = 0;
    pms->count[1] = 0;
    pms->abcd[0] = 0x67452301;
    pms->abcd[1] = 0xefcdab89;
    pms->abcd[2] = 0x98badcfe;
    pms->abcd[3] = 0x10325476;
}

void md5_append(md5_state_t *pms, const unsigned char *data, int nbytes)
{
    const unsigned char *p = data;
    const int offset       = (pms->count[0] >> 3) & 63;
    unsigned int nbits     = (unsigned int)(nbytes << 3);
    int left               = nbytes;

    if (nbytes <= 0) {
        return;
    }
    pms->count[1] += nbytes >> 29;
    pms->count[0] += nbits;
    if (pms->count[0] < nbits) {
        pms->count[1]++;
    }
    if (offset) {
        const int copy = (offset + nbytes > 64 ? 64 - offset : nbytes);
        memcpy(pms->buf + offset, p, copy);
        if (offset + copy < 64) {
            return;
        }
        p += copy;
        left -= copy;
        md5_process(pms, pms->buf);
    }
    for(; left >= 64; p += 64, left -= 64) {
        md5_process(pms, p);
    }

    if (left) {
        memcpy(pms->buf, p, left);
    }
}

void md5_finish(md5_state_t *pms, unsigned char digest[16])
{
    static const unsigned char pad[64] = {
        128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    };
    unsigned char data[8];
    int i;

    for (i = 0; i < 8; ++i) {
        data[i] = (unsigned char)(pms->count[i >> 2] >> ((i & 3) << 3));
    }

    md5_append(pms, pad, ((55 - (pms->count[0] >> 3)) & 63) + 1);
    md5_append(pms, data, 8);
    for(i = 0; i < 16; ++i) {
        digest[i] = (unsigned char)(pms->abcd[i >> 2] >> ((i & 3) << 3));
    }
}

const char * md5(const char *input, int inputlength)
{
    md5_state_t state;
    static unsigned char digest[16];
    static char hex_output[16*2 + 1];
    int di;

    md5_init(&state);
    md5_append(&state, (const unsigned char *)input, inputlength);
    md5_finish(&state, digest);
    for (di = 0; di < 16; ++di) {
        sprintf(hex_output + di * 2, "%02x", digest[di]);
    }
    return hex_output;
}

int main( void )
{
    static const char digits[] = "0123456789ABCDEF";
    long ntries = 0;
    char source[33];
    int i;

    srand(time(NULL));
    memset( source, 0, sizeof( source ) );
    for ( i = 0; i < 32; i++ ) {
        source[ i ] = digits[ rand() % 16 ];
    }

    while (1) {
        if ( ntries % PROGRESS_MOD == 0 ) {
            printf( "# %ld tries, trying %s\n", ntries, source );
        }
        ++ntries;

        const char * const calculated_md5 = md5( source, 32 );
        if ( memcmp( calculated_md5, source, 32 ) == 0 ) {
            printf("We found it: %s matches %s\n", source, calculated_md5 );
            exit(0);
        }
        /* Rather than come up with all random digits, we just randomize one digit */
        memcpy( source, calculated_md5, 32 );
        source[ rand() % 32 ] = digits[ rand() % 16 ];
    }
    return 0;
}
