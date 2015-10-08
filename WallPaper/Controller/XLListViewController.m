//
//  XLListViewController.m
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import "XLListViewController.h"
#import "XLListViewCell.h"
#import "XLDataManager.h"
#import "XLImageShowViewController.h"

#define kListViewCellHeight         130.0f
#define kListViewBtnBaseTag         100

@interface XLListViewController ()<XLListViewCellDelegate>

@end

@implementation XLListViewController

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

    self.title = @"我的心情";
    [self.navigationController setNavigationBarHidden:NO];

    [self.tableView setBackgroundColor:[UIColor clearColor]];

    if (!IS_4_INCH_DEVICE)
    {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x,
                                            self.tableView.frame.origin.y,
                                            self.tableView.frame.size.width,
                                            self.tableView.frame.size.height - 88)];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

- (void)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTypeListArr:(NSArray *)typeListArr
{
    _typeListArr = [self sortTypeListArr:typeListArr];
}

- (NSArray *)sortTypeListArr:(NSArray *)typeListArr
{
    NSArray *sortCodeArr = [NSArray arrayWithObjects:@"happy", @"peace", @"longly", @"sad", @"angry", nil];

    NSMutableArray *sortTypeArr = [[NSMutableArray alloc] initWithCapacity:[typeListArr count]];

    for (NSString *typeCode in sortCodeArr)
    {
        for (DLWallPaper *wallPaper in typeListArr)
        {
            if ([typeCode isEqualToString:wallPaper.type])
            {
                [sortTypeArr addObject:wallPaper];
                break;
            }
        }
    }

    return sortTypeArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.typeListArr count] / 2;

    if ([self.typeListArr count] % 2 != 0)
    {
        rowCount++;
    }

    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kListViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";

    XLListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
    {
        cell = (XLListViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"XLListViewCell"
                                                                owner:nil
                                                              options:nil] firstObject];

        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        [cell.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateAll];
        [cell.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateAll];

        cell.delegate = self;
    }


    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *appLanguage = [languages firstObject];

    NSInteger index = indexPath.row * 2;

    if (index >= 0 && index <= [self.typeListArr count] - 1)
    {
        DLWallPaper *wallPaper = [self.typeListArr objectAtIndex:index];

        NSString *typeStr = wallPaper.type_en;

        if ([appLanguage isEqualToString:@"zh-Hans"])
        {
            typeStr = wallPaper.type_zh;
        }

        [cell.leftBtn setTitle:typeStr forState:UIControlStateAll];
        [cell.leftBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@btn", wallPaper.type]]
                                forState:UIControlStateNormal];
        [cell.leftBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@btn_light", wallPaper.type]]
                                forState:UIControlStateHighlighted];
        [cell.leftBtn setTag:kListViewBtnBaseTag + index];

        if (index + 1 <= [self.typeListArr count] - 1)
        {
            [cell.rightBtn setHidden:NO];

            DLWallPaper *rightPaper = [self.typeListArr objectAtIndex:index + 1];

            typeStr = rightPaper.type_en;

            if ([appLanguage isEqualToString:@"zh-Hans"])
            {
                typeStr = rightPaper.type_zh;
            }

            [cell.rightBtn setTitle:typeStr forState:UIControlStateAll];
            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@btn", rightPaper.type]]
                                    forState:UIControlStateNormal];
            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@btn_light", rightPaper.type]]
                                    forState:UIControlStateHighlighted];
            [cell.rightBtn setTag:kListViewBtnBaseTag + index + 1];
        }
        else
        {
            [cell.rightBtn setHidden:YES];
        }
    }

    return cell;
}

- (void)btnPressedAtIndex:(UIButton *)aButton Index:(NSInteger)aIndex
{
    int index = aButton.tag - kListViewBtnBaseTag;

    if (index < 0 || index > [self.typeListArr count] - 1)
    {
        NSLog(@"索引越界 listview");
        return;
    }

    DLWallPaper *selectWallPaper = [self.typeListArr objectAtIndex:index];

    //根据选择的字符串筛选数据
    NSArray *allList = [[XLDataManager sharedDataManager] getAllWallPaperList];
    NSMutableArray *imageShowArr = [[NSMutableArray alloc] initWithCapacity:100];

    for (DLWallPaper *wallPaper in allList)
    {
        if ([wallPaper.type isEqualToString:selectWallPaper.type])
        {
            [imageShowArr addObject:wallPaper];
        }
    }

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XLImageShowViewController *imageShowViewController = [storyBoard instantiateViewControllerWithIdentifier:@"XLImageShowViewController"];

    imageShowViewController.imageListArr = imageShowArr;

    [self.navigationController pushViewController:imageShowViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
