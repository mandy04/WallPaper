//
//  XLStartViewController.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-5.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMUFPHandleView.h"

@interface XLStartViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate
                                >
{
    
}

@property (nonatomic, weak) IBOutlet UIImageView *backImageView;
@property (nonatomic, weak) IBOutlet UIButton *myheartBtn;
@property (nonatomic, weak) IBOutlet UIButton *todayBtn;
@property (nonatomic, weak) IBOutlet UIButton *appBtn;
@property (nonatomic, weak) IBOutlet UIButton *menuBtn;

@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *leftBackView;
@property (nonatomic, weak) IBOutlet UIImageView *leftBackImageView;
@property (nonatomic, weak) IBOutlet UIView *mainView;

//MMUBannerView.h@property (nonatomic, strong) UMUFPHandleView *handleView;

//我的心情按钮被点击
- (IBAction)myheartBtnPressed:(id)sender;

//每日精选按钮被点击
- (IBAction)todayBtnPressed:(id)sender;

//应用推荐按钮被点击
- (IBAction)appBtnPressed:(id)sender;

//菜单按钮被点击
- (IBAction)menuBtnPressed:(id)sender;

//菜单关闭被点击
- (IBAction)closeBtnPressed:(id)sender;

#pragma mark 左滑栏按钮
- (IBAction)goToAppStore:(id)sender;

- (IBAction)checkUpDate:(id)sender;

- (IBAction)gotoFeedBack:(id)sender;
@end
