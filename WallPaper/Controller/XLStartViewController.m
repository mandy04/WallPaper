//
//  XLStartViewController.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLStartViewController.h"
#import "Global.h"
#import "XLDataManager.h"
#import "XLListViewController.h"
//#import "UMFeedback.h"
#import "BIZVersionHelper.h"
#import "XLBigImageViewController.h"
#import "MobClick.h"

#define kAnimationTime          0.3

@interface XLStartViewController ()<UIAlertViewDelegate>

@end

@implementation XLStartViewController
@synthesize myheartBtn = _myheartBtn;
@synthesize todayBtn = _todayBtn;
@synthesize appBtn = _appBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    XLDataManager *dataManager = [XLDataManager sharedDataManager];
    
    [dataManager getAllWallPaperList];

    [self.leftBackView setHidden:YES];

    [self.leftBackImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGs = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(imageTaped:)];

    [self.leftBackImageView addGestureRecognizer:tapGs];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    if (!IS_4_INCH_DEVICE)
    {
        [self.mainView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.menuBtn setCenter:CGPointMake(self.menuBtn.center.x, self.menuBtn.center.y - 88)];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    //集成阿里妈妈sdk
//    self.handleView = [[UMUFPHandleView alloc] initWithFrame:self.view.bounds
//                                                      appKey:nil
//                                                      slotId:@"62894"
//                                       currentViewController:self];
//    self.handleView.delegate = self;
////    [self.view addSubview:self.handleView];
//    [self.handleView requestPromoterDataInBackground];
}

