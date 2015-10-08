//
//  XLBigImageViewController.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-11.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLWallPaper.h"

@interface XLBigImageViewController : UIViewController
{

}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *btnBackView;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) DLWallPaper *wallPaper;
@property (nonatomic, strong) NSArray *textArr;

- (IBAction)dateBtnPressed:(id)sender;
- (IBAction)textBtnPressed:(id)sender;
- (IBAction)previewBtnPressed:(id)sender;
- (IBAction)saveBtnPressed:(id)sender;

- (IBAction)backBtnPressed:(id)sender;
@end
