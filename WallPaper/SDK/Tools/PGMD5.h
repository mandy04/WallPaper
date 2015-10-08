//
//  PG_MD5.h
//  SinaWeboTest
//
//  Created by iOS_Tea on 11-7-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface PGMD5 : NSObject
{
}

- (NSString *)MD5:(NSString *)orgStr;

- (NSString *)MD5:(NSString *)orgStr key:(NSString *)key encode:(NSStringEncoding)encode;
@end
