//
//  XLBigImageViewController.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-11.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLBigImageViewController.h"
#import "UIImageView+WebCache.h"
#import "XLNetworkHelper.h"
#import "XLDateView.h"
#import "XLTextView.h"
#import "XLSavedSuccessViewController.h"
#import "XLWXShareManager.h"

#define kDateViewWidth          185
#define kDateViewHeight         40
#define kTextViewWidth          320
#define kTextViewHeight         70

#define kAnimationTime          0.2

@interface XLBigImageViewController ()

@property (nonatomic, strong) XLDateView *dateView;
@property (nonatomic, strong) XLTextView *textView;
@property (nonatomic, strong) UIImageView *previewImageView;

@end

@implementation XLBigImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *imageUrl = [XLNetworkHelper imageUrlWithSig:self.wallPaper.imageUrl];

    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:@"bigloading"]];
    [self.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGs = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(hideKeyBoard:)];

    tapGs.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGs];

    //日期显示
    XLDateView *dateView = [[XLDateView alloc] initWithFrame:CGRectMake(10,
                                                                        self.imageView.frame.size.height - 135 -kDateViewHeight,
                                                                        kDateViewWidth,
                                                                        kDateViewHeight)];
    [dateView setShowDate:[NSDate date]];
    [dateView setHidden:YES];

    self.dateView = dateView;
    [self.imageView addSubview:dateView];

    //文字输入
    XLTextView *textView = [[XLTextView alloc] initWithFrame:CGRectMake(5,
                                                                        self.imageView.frame.size.height - 60 - kTextViewHeight,
                                                                        kTextViewWidth,
                                                                        kTextViewHeight)];

    [textView setHidden:YES];
    [self.imageView addSubview:textView];
    self.textView = textView;

    //预览
    UIImageView *preViewImageView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];

    [preViewImageView setBackgroundColor:[UIColor clearColor]];

    if (IS_4_INCH_DEVICE)
    {
        [preViewImageView setImage:[UIImage imageNamed:@"previewImage"]];
    }
    else
    {
        [preViewImageView setImage:[UIImage imageNamed:@"previewimage_iphone4"]];
    }

    [preViewImageView setHidden:YES];
    [preViewImageView setUserInteractionEnabled:YES];
    [preViewImageView setContentMode:UIViewContentModeScaleAspectFill];

    UITapGestureRecognizer *previewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(previewBtnPressed:)];


    [preViewImageView addGestureRecognizer:previewTap];

    [self.imageView addSubview:preViewImageView];
    self.previewImageView = preViewImageView;

    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateBtnPressed:(id)sender
{
    if ([self.dateView isHidden])
    {
        [self.dateView setHidden:NO];
    }
    else
    {
        [self.dateView setHidden:YES];
    }
}

- (void)textBtnPressed:(id)sender
{
    if ([self.textView isHidden])
    {
        [self.textView.textView setText:[self getNextText]];
        [self.textView setHidden:NO];
    }
    else
    {
        [self.textView setHidden:YES];
    }
}

- (NSString *)getNextText
{
    static int textIndex = 0;
    NSString *textStr = nil;

    if (textIndex >= 0 && textIndex < [self.textArr count])
    {
        textStr = [self.textArr objectAtIndex:textIndex];
    }

    textIndex++;
    if (textIndex >= [self.textArr count])
    {
        textIndex = 0;
    }

    if (textStr == nil)
    {
        textStr = @"远处的是风景，近处的才是人生。";
    }

    return textStr;
}

- (void)previewBtnPressed:(id)sender
{
    if ([self.previewImageView isHidden])
    {
        [self.previewImageView setHidden:NO];
        [self.btnBackView setHidden:YES];
        [self.closeBtn setHidden:YES];

        self.previewImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);

        __weak XLBigImageViewController *weakSlef = self;

        [UIView animateWithDuration:kAnimationTime animations:^{

            weakSlef.previewImageView.transform = CGAffineTransformIdentity;
        }];
    }
    else
    {
        [self.previewImageView setHidden:YES];
        [self.btnBackView setHidden:NO];
        [self.closeBtn setHidden:NO];
    }
}

- (void)saveBtnPressed:(id)sender
{
    UIImage *makedImage = [self getMakedImage];

    //直接保存到系统相册
    UIImageWriteToSavedPhotosAlbum(makedImage, nil, nil, nil);

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XLSavedSuccessViewController *savedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"XLSavedSuccessViewController"];

    savedViewController.makedImage = makedImage;

    [XLWXShareManager sharedManager].wallPaper = self.wallPaper;

    [self.navigationController pushViewController:savedViewController
                                         animated:YES];
}

- (void)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)aTapGs
{
    [self.textView.textView resignFirstResponder];
}

//根据当前状态制作最后的壁纸图
- (UIImage *)getMakedImage
{
    UIScreen *mainScreen = [UIScreen mainScreen];

    CGSize imageSize = CGSizeMake(mainScreen.bounds.size.width * mainScreen.scale,
                                  mainScreen.bounds.size.height * mainScreen.scale);

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();

    //先渲染背景图
    UIImage *backImage = self.imageView.image;

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, imageSize.width, imageSize.height),
                       backImage.CGImage);
    CGContextRestoreGState(context);

    //渲染时间
    float scale = imageSize.width / self.imageView.frame.size.width * self.dateView.zoomScale;
    float frameScale = imageSize.width / self.imageView.frame.size.width;

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.dateView.frame.origin.x * frameScale,
                          self.dateView.frame.origin.y * frameScale);
    CGContextScaleCTM(context, scale, scale);
    [self.dateView.layer renderInContext:context];

    CGContextRestoreGState(context);

    //渲染文字
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.textView.frame.origin.x * frameScale,
                          self.textView.frame.origin.y * frameScale);
    CGContextScaleCTM(context, scale, scale);
    [self.textView.layer renderInContext:context];

    CGContextRestoreGState(context);

    UIImage *makedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return makedImage;
}

@end
