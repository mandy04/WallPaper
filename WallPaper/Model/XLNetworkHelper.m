//
//  XLNetworkHelper.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLNetworkHelper.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "PGGTMBase64.h"

static XLNetworkHelper *s_networkHelper = nil;

//第一次网络请求时间
static NSDate *startData;

@implementation XLNetworkHelper
{

}

+ (id)sharedNetworkHelper
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{

        s_networkHelper = [[XLNetworkHelper alloc] init];
    });

    return s_networkHelper;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        startData = [NSDate date];
    }

    return self;
}

/**
 *  通过参数列表计算签名字段
 *
 *  @param parmDic 参数列表，必须包含uid和method
 *
 *  @return 加密后的签名字符串
 */
- (NSString *)getSigStrWithDic:(NSDictionary *)parmDic
{
    NSString *methodStr = [parmDic valueForKey:kMethod];
    NSString *uidStr = [parmDic valueForKey:kUid];

    if ((methodStr == nil) || (uidStr == nil))
    {
        return nil;
    }

    NSString *orgSigStr = [NSString stringWithFormat:@"%@%@%@", methodStr, uidStr, kServerPublicKey];
    PGMD5 *md5 = [[PGMD5 alloc] init];

    NSString *sigStr = [md5 MD5:orgSigStr
                            key:nil
                         encode:NSUTF8StringEncoding];

    return sigStr;
}

- (void)startCheckMaxVersion
{
    NSURL *hostUrl = [NSURL URLWithString:kServerHost];

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:hostUrl];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:10];

    NSString *uidStr = [[XLDeviceManager sharedDeviceManager] uid];

    [paramDic setValue:uidStr forKey:kUid];
    [paramDic setValue:@"getMaxVersion" forKey:kMethod];

    NSString *sig = [self getSigStrWithDic:paramDic];

    if (sig != nil)
    {
        [paramDic setValue:sig forKey:kSig];
    }

    NSMutableURLRequest *request = [client requestWithMethod:kGetMethod
                                                        path:nil
                                                  parameters:paramDic];

    [request setTimeoutInterval:RequestTimeOut];

    void (^const success)(AFHTTPRequestOperation *, id)
    = ^(AFHTTPRequestOperation *operation
        , id responseObject) {

        NSError *jsonAnalysisError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:kNilOptions
                                                                  error:&jsonAnalysisError];
        NSLog(@"json dic = %@", jsonDic);

        if ([[jsonDic valueForKey:kState] intValue] == 200)
        {
            NSString *maxVersionStr = [jsonDic valueForKey:kMaxVersion];

            if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(didFinishGetMaxVersion:)]))
            {
                [self.delegate didFinishGetMaxVersion:maxVersionStr];
            }
        }
    };

    void (^const failure)(AFHTTPRequestOperation *, NSError *)
    = ^(AFHTTPRequestOperation *operation
        , NSError *error) {

        NSLog(@"fail error = %@", error);

        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(didNetworkError:)]))
        {
            [self.delegate didNetworkError:error];
        }
    };

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [requestOperation setCompletionBlockWithSuccess:success
                                            failure:failure];
    
    [requestOperation start];
}

- (void)startGetAllWallPaperList
{
    NSURL *hostUrl = [NSURL URLWithString:kServerHost];

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:hostUrl];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:10];

    NSString *uidStr = [[XLDeviceManager sharedDeviceManager] uid];

    [paramDic setValue:uidStr forKey:kUid];
    [paramDic setValue:@"getAllList" forKey:kMethod];

    NSString *sig = [self getSigStrWithDic:paramDic];

    if (sig != nil)
    {
        [paramDic setValue:sig forKey:kSig];
    }

    NSMutableURLRequest *request = [client requestWithMethod:kGetMethod
                                                        path:nil
                                                  parameters:paramDic];

    [request setTimeoutInterval:RequestTimeOut];

    void (^const success)(AFHTTPRequestOperation *, id)
    = ^(AFHTTPRequestOperation *operation
        , id responseObject) {

        NSError *jsonAnalysisError = nil;
//        NSString *resutStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:kNilOptions
                                                                  error:&jsonAnalysisError];
        NSLog(@"json dic = %@", jsonDic);

        NSArray *resultArr = [NSArray array];

        if ([[jsonDic valueForKey:kState] intValue] == 200)
        {
            NSArray *dataArr = [jsonDic valueForKey:kData];

            if ((dataArr != nil) && ([dataArr count] > 0))
            {
                resultArr = dataArr;
            }
        }

        if ((self.delegate != nil) &&
            ([self.delegate respondsToSelector:@selector(didFinishGetAllWallPaperList:)]))
        {
            [self.delegate didFinishGetAllWallPaperList:resultArr];
        }
    };

    void (^const failure)(AFHTTPRequestOperation *, NSError *)
    = ^(AFHTTPRequestOperation *operation
        , NSError *error) {

        NSLog(@"fail error = %@", error);

        if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(didNetworkError:)]))
        {
            [self.delegate didNetworkError:error];
        }
    };

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [requestOperation setCompletionBlockWithSuccess:success
                                            failure:failure];

    [requestOperation start];
}


/**
 *  给图片地址添加七牛的签名算法
 *
 *  @param aImageUrl 原始图片地址
 *
 *  @return 签名之后可以直接下载的图片地址
 */
+ (NSString *)imageUrlWithSig:(NSString *)aImageUrl
{
    NSMutableString *resUrl = [[NSMutableString alloc] initWithString:aImageUrl];

    //过期时间默认为3600秒
    NSDate *longDate = [startData dateByAddingTimeInterval:3600];

    [resUrl appendFormat:@"?e=%.0f", [longDate timeIntervalSince1970]];
    NSString *keyStr = kQiNiuKey;
    NSString *sig = [XLNetworkHelper hmacSha1:keyStr
                                         text:resUrl];

    [resUrl appendFormat:@"&token=%@:%@",kQiNiuSecret, sig];

    return resUrl;
}

/**
 *  hac sha1 base64算法
 *
 *  @param key
 *  @param text
 *
 *  @return
 */
+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];

    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    NSData *base64Data = [PGGTMBase64 encodeData:HMAC];

    NSString *hash = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];

    hash = [hash stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    hash = [hash stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    return hash;
}

@end
