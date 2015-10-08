//
//  BIZVersionHelper
//
//
//  Created by jtang on 14-7-10 with appCode.
//  Copyright 2014 jtang.cn. All rights reserved.
//


#import "BIZVersionHelper.h"
#import "AFJSONRequestOperation.h"
#import "Global.h"

// 更新提示弹出次数
static NSString *const kHasNewVersionTipsCount  = @"kHasNewVersionTipsCount";
// 最后一次弹出更新提示的时间
static NSString *const kLastVersionTipsShowDate = @"kLastVersionTipsShowDate";

@interface BIZVersionHelper ()

@end

@implementation BIZVersionHelper

+ (void)checkVersionNowWithBlock:(void (^)(BOOL hasNew, NSError *error))result
{
    NSURL *url = [BIZVersionHelper versionCheckURL];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    void (^const success)(NSURLRequest *, NSHTTPURLResponse *, id)
            = ^(NSURLRequest *urlRequest, NSHTTPURLResponse *response, id JSON) {

                id results = [JSON valueForKey:@"results"];


                NSAssert(results && [results isKindOfClass:[NSArray class]],
                @"服务器返回JSON根必须包含version，且为String类型");

                if ([results count] == 0)
                {
                    NSString *message = @"亲，当前您使用的是最新版本哟！";
                    UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                           message:message
                                                                          delegate:self
                                                                 cancelButtonTitle:@"我知道了"
                                                                 otherButtonTitles:nil];
                    [versionAlert show];
                    return;
                }

                id version = [results valueForKey:@"version"];

                NSAssert(version && [version isKindOfClass:[NSArray class]] && [version count] > 0,
                @"服务器返回JSON根必须包含version，且为NSArray类型, 且数量大于0");

                NSString *newVersion = [version firstObject];


                // 记录本次请求的时间和版本
                [BIZVersionHelper requestMarkWithVersion:newVersion];

                if (newVersion != nil)
                {
                    BOOL hasNewVersion = [BIZVersionHelper hasNewVersion:newVersion];

                    if (![[BIZVersionHelper lastVersion] isEqualToString:newVersion])
                    {

                        [BIZVersionHelper initShowVersionTipsCount];
                        NSLog(@"最后一本版本非当前版本需要重置点击次数量");
                        [[NSUserDefaults standardUserDefaults] setObject:newVersion
                                           forKey:kVersionCode];
                    }


                    if (result)
                    {
                        result(hasNewVersion, nil);
                    }
                }
                else
                {
                    //如果无更新（服务器返回10200）或其他网络错误
                    NSError *error = [[NSError alloc] initWithDomain:@"异常错误"
                                                                code:0
                                                            userInfo:nil];
                    if (result)
                    {
                        result(NO, error);
                    }
                }
            };
    void (^const failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id)
            = ^(NSURLRequest *aRequest, NSHTTPURLResponse *response, NSError *error, id JSON) {
                if (result)
                {
                    result(NO, error);
                }
            };
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:success
                                                                                        failure:failure];
    [operation start];
}


+ (void)checkVersionWithBlock:(void (^)(BOOL hasNew, NSError *error))result
{
    if ([BIZVersionHelper hasCheckedVersionToday])
    {

        NSString *newVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kVersionLastCode];
        BOOL hasNewVersion = [BIZVersionHelper hasNewVersion:newVersion];
        if (result)
        {
            result(hasNewVersion, nil);
        }

        return;
    }
    else
    {
        [BIZVersionHelper checkVersionNowWithBlock:result];
    }
}


/**
 *  请求版本成功后进行标记
 *
 *  @param version 最新版本
 */
+ (void)requestMarkWithVersion:(NSString *)version
{
    // 存储当前请求的时间
    NSDate *today = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:today forKey:kVersionLastRequsetData];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kVersionLastCode];
}


/**
 *  判断今天是成功否检查过版本
 *
 *  @return 是否检查过新版本
 */
+ (BOOL)hasCheckedVersionToday
{
    BOOL result = NO;
    NSDate *today = [NSDate date];
    NSDate *lastRequestDay = [[NSUserDefaults standardUserDefaults] objectForKey:kVersionLastRequsetData];

    NSLog(@"当前日期：%@，最后一次请求日期：%@", today, lastRequestDay);

    if (lastRequestDay)
    {
        result = [BIZVersionHelper isSameDayWithDate1:today date2:lastRequestDay];
    }

    return result;
}


+ (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date2];

    return [comp1 day] == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year] == [comp2 year];
}


+ (BOOL)hasNewVersion:(NSString *)newVersion
{
    if (nil == newVersion)
    {
        return NO;
    }

    NSAssert([newVersion isKindOfClass:[NSString class]], @"hasNewVersion参数错误");
    NSAssert((YES == [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(\\d\\.){1,2}\\d"]
                                   evaluateWithObject:newVersion])
    , @"hasNewVersion 参数格式错误");

    BOOL hasNewVerRet = NO;
    NSString *currentVersion = [BIZVersionHelper currentVersion];
    if (currentVersion)
    {
        NSComparisonResult ret = [newVersion compare:currentVersion options:NSNumericSearch];
        hasNewVerRet = (ret == NSOrderedDescending);
        [[NSUserDefaults standardUserDefaults] setBool:hasNewVerRet forKey:kVersionHasNew];
    }
    return hasNewVerRet;
}


+ (NSString *)currentVersion
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *nowVersion = [mainBundle.infoDictionary valueForKey:@"CFBundleVersion"];
    return nowVersion;
}


+ (NSString *)lastVersion
{
    NSString *lastVestion = [[NSUserDefaults standardUserDefaults] objectForKey:kVersionCode];
    return lastVestion;
}


/**
 *  拼接版本检测URL
 *
 *  @return 版本检测URL
 */
+ (NSURL *)versionCheckURL
{
    NSString *localIdentifier = nil;

    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:kUserDefaultsKeyAppleLanguages];
    NSString *preferredLang = [languages firstObject];

    if ([preferredLang isEqualToString:@"zh-Hans"])
    {
        localIdentifier = @"CN";
    }
    else
    {
        localIdentifier = @"GB";
    }

    NSString *checkUrl = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=%@",
                                                    STORE_APPKEY,
                                                    localIdentifier];

    NSURL *url = [[NSURL alloc] initWithString:checkUrl];

    return url;
}

#pragma mark - 更新提示提示相关


// 弹出提示
+ (void)haveShowVersionTips
{
    // 记录最后一次时间
    NSDate *lastVersionTipsShowDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastVersionTipsShowDate forKey:kLastVersionTipsShowDate];
}


// 初始化点击不更新次数
+ (void)initShowVersionTipsCount
{
    //程序第一次启动，记录程序的启动时间，并初始启动次数为1
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kHasNewVersionTipsCount];
}


@end
