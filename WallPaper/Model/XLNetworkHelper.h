//
//  XLNetworkHelper.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Global.h"
#import "XLDeviceManager.h"
#import "PGMD5.h"

#define kServerHost         @"http://zhongxiaolong.sinaapp.com/WallPaperServer/index.php"
#define kServerPublicKey    @"zhongxiaolong"
#define kQiNiuKey           @"pQVAH3gN7Ar2r8bHADjZ2hYuvhAaPqRiQBD1N3m_"
#define kQiNiuSecret        @"j73ZjPcjzw5yC1TNQClF5myo-PXHtraJh0TKp9Qu"

#define RequestTimeOut      30.0

#define kGetMethod          @"GET"
#define kUid                @"uid"
#define kMethod             @"method"
#define kSig                @"sig"

#define kState              @"state"
#define kData               @"data"
#define kMaxVersion         @"maxversion"

#define kId                 @"id"
#define kDate               @"date"
#define kImageUrl           @"imageurl"
#define kImageIcon          @"imageicon"
#define kVersion            @"version"
#define kType               @"type"
#define kTypeZh             @"type_zh_hans"
#define kTypeEn             @"type_en"
#define kDeviceType         @"devicetype"
#define kDes                @"des"

@protocol XLNetworkHelperDelegate <NSObject>

/**
 *  请求服务器最新版本回调
 */
- (void)didFinishGetMaxVersion:(NSString *)aMaxVersion;

/**
 *  请求所有的壁纸列表完成回调
 *
 *  @param aAllWalPaperListDic
 */
- (void)didFinishGetAllWallPaperList:(NSArray *)aAllWalPaperList;

/**
 *  网络请求出错
 *
 *  @param aError 出错
 */
- (void)didNetworkError:(NSError *)aError;
@end

@interface XLNetworkHelper : NSObject
{

}
@property (nonatomic, weak) id<XLNetworkHelperDelegate> delegate;

+ (XLNetworkHelper *)sharedNetworkHelper;

/**
 *  检测服务器当前最新版本
 */
- (void)startCheckMaxVersion;

/**
 *  拉取服务器最新数据列表
 */
- (void)startGetAllWallPaperList;

/**
 *  给图片地址添加七牛的签名算法
 *
 *  @param aImageUrl 原始图片地址
 *
 *  @return 签名之后可以直接下载的图片地址
 */
+ (NSString *)imageUrlWithSig:(NSString *)aImageUrl;
@end
