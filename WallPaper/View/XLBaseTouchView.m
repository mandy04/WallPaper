//
//  XLBaseTouchView.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-12.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLBaseTouchView.h"
#import "Global.h"

@implementation XLBaseTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code

        [self commonInit];
    }
    return self;
}


- (void)commonInit
{
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:[UIColor clearColor]];

    UIPanGestureRecognizer *panGs = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handlePanGs:)];

    [panGs setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:panGs];

    UIPinchGestureRecognizer *pinchGs = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handlePinchGs:)];

    [self addGestureRecognizer:pinchGs];

    self.centerPoint = self.center;
    self.zoomScale = 1.0;
    self.lastCenterPoint = self.center;
    self.lastZoomScale = 1.0;
}

- (void)handlePanGs:(UIPanGestureRecognizer *)aPanGs
{
    switch (aPanGs.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _beginPoint = self.center;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint movePoint = [aPanGs translationInView:self];

            CGPoint newCenter = CGPointMake(_beginPoint.x + movePoint.x * self.transform.a,
                                            _beginPoint.y + movePoint.y * self.transform.a);

            self.centerPoint = CGPointMake(newCenter.x, newCenter.y);

            CGRect viewBounds = [self superview].bounds;

            float offset = 100;

            if ((newCenter.x < self.bounds.size.width * self.transform.a / 2 - offset) ||
                (newCenter.x > viewBounds.size.width - self.bounds.size.width * self.transform.a / 2 + offset) ||
                (newCenter.y < self.bounds.size.height * self.transform.a / 2) ||
                (newCenter.y > viewBounds.size.height - self.bounds.size.height  * self.transform.a/ 2))
            {
                NSLog(@"中心点超出边界");
            }
            else
            {
                [self setCenter:newCenter];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
        }
            break;
        default:
            break;
    }
}


- (void)handlePinchGs:(UIPinchGestureRecognizer *)aPinchGs
{
    //    PGLogDebug(@"sacle = %f", aPinchGs.scale);

    switch (aPinchGs.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _beginTransform = self.transform;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGAffineTransform curTransform = CGAffineTransformScale(_beginTransform, aPinchGs.scale, aPinchGs.scale);

            self.zoomScale = curTransform.a;

            if ((curTransform.a > 0.7) && (curTransform.a < 3.0))
            {
                [self setTransform:curTransform];
            }
            else
            {
                NSLog(@"放大或缩小超出限制");
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
        }
            break;
        default:
            break;
    }
}


- (void)resetLastState
{
    [self setCenter:self.lastCenterPoint];
    [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, self.lastZoomScale, self.lastZoomScale)];
}


@end
