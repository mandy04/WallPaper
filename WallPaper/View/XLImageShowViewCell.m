//
//  XLImageShowViewCell.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLImageShowViewCell.h"
#import "UIImageView+WebCache.h"

@implementation XLImageShowViewCell

- (void)awakeFromNib
{
    // Initialization code

    float offset = 3;

    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset,
                                                                               offset,
                                                                               self.leftBtn.bounds.size.width - offset * 2,
                                                                               self.leftBtn.bounds.size.height - offset * 2)];


    [self.leftBtn addSubview:leftImageView];
    self.leftImageView = leftImageView;

    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset,
                                                                                offset,
                                                                                self.rightBtn.bounds.size.width - offset * 2,
                                                                                self.rightBtn.bounds.size.height - offset * 2)];

    [self.rightBtn addSubview:rightImageView];
    self.rightImageView = rightImageView;
}

- (void)previewBtnPressed:(UIButton *)sender
{
    if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(btnPressed:)]))
    {
        [self.delegate btnPressed:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
