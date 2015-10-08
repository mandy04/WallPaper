//
//  XLListViewController.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-7.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{

}
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *typeListArr;

- (IBAction)backBtnPressed:(id)sender;
@end
