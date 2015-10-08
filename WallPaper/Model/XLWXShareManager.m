//
//  XLWXShareManager.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-17.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLWXShareManager.h"
#import "WXApi.h"
#import "PGImageUtility.h"
#import "Global.h"
#import "DLWallPaper.h"

static XLWXShareManager *s_wxShareManager = nil;

@implementation XLWXShareManager

+ (XLWXShareManager *)sharedManager
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{

        s_wxShareManager = [[XLWXShareManager alloc] init];
        
    });

    return s_wxShareManager;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        //注册微信
        [WXApi registerApp:kWechatURLScheme];
    }

    return self;
}

//开始分享到微信
- (BOOL)startShareToWX:(UIImage *)aImage
{
    BOOL isInstallWX = NO;

    if ([WXApi isWXAppInstalled])
    {
        if ([WXApi isWXAppSupportApi])
        {
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            [req setBText:NO];
            [req setScene:WXSceneTimeline]; //分享到微信朋友圈

            //不需要执行服务端相关流程，直接组建微信分享接口需要的对象
            WXImageObject *sendImageObject = [WXImageObject object];
            [sendImageObject setImageData:UIImageJPEGRepresentation(aImage, 1.0)];

            WXMediaMessage *sendImageMessage = [WXMediaMessage message];

            NSString *title = [NSString stringWithFormat:@"一张壁纸，一种心情，今天我的心情%@！", self.wallPaper.type_zh];
            [sendImageMessage setTitle:@"心情壁纸"];
            [sendImageMessage setDescription:title];

            UIImage *previewImage = [PGImageUtility getScaleImage:aImage width:60];

            [sendImageMessage setThumbData:UIImageJPEGRepresentation(previewImage, 1.0)];
            [sendImageMessage setMediaObject:sendImageObject];

            [req setMessage:sendImageMessage];

            //发送到微信
            if ([WXApi sendReq:req])
            {
                isInstallWX = YES;
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"当前微信版本不支持分享到朋友圈，请升级微信到最新版本."
                                                               delegate:nil
                                                      cancelButtonTitle:@"我知道了"
                                                      otherButtonTitles:nil];

            [alertView show];
            isInstallWX = NO;
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"微信未安装，请前往AppStore下载微信"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];

        [alertView show];

        isInstallWX = NO;
    }

    return isInstallWX;
}

- (BOOL)handOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

//微信返回
-(void) onResp:(BaseResp*)resp
{
    if ((self.pWXDelegate != nil) &&
        ([self.pWXDelegate respondsToSelector:@selector(onResp:)]))
    {
        [self.pWXDelegate onResp:resp];
    }
}

@end
