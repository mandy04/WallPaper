//
//  Gobal.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-4.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "MobClick.h"
#import <CoreData/CoreData.h>

#ifndef WallPaper_Gobal_h
#define WallPaper_Gobal_h

#ifdef DEBUG
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif

#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted

/**
 *  判断是否是4英寸设备
 *
 */
#ifndef IS_4_INCH_DEVICE
#define IS_4_INCH_DEVICE ([[UIScreen mainScreen] bounds].size.height >= 568.0f\
&& [[UIScreen mainScreen] bounds].size.height < 1024.0f)
#endif

//
#define kAppId              @"iMahVVxurw6BNr7XSn9EF2"
#define kAppKey             @"yIPfqwq6OMAPp6dkqgLpG5"
#define kAppSecret          @"G0aBqAD6t79JfzTB6Z5lo5"

//微信
#define kWechatURLScheme    @"wx136b4f99099411a9"

//Umengkey
#define UMENG_APPKEY        @"53c53c3c56240b202f00c98e"  //@"4d7ecea9112cf734e50ff234"
/**
 *  苹果商店Key
 */
#define STORE_APPKEY        @"886953552"

//是否打开应用推荐
#define kIsOpenAppRecommend @"isOpenAppRecommendV10"

//表示是否使用友盟在线参数控制应用推荐显示，有此宏定义表示使用
#define kUseUmengOnline     @"kUseUmengOnline"
#endif
