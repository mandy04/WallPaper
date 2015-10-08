//
//  XLSavedSuccessViewController.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-17.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSavedSuccessViewController : UIViewController
{

}

@property (nonatomic, weak) IBOutlet UILabel *tipsLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareBtn;
@property (nonatomic, weak) IBOutlet UIImageView *settingImageView;
@property (nonatomic, weak) IBOutlet UIButton *okBtn;

@property (nonatomic, strong) UIImage *makedImage;

- (IBAction)okBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

@end
