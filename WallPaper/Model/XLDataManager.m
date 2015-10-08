//
//  XLDataManager.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLDataManager.h"

static XLDataManager *s_dataManager = nil;

@implementation XLDataManager
{
    NSString *_curVersionNum;
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStore = _persistentStore;


+ (XLDataManager *)sharedDataManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{

        s_dataManager = [[XLDataManager alloc] init];
    });

    return s_dataManager;
}

- (id)init
{
    self = [super init];

    if (self)
    {

    }

    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *persistentStore = [self persistentStore];

    if (persistentStore != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:persistentStore];
    }

    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStore
{
    if (_persistentStore != nil)
    {
        return _persistentStore;
    }

    NSURL *homeDicUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

    NSURL *storeUrl = [homeDicUrl URLByAppendingPathComponent:@"WallPaper.sqlite"];

    NSError *error = nil;
    _persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![_persistentStore addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:storeUrl
                                             options:nil
                                               error:&error])
    {
        NSLog(@"CoreData Error = %@", error);
        abort();
    }

    return _persistentStore;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }

    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"WallPaper" withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];

    return _managedObjectModel;
}
#pragma mark CoreData操作

- (NSArray *)getAllWallPaperList
{
    NSError *error = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];

    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityNameWallPaper
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                               error:&error];

    if (error)
    {
        NSLog(@"getAllWallPaperListFormCoreData Error = %@", error);
    }

    return result;
}

- (void)cleanData
{
    NSArray *allDatas = [self getAllWallPaperList];

    if (allDatas != nil && [allDatas count] > 0)
    {
        for (id data in allDatas)
        {
            [self.managedObjectContext deleteObject:data];
        }
    }

    [self saveContext];
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"CoreData error %@, %@", error, [error userInfo]);
            return NO;
        }
    }

    return YES;
}


#pragma mark 数据请求和操作
- (void)startUpDataData
{
    //尝试检查版本，更新最新数据
    XLNetworkHelper *networkHelper = [XLNetworkHelper sharedNetworkHelper];

    [networkHelper setDelegate:self];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    NSString *curVersion = [userDefault valueForKey:kCurVersionNum];

    if (curVersion == nil)
    {
        //如果没有请求成功过数据，直接使用内置数据
        NSError *jsonAnalysisError = nil;
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"wallpaper" ofType:@"json"];
        NSData *wallPaperdata = [[NSData alloc] initWithContentsOfFile:jsonPath];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:wallPaperdata
                                                                options:kNilOptions
                                                                  error:&jsonAnalysisError];
        if (jsonDic != nil)
        {
            NSArray *resultArr = [NSArray array];

            if ([[jsonDic valueForKey:kState] intValue] == 200)
            {
                NSArray *dataArr = [jsonDic valueForKey:kData];

                if ((dataArr != nil) && ([dataArr count] > 0))
                {
                    resultArr = dataArr;
                }
            }

            _curVersionNum = @"0";
            [self didFinishGetAllWallPaperList:resultArr];
        }

        //请求最新数据，刷新数据库
        [networkHelper startGetAllWallPaperList];
    }
    else
    {
        [networkHelper startCheckMaxVersion];
    }
}

/**
 *  请求服务器最新版本，成功回调
 *
 *  @param aMaxVersion
 */
- (void)didFinishGetMaxVersion:(NSString *)aMaxVersion
{
    XLNetworkHelper *networkHelper = [XLNetworkHelper sharedNetworkHelper];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    NSString *curVersion = [userDefault valueForKey:kCurVersionNum];
    _curVersionNum = aMaxVersion;

    //第一次请求成功，直接刷新列表
    //如果服务器最新版本大于当前版本，需要更新最新数据
    if ((curVersion == nil) || [aMaxVersion intValue] > [curVersion intValue])
    {
        //请求最新数据，刷新数据库
        [networkHelper startGetAllWallPaperList];
    }
    else
    {
        //当前数据已经最新版本，不做任何处理
        NSLog(@"当前已经是最新版本，不需要更新");
    }
}

/**
 *  获取所有墙纸列表，成功回调
 *
 *  @param aAllWalPaperListDic 
 */
- (void)didFinishGetAllWallPaperList:(NSArray *)aAllWalPaperList
{
    //请求成功之后清空之前表中的所有数据，重新插入
    [self cleanData];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    for (NSDictionary *wallPaperDic in aAllWalPaperList)
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WallPaper"
                                                  inManagedObjectContext:_managedObjectContext];

        DLWallPaper *dlWallPaper = (DLWallPaper *)[[NSManagedObject alloc] initWithEntity:entity
                                                           insertIntoManagedObjectContext:_managedObjectContext];

        dlWallPaper.id = [NSNumber numberWithInt:[[wallPaperDic valueForKey:kId] intValue]] ;

        NSDate *date = [dateFormatter dateFromString:[wallPaperDic valueForKey:kDate]];
        dlWallPaper.date = date;

        dlWallPaper.imageicon = [wallPaperDic valueForKey:kImageIcon];
        dlWallPaper.imageUrl = [wallPaperDic valueForKey:kImageUrl];
        dlWallPaper.version = [NSNumber numberWithInt:[[wallPaperDic valueForKey:kVersion] intValue]];
        dlWallPaper.deviceType = [wallPaperDic valueForKey:kDeviceType];
        dlWallPaper.type = [wallPaperDic valueForKey:kType];
        dlWallPaper.type_zh = [wallPaperDic valueForKey:kTypeZh];
        dlWallPaper.type_en = [wallPaperDic valueForKey:kTypeEn];
        dlWallPaper.des = [wallPaperDic valueForKey:kDes];
    }

    if (![self saveContext])
    {
        NSLog(@"Core Data save Error");
        abort();
    }


    //发送数据更新成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataSuccessNotification
                                                        object:nil
                                                      userInfo:nil];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if (_curVersionNum != nil)
    {
        [userDefault setValue:_curVersionNum forKey:kCurVersionNum];
        [userDefault synchronize];
    }
}

/**
 *  网络请求异常
 *
 *  @param aError 网络错误信息
 */
- (void)didNetworkError:(NSError *)aError
{
    NSLog(@"Network error = %@", aError);
}

@end
