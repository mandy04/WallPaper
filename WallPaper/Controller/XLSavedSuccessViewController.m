//
//  XLSavedSuccessViewController.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-17.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLSavedSuccessViewController.h"
#import "XLWXShareManager.h"
#import "WXApi.h"

@interface XLSavedSuccessViewController () <WXApiDelegate>
{

}
@end

@implementation XLSavedSuccessViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

- (void)backBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)okBtnPressed:(id)sender
{
    //分享到微信
    [[XLWXShareManager sharedManager] setPWXDelegate:self];
    [[XLWXShareManager sharedManager] startShareToWX:self.makedImage];
}

-(void) onResp:(BaseResp*)resp
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
