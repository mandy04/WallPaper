//
//  XLImageShowViewCell.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLImageShowViewCellDelegate <NSObject>

- (void)btnPressed:(UIButton *)aButton;

@end

@interface XLImageShowViewCell : UITableViewCell
{

}
@property (nonatomic, weak) id<XLImageShowViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;

- (IBAction)previewBtnPressed:(UIButton *)sender;
@end
