//
//  XLDeviceManager.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLDeviceManager.h"

static XLDeviceManager *s_deviceManager = nil;

@implementation XLDeviceManager
{

}

+ (XLDeviceManager *)sharedDeviceManager
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{

        s_deviceManager = [[XLDeviceManager alloc] init];

    });

    return s_deviceManager;
}

- (NSString *)uid
{
    return [OpenUDID value];
}

/**
 *  是否是iOS7以上的版本
 *
 *  @return 是否是iOS7以上版本
 */
- (BOOL)isIOS7
{
    return (([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedSame) ||
            ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedDescending));
}
@end
