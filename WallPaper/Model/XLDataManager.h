//
//  XLDataManager.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "DLWallPaper.h"
#import "XLNetworkHelper.h"

#define kEntityNameWallPaper                @"WallPaper"
#define kCurVersionNum                      @"kCurVersionNum"

//数据更新成功通知
#define kUpdateDataSuccessNotification      @"kUpdateDataSuccessNotification"

@interface XLDataManager : NSObject <XLNetworkHelperDelegate>
{

}
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStore;

+ (XLDataManager *)sharedDataManager;

//尝试更新数据
- (void)startUpDataData;

//获取数据库最新数据
- (NSArray *)getAllWallPaperList;
@end
