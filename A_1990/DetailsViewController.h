//
//  DetailsViewController.h
//  A_1990
//
//  Created by lanouhn on 15/6/26.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (nonatomic , retain) UIWebView *webView;

@property (nonatomic , retain) NSString *webHtml;

@property (nonatomic , retain) PostModel *model;

// 用于保存收藏数据到本地文件
@property (nonatomic , retain) NSMutableArray *dataArray;
// 收藏按钮
@property (nonatomic , retain) UIBarButtonItem *collectItem;



@end
