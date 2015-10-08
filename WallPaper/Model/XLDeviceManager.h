//
//  XLDeviceManager.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenUDID.h"

@interface XLDeviceManager : NSObject
{

}

+ (XLDeviceManager *)sharedDeviceManager;

- (NSString *)uid;

- (BOOL)isIOS7;
@end
