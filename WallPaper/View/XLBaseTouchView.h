//
//  XLBaseTouchView.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-12.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBaseTouchView : UIView
{
    UIImageView *_imageView;

    CGAffineTransform _beginTransform;
    CGPoint _beginPoint;
}

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) float zoomScale;
@property (nonatomic, assign) CGPoint lastCenterPoint;
@property (nonatomic, assign) float lastZoomScale;

/**
 *  重置上次选择的状态
 */
- (void)resetLastState;
@end
