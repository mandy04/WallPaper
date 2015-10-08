//
//  XLTextView.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-13.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBaseTouchView.h"

@interface XLTextView : XLBaseTouchView <UITextViewDelegate>
{

}
@property (nonatomic, strong) UITextView *textView;

@end
