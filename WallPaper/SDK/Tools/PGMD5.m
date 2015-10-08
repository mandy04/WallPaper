//
//  PG_MD5.m
//  SinaWeboTest
//
//  Created by iOS_Tea on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PGMD5.h"

@implementation PGMD5

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


- (unsigned char *)_md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
//    unsigned char *md5 = (unsigned char*)[iStr UTF8String];
    unsigned char *md5 = (unsigned char *)malloc(1024);
    memset(md5, 0, 1024);
    CC_MD5(cStr, (unsigned int)strlen(cStr), md5);

    return md5;
}

- (NSString *)MD5:(NSString *)orgStr
{
    unsigned char *md5CStr = [self _md5:orgStr];

    NSString *outPutStr = [[NSString alloc] initWithCString:(const char *)md5CStr
                                                   encoding:NSUTF8StringEncoding];

    free(md5CStr);

    return outPutStr;
}

- (NSString *)MD5:(NSString *)orgStr key:(NSString *)key encode:(NSStringEncoding)encode
{
    NSMutableString *outStr = [[NSMutableString alloc] initWithCapacity:10];

    const char *keyBytes = NULL;
    NSUInteger len = 0;
    if (key != nil&& [key length] > 0)
    {
        NSData *data = [key dataUsingEncoding:encode];
        len = [data length];
        keyBytes = [key UTF8String];
    }
    unsigned char *md5CStr = [self _md5:orgStr];
    int leno = 16;
    Byte ch, ch1, ch2;
    for (int i = 0; i < leno; i++)
    {
        if (keyBytes != NULL)
        {
            ch1 = md5CStr[i];
            ch2 = keyBytes[i % len];
            ch = (Byte)(ch1 ^ ch2);
        }
        else
        {
            ch = md5CStr[i];
        }
        [outStr appendFormat:@"%02x", ch];
    }
    free(md5CStr);
//    NSLog(@"--%@--",outStr);
    return outStr;
}

@end
