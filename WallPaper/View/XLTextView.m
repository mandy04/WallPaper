//
//  XLTextView.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-13.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLTextView.h"
#import "Global.h"

@implementation XLTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self commonInitUI];
    }

    return self;
}

- (void)commonInitUI
{
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];

    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.textView setFont:[UIFont boldSystemFontOfSize:24]];
    [self.textView setDelegate:self];
    [self addSubview:self.textView];
    [self.textView setUserInteractionEnabled:NO];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 20)
    {
        return NO;
    }

    return YES;
}

@end
