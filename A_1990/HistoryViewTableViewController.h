//
//  HistoryViewTableViewController.h
//  YinYueTai
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewTableViewController : UITableViewController

@property (nonatomic , retain) MTVModel *historyModel;
@property (nonatomic , retain) NSString *HistoryTitle;

@property (nonatomic , retain) NSMutableArray *dataArr;

@end
