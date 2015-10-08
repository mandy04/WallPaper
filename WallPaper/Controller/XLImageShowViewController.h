//
//  XLImageShowViewController.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLImageShowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{

}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *imageListArr;
@property (nonatomic, strong) NSMutableArray *imageTextArr;

- (IBAction)backBtnPressed:(id)sender;
@end
