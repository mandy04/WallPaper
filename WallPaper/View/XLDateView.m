//
//  XLDateView.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-11.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLDateView.h"

@interface XLDateView ()
{

}
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end


@implementation XLDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 2, frame.size.height)];

        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        [self.dateLabel setFont:[UIFont boldSystemFontOfSize:36]];
        [self.dateLabel setTextAlignment:NSTextAlignmentLeft];

        [self addSubview:self.dateLabel];

        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2,
                                                                    0,
                                                                    frame.size.width / 2,
                                                                    frame.size.height)];

        [self.rightLabel setBackgroundColor:[UIColor clearColor]];
        [self.rightLabel setTextColor:[UIColor whiteColor]];
        [self.rightLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.rightLabel setTextAlignment:NSTextAlignmentLeft];
        [self.rightLabel setText:@"月"];

        [self addSubview:self.rightLabel];

    }
    return self;
}

- (void)setShowDate:(NSDate *)showDate
{
    _showDate = showDate;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"MM"];

    self.dateStr = [NSString stringWithFormat:@"%d", [[dateFormatter stringFromDate:showDate] intValue]];

    CGSize strSize = [self.dateStr sizeWithAttributes:@{NSFontAttributeName : self.dateLabel.font}];
    CGSize rightSize = [self.rightLabel.text sizeWithAttributes:@{NSFontAttributeName : self.rightLabel.font}];

    [self.rightLabel setFrame:CGRectMake(strSize.width + 3,
                                         self.bounds.size.height - rightSize.height - 13,
                                         self.bounds.size.width - strSize.width,
                                         self.bounds.size.height)];

    [self.dateLabel setText:self.dateStr];
}

- (NSString *)monthStrWithMM:(NSString *)aMMStr
{
    NSString *monthStr = @"一月";

    int month = [aMMStr intValue];
    switch (month)
    {
        case 1:
        {
            monthStr = @"一月";
        }
            break;
        case 2:
        {
            monthStr = @"二月";
        }
            break;
        case 3:
        {
            monthStr = @"三月";
        }
            break;
        case 4:
        {
            monthStr = @"四月";
        }
            break;
        case 5:
        {
            monthStr = @"五月";
        }
            break;
        case 6:
        {
            monthStr = @"六月";
        }
            break;
        case 7:
        {
            monthStr = @"七月";
        }
            break;
        case 8:
        {
            monthStr = @"八月";
        }
            break;
        case 9:
        {
            monthStr = @"九月";
        }
            break;
        case 10:
        {
            monthStr = @"十月";
        }
            break;
        case 11:
        {
            monthStr = @"十一月";
        }
            break;
        case 12:
        {
            monthStr = @"十二月";
        }
            break;
        default:
            break;
    }

    return monthStr;
}

@end
