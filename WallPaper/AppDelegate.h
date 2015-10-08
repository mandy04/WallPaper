//
//  AppDelegate.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-4.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GexinSdk.h"
#import "Global.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GexinSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;
@end
