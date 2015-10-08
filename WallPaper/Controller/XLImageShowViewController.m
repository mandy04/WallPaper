//
//  XLImageShowViewController.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLImageShowViewController.h"
#import "XLImageShowViewCell.h"
#import "UIImageView+WebCache.h"
#import "XLDataManager.h"
#import "XLBigImageViewController.h"

#define kImageShowViewCellHeight            250
#define kImageShowViewCellBaseTag           100

@interface XLImageShowViewController () <XLImageShowViewCellDelegate>

@end

@implementation XLImageShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!IS_4_INCH_DEVICE)
    {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x,
                                            self.tableView.frame.origin.y,
                                            self.tableView.frame.size.width,
                                            self.tableView.frame.size.height - 88)];
    }
}

- (void)setImageListArr:(NSArray *)imageListArr
{
    _imageListArr = imageListArr;

    self.imageTextArr = [[NSMutableArray alloc] initWithCapacity:100];

    //刷新文字数据
    for (DLWallPaper *wallPaper in _imageListArr)
    {
        if (wallPaper.des != nil)
        {
            if (![wallPaper.des isEqualToString:@""])
            {
                [self.imageTextArr addObject:wallPaper.des];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.imageListArr count] / 2;

    if ([self.imageListArr count] % 2 != 0)
    {
        rowCount++;
    }

    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kImageShowViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";

    XLImageShowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
    {
        cell = (XLImageShowViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"XLImageShowViewCell"
                                                                     owner:nil
                                                                   options:nil] firstObject];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    NSInteger index = indexPath.row * 2;

    if (index >= 0 && index <= [self.imageListArr count] - 1)
    {
        DLWallPaper *wallPaper = [self.imageListArr objectAtIndex:index];

        //如果本地有内置数据，直接使用
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [wallPaper.imageicon lastPathComponent]]];
        NSString *imageUrlStr = nil;
        NSURL *imageUrl = nil;

        if (icon != nil)
        {
            [cell.leftImageView setImage:icon];
        }
        else
        {
            imageUrlStr = [XLNetworkHelper imageUrlWithSig:wallPaper.imageicon];

            imageUrl = [NSURL URLWithString:imageUrlStr];

            [cell.leftImageView setImageWithURL:imageUrl
                               placeholderImage:[UIImage imageNamed:@"loading.png"]];
        }
        cell.leftBtn.tag = kImageShowViewCellBaseTag + index;

        if (index + 1 <= [self.imageListArr count] - 1)
        {
            [cell.rightBtn setHidden:NO];

            DLWallPaper *rightPaper = [self.imageListArr objectAtIndex:index + 1];

            icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [rightPaper.imageicon lastPathComponent]]];

            if (icon != nil)
            {
                [cell.rightImageView setImage:icon];
            }
            else
            {
                imageUrlStr = [XLNetworkHelper imageUrlWithSig:rightPaper.imageicon];
                imageUrl = [NSURL URLWithString:imageUrlStr];

                [cell.rightImageView setImageWithURL:imageUrl
                                    placeholderImage:[UIImage imageNamed:@"loading.png"]];
            }
            cell.rightBtn.tag = kImageShowViewCellBaseTag + index + 1;

        }
        else
        {
            [cell.rightBtn setHidden:YES];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)btnPressed:(UIButton *)aButton
{
    NSInteger index = aButton.tag - kImageShowViewCellBaseTag;

    if (index >= 0 && index < [self.imageListArr count])
    {
        DLWallPaper *wallPaper = [self.imageListArr objectAtIndex:index];

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XLBigImageViewController *bigImageViewController = [storyBoard instantiateViewControllerWithIdentifier:@"XLBigImageViewController"];

        bigImageViewController.wallPaper = wallPaper;
        bigImageViewController.textArr = self.imageTextArr;

        [self.navigationController pushViewController:bigImageViewController animated:YES];
    }
}

@end
