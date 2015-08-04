//
//  MovieViewController.m
//  YinYueTai
//
//  Created by lanouhn on 15/7/1.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "MovieViewController.h"

@interface MovieViewController ()<UIAlertViewDelegate>

@property (nonatomic , assign) NSInteger mark;
@property (nonatomic , strong) MPMoviePlayerController *player;

@property (nonatomic , strong) NSString *download_link; // 下载链接

@property (nonatomic, strong) AFHTTPRequestOperation *reqestOperation;
@property (nonatomic , strong) Helper *helper;

@property (nonatomic , assign) CGFloat precent;

@property (nonatomic , retain) NSMutableArray *dataArray;

@property (nonatomic , retain) NSMutableArray *downLoadArray;

@property (nonatomic , retain) UILabel *downloadLabel;


@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    self.helper = [Helper shareHelp];
    
#warning 隐藏导航条 (测试用)
//    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
#pragma mark - 下载
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downloadAction:)];
    
    
    NSURL *movieURL = [NSURL URLWithString:self.model.mtvUrl];
    
    MPMoviePlayerViewController *playViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    
    // 添加监听者(全屏之后,按Done退出之后停止播放)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playViewController moviePlayer]];
    
    playViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    
    MPMoviePlayerController *player = [playViewController moviePlayer];
    [player prepareToPlay];
    
    [player play];
    
    [self.view addSubview:player.view];
    
    // 自动播放打开
    player.shouldAutoplay = YES;
    [player setControlStyle:MPMovieControlStyleDefault];
    // 是否充满全屏
    [player setFullscreen:YES];
    [player.view setFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
    
    self.downloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 480, self.view.frame.size.width, 50)];
    self.downloadLabel.textColor = [UIColor whiteColor];
    self.downloadLabel.textAlignment = NSTextAlignmentCenter;
//    self.downloadLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.downloadLabel];
    [self.downloadLabel release];
    
    
    //判断网络
    [self checkNetWorkState];
    
    //播放历史
    [self historyList];
    
    
}

#pragma mark -  ***** 下载  ****
-(void)downloadAction:(UIBarButtonItem *)sender
{
    [self downloadWithURL:self.model.mtvUrl];
}

-(void)downloadWithURL:(NSString *)urlStr
{
    
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加下载" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alerView show];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.reqestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4" , self.model.title]];
    [self.reqestOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
    typeof (self)newSelf = self;
    [self.reqestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        newSelf.precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        newSelf.helper.precent = [NSString stringWithFormat:@"%.2f%%" , (newSelf.precent * 100)];
        
        self.downloadLabel.text = [NSString stringWithFormat:@"已下载%@" , newSelf.helper.precent];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"download" object:@(newSelf.precent)];
        NSLog(@"***** %.2f", newSelf.precent);
    }];
    [self.reqestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"****#######*****");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"**********");
    }];
    [self.reqestOperation start];//开始下载
    
    // 保存下载数据
    NSString *filePath = [[Function getCachePath] stringByAppendingPathComponent:@"downLoad"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        self.downLoadArray = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        self.downLoadArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    if (![self.downLoadArray containsObject:self.model.title]) {
        [self.downLoadArray addObject:self.model.title];
    }
    [self.downLoadArray writeToFile:filePath atomically:YES];
    
}


#pragma mark - 存储播放记录
-(void)historyList
{
    NSString *filePath = [[Function getCachePath]stringByAppendingString:@"/history"];
    NSArray *array = [NSArray arrayWithObjects:self.model.title , self.model.artistName , self.model.posterPic , self.model.mtvUrl , nil];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        self.dataArray = [NSMutableArray array];
    }else {
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    if (![self.dataArray containsObject:array]) {
        [self.dataArray addObject:array];
        [self.dataArray writeToFile:filePath atomically:YES];
    }
    
}




- (void)playVideoFinished:(NSNotification *)theNotification
{
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    
}


#pragma mark - 判断网络状态
- (void)checkNetWorkState
{
    // 先让自动播放停止
    [self.player stop];
    // 1. 检测WIFI状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2. 检测手机是否能上网(wifi\3G\2.5G)
    Reachability *connection = [Reachability reachabilityForInternetConnection];
    // 判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        self.mark = 0;
        [self promptBox];
    } else if ([connection currentReachabilityStatus] != NotReachable) {
        self.mark = 1;
        [self promptBox];
    } else {
        self.mark = 2;
        [self promptBox];
    }
    
}

- (void)promptBox
{
    NSArray *arr = @[@"当前网络处于WiFi状态是否播放", @"使用手机自带网络是否播放",@"当前设备无法连接网络"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:arr[self.mark] delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.player play];
            break;
        case 1:
            if (self.mark == 2) {
//                MTVTableViewController *mtvVC = [[MTVTableViewController alloc] init];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                break;
            }
            break;
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