- (void)viewWillAppear:(BOOL)animated
{

#ifdef kUseUmengOnline
    if ([[MobClick getConfigParams:kIsOpenAppRecommend] isEqualToString:@"1"])
    {
        //打开应用推荐
        [self.appBtn setHidden:NO];
    }
#else

    //直接打开应用推荐
    [self.appBtn setHidden:NO];

#endif

    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

/**
 *  应用程序即将进入前台
 *
 *  @param aNotification
 */
- (void)appWillEnterForeground:(NSNotification *)aNotification
{
    if ([[MobClick getConfigParams:kIsOpenAppRecommend] isEqualToString:@"1"])
    {
        //打开应用推荐
        [self.appBtn setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

#pragma mark 用户点击事件
- (void)myheartBtnPressed:(id)sender
{
    NSArray *allList = [[XLDataManager sharedDataManager] getAllWallPaperList];

    NSMutableArray *typeArr = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *typeCodeArr = [[NSMutableArray alloc] initWithCapacity:10];

    //从所有的数据中删选出type类型，组成列表
    for (DLWallPaper *wallPaper in allList)
    {
        NSString *typeStr = wallPaper.type;

        if (![typeCodeArr containsObject:typeStr])
        {
            [typeCodeArr addObject:typeStr];
            [typeArr addObject:wallPaper];
        }
    }

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XLListViewController *listViewController = [storyBoard instantiateViewControllerWithIdentifier:@"XLListViewController"];

    listViewController.typeListArr = typeArr;

    [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)todayBtnPressed:(id)sender
{
    //获取一个随机的壁纸
    NSArray *allList = [[XLDataManager sharedDataManager] getAllWallPaperList];

    srandom([[NSDate date] timeIntervalSince1970]);
    int ramdonNum = random();

    int randomIndex = ramdonNum % [allList count];
    NSLog(@"ramdomIndex = %d", randomIndex);

    if (randomIndex >=0 && randomIndex < [allList count])
    {
        DLWallPaper *wallPaper = [allList objectAtIndex:randomIndex];

        //获取随机出来壁纸的心情组
        //根据选择的字符串筛选数据
        NSArray *allList = [[XLDataManager sharedDataManager] getAllWallPaperList];
        NSMutableArray *imageShowArr = [[NSMutableArray alloc] initWithCapacity:100];

        for (DLWallPaper *tmpWallPaper in allList)
        {
            if ([tmpWallPaper.type isEqualToString:wallPaper.type])
            {
                if (tmpWallPaper.des != nil)
                {
                    if (![tmpWallPaper.des isEqualToString:@""])
                    {
                        [imageShowArr addObject:tmpWallPaper.des];
                    }
                }
            }
        }

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XLBigImageViewController *bigImageViewController = [storyBoard instantiateViewControllerWithIdentifier:@"XLBigImageViewController"];

        bigImageViewController.wallPaper = wallPaper;
        bigImageViewController.textArr = imageShowArr;

        [self.navigationController pushViewController:bigImageViewController animated:YES];
    }
}

- (void)appBtnPressed:(id)sender
{
//    PGAppNetworkViewController *appNetViewControlller = [[PGAppNetworkViewController alloc] initWithNibName:nil bundle:nil];
//
//    [self.navigationController pushViewController:appNetViewControlller animated:YES];

 //   [self.handleView showHandleViewDetailPage];
}

- (void)menuBtnPressed:(id)sender
{
    [self.leftBackView setHidden:NO];
    [self.leftView setCenter:CGPointMake(-self.leftView.frame.size.width / 2,
                                         self.leftView.center.y)];

    __weak XLStartViewController *weakSelf = self;

    [UIView animateWithDuration:kAnimationTime animations:^{

        [weakSelf.leftView setCenter:CGPointMake(weakSelf.leftView.frame.size.width / 2,
                                                 weakSelf.leftView.center.y)];

    }];
}

- (void)imageTaped:(UITapGestureRecognizer *)aTapGs
{
    [self closeBtnPressed:nil];
}

- (void)closeBtnPressed:(id)sender
{
    __weak XLStartViewController *weakSelf = self;

    [UIView animateWithDuration:kAnimationTime
                     animations:^{
                         [weakSelf.leftView setCenter:CGPointMake(-weakSelf.leftView.frame.size.width / 2,
                                                                  weakSelf.leftView.center.y)];
                     } completion:^(BOOL finished) {

                         [weakSelf.leftBackView setHidden:YES];
                         
                     }];
}

#pragma mark 左滑栏按钮

//评价
- (void)goToAppStore:(id)sender
{
    NSString *str;
    if ([[XLDeviceManager sharedDeviceManager] isIOS7])
    {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", STORE_APPKEY];
    }
    else
    {
        str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com"
               "/WebObjects/MZStore.woa/wa"
               "/viewContentsUserReviews?type=Purple+Software&id=%@",
               STORE_APPKEY];
    }

    NSURL *url = [[NSURL alloc] initWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

//检查更新
- (void)checkUpDate:(id)sender
{
    [self checkVersionWithTips:YES];
}

//用户反馈


- (void)checkVersionWithTips:(BOOL)hasTips
{
    [BIZVersionHelper checkVersionWithBlock:^(BOOL hasNew, NSError *error) {

        if (!hasTips)
        {
            return;
        }

        NSString *const title = @"我知道了";
        if (error == nil)
        {
            if (hasNew)
            {
                NSString *lastVersionCode = [BIZVersionHelper lastVersion];
                NSString *const format = @"%@版本發布了，现在就去更新吧！";

                NSString *message = [NSString stringWithFormat:format, lastVersionCode];
                NSString *const btnTitle = @"以后再说";
                UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                       message:message
                                                                      delegate:self
                                                             cancelButtonTitle:btnTitle
                                                             otherButtonTitles:@"立即更新", nil];
                [versionAlert show];

            }
            else
            {
                NSString *message = @"亲，当前您使用的是最新版本哟！";
                UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                       message:message
                                                                      delegate:self
                                                             cancelButtonTitle:title
                                                             otherButtonTitles:nil];
                [versionAlert show];
            }
        }
        else
        {
            NSString *const message = @"网络情况不佳，请稍候再试";
            UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:title
                                                         otherButtonTitles:nil];
            [versionAlert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 更新版本
        NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn"
                         "/app/camera360/id443354861?mt=8"];
        NSURL *url = [[NSURL alloc] initWithString:str];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [[UIApplication sharedApplication] openURL:url];
                       });
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

@end
