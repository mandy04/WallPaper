//
//  AppDelegate.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-4.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "AppDelegate.h"
#import "XLDataManager.h"
#import "XLWXShareManager.h"
#import "MobClick.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];

    // [2]:注册APNS
    [self registerRemoteNotification];

    // [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message)
    {

    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //启动友盟
    [MobClick startWithAppkey:UMENG_APPKEY
                 reportPolicy:BATCH
                    channelId:nil];

    //刷新在线参数
    if (([MobClick getConfigParams:kIsOpenAppRecommend] == nil) ||
        (![[MobClick getConfigParams:kIsOpenAppRecommend] isEqualToString:@"1"]))
    {
        [MobClick updateOnlineConfig];
    }

    //init core data
    [[XLDataManager sharedDataManager] managedObjectContext];

    //每次启动尝试更新数据
    [[XLDataManager sharedDataManager] startUpDataData];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //刷新在线参数
    if (([MobClick getConfigParams:kIsOpenAppRecommend] == nil) ||
        (![[MobClick getConfigParams:kIsOpenAppRecommend] isEqualToString:@"1"]))
    {
        [MobClick updateOnlineConfig];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

	NSString *deviceTokenStr = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"deviceToken:%@", deviceTokenStr);

    // [3]:向个推服务器注册deviceToken
    if (self.gexinPusher)
    {
        [self.gexinPusher registerDeviceToken:deviceTokenStr];
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //分享到微信回调
    if ([[url scheme] isEqualToString:kWechatURLScheme])
    {
        [[XLWXShareManager sharedManager] handOpenURL:url];
    }

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//个推Delegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{

}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{

}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result
{

}

- (void)GexinSdkDidOccurError:(NSError *)error
{

}

- (void)registerRemoteNotification
{
	UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!self.gexinPusher)
    {
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;

        self.clientId = nil;

        NSError *err = nil;
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleVersionKey];

        self.gexinPusher = [GexinSdk createSdkWithAppId:self.appID
                                             appKey:self.appKey
                                          appSecret:self.appSecret
                                         appVersion:appVersion
                                           delegate:self
                                              error:&err];
    }
}


@end
