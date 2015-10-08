//
//  XLListViewCell.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLListViewCellDelegate <NSObject>

- (void)btnPressedAtIndex:(UIButton *)aButton Index:(NSInteger)aIndex;

@end

@interface XLListViewCell : UITableViewCell
{

}
@property (nonatomic, weak) id<XLListViewCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;

- (IBAction)btnPressedAtIndex:(id)sender;
@end
