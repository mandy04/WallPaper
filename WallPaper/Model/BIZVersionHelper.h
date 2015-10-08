//
//  BIZVersionHelper
//
//
//  Created by jtang on 14-7-10 with appCode.
//  Copyright 2014 jtang.cn. All rights reserved.
//


#import <Foundation/Foundation.h>

/** 最后一次请求版本检测的日期 */
#define kVersionLastRequsetData                 @"kVersionLastRequsetData"
/** 最后一次请求到的版本 */
#define kVersionLastCode                        @"kVersionLastCode"
/**
 *  是否有新版本
 */
#define kVersionHasNew                          @"kVersionHasNew"

#define kVersionCode                            @"kVersionCode"

#define kUserDefaultsKeyAppleLanguages @"AppleLanguages"

/**
 *  版本管理辅助类
 */
@interface BIZVersionHelper : NSObject


/**
 */
+ (void)checkVersionNowWithBlock:(void (^)(BOOL hasNew, NSError *error))result;

/**
 */
+ (void)checkVersionWithBlock:(void (^)(BOOL hasNew, NSError *error))result;

/**
 */
+ (NSString *)lastVersion;

/**
 */
+ (void)haveShowVersionTips;

/**
 *  check if a new version string is larger than current version.
 *
 *  @param newVersion the new version string.(eg. 5.1.1)
 *
 *  @return YES if larger than current version,else NO.
 */
+ (BOOL)hasNewVersion:(NSString *)newVersion;

@end
