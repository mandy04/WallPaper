//
//  XLListViewCell.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLListViewCell.h"

@implementation XLListViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnPressedAtIndex:(id)sender
{
    if ((self.delegate != nil) &&
        ([self.delegate respondsToSelector:@selector(btnPressedAtIndex:Index:)]))
    {
        [self.delegate btnPressedAtIndex:sender Index:0];
    }
}

@end
