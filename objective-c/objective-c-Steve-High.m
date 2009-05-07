#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

#define NUMBER_OF_CHECKS 1000

int main(int argc, char *argv[]) {

    NSArray *dict = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", nil];
    
    int j = 0;
    while (j < NUMBER_OF_CHECKS) {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSMutableString *phrase = [NSMutableString stringWithCapacity:32];
        
        for (int i = 0; i < 32; i++) {
            [phrase appendString:[dict objectAtIndex:(arc4random()%16)]];
        }
        
        const char *src = [phrase UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(src, strlen(src), result);
        
        NSString *hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ];
        NSLog(@"source: %@    hash:%@", phrase, hash);
        
        j++;
        
        if (NSOrderedSame == [phrase localizedCaseInsensitiveCompare:hash]) {
            NSLog(@"OMFG you found it!!!\n%@");
            return 0;
        }
        
        [pool release];
    }
    
    return 0;
}

