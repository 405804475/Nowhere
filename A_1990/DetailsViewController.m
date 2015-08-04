//
//  DetailsViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/26.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "DetailsViewController.h"



@interface DetailsViewController ()<MBProgressHUDDelegate>

@property (nonatomic , assign) BOOL isLike;
@property (nonatomic , assign) int likeNum;



@end

@implementation DetailsViewController

//当视图显示时,判断当前详情内容是否 被收藏
-(void)viewWillAppear:(BOOL)animated
{
    NSString *filePath = [[Function getCachePath] stringByAppendingPathComponent:@"collect"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSArray *arr = [NSArray arrayWithObjects:self.model.title, self.model.imageViewURL , self.model.appview, nil];
    if ([self.dataArray containsObject:arr]) {
        self.collectItem.title = @"取消收藏";
    }
    else
    {
        self.collectItem.title = @"收藏";
    }
  
}


-(void)getDataFromWeb
{
    NSURL *url = [NSURL URLWithString:self.webHtml];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [request release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self getDataFromWeb];
    
    // 详情界面状态栏底色Label
    UILabel *whiteLabel = [Function createLabelWithName:nil andFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, kStatusBarHeight)];
    whiteLabel.backgroundColor = [UIColor whiteColor];
    
    // 详情界面toolBar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - kTooBarHeight , self.view.frame.size.width, kTooBarHeight)];
    
//    toolBar.backgroundColor = kBackgroundColor;
    toolBar.barTintColor = kBackgroundColor;
    
    
    //toolBar上的btnItem ("收藏" , "取消收藏" , "清理缓存")
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)];
    
    self.collectItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(ItemAction:)];
    
    //空白间隔
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //分享
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareItem:)];
    backItem.tintColor =  kTintColor;
    shareItem.tintColor = kTintColor;
    _collectItem.tintColor = kTintColor;
    
    
    toolBar.items = [NSArray arrayWithObjects:backItem , fixItem , shareItem ,_collectItem ,nil];
    
    
    [self.webView addSubview:whiteLabel];
    [self.view addSubview:self.webView];
    [self.webView addSubview:toolBar];
    
    [self.webView release];
    [backItem release];
    [fixItem release];
    [shareItem release];
    [_collectItem release];
    [toolBar release];
    
}




#pragma mark - ToolBar 分享
-(void)shareItem:(UIBarButtonItem *)sender
{
    //风格一
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"558f95f66758e24b1005295" shareText:self.model.appview shareImage:nil shareToSnsNames:nil delegate:nil];
    
    //风格二
//      [UMSocialSnsService presentSnsController:self appKey:@"558f95f66758e24b1005295" shareText:self.model.title shareImage:nil shareToSnsNames:nil delegate:nil];
}

#pragma mark - ToolBar 返回按钮
- (void)backItem:(UIBarButtonItem *)sender
{
    [self.webView goBack];
    
//设置导航条,解决了view置顶的问题
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回");
    }];
}

#pragma mark - 收藏 , 取消收藏
- (void)ItemAction:(UIBarButtonItem *)sender
{
    NSString *filePath = [[Function getCachePath] stringByAppendingPathComponent:@"collect"];
    NSArray *arr = [NSArray arrayWithObjects:self.model.title, self.model.imageViewURL, self.model.appview, nil];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    if ([self.collectItem.title isEqualToString:@"收藏"]) {
        [self.dataArray addObject:arr];
        [self.dataArray writeToFile:filePath atomically:YES];
#pragma mark - 添加收藏 吮吸动画
        //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
        CATransition *transition = [CATransition animation];
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"suckEffect";
        transition.subtype = kCATransitionFromBottom;
        transition.delegate = self;
        
        [self.view.layer addAnimation:transition forKey:nil];
        
        sender.title = @"取消收藏";
    }
    else
    {
        [self.dataArray removeObject:arr];
        [manager removeItemAtPath:filePath error:nil];
        [self.dataArray writeToFile:filePath atomically:YES];
        UIAlertView *alertView1 = [Function creatAletViewWithFrame:CGRectMake(self.view.frame.size.width/2 - 25, self.view.frame.size.height/ 2 - 25, 50, 50) andTitile:@"取消收藏" andMessage:nil andCancelButtonTitile:@"确定" andOtherTitle1:nil];
        [alertView1 show];
        sender.title = @"收藏";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    _webHtml = nil;
    [_model release];
    [_dataArray release];
    [_collectItem release];
    [_webView release];
    [super dealloc];
}
@end
