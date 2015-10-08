//
//  XLWXShareManager.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-17.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@class DLWallPaper;
//分享到微信
@interface XLWXShareManager : NSObject <WXApiDelegate>


+ (XLWXShareManager *)sharedManager;

/**
 *  用于微信SDK
 */
@property (nonatomic, weak) id<WXApiDelegate> pWXDelegate;
@property (nonatomic, strong) DLWallPaper *wallPaper;

- (BOOL)startShareToWX:(UIImage *)aImage;
- (BOOL)handOpenURL:(NSURL *)url;
@end
