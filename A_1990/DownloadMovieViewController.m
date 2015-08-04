//
//  DownloadMovieViewController.m
//  A_1990
//
//  Created by lanouhn on 15/7/7.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "DownloadMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface DownloadMovieViewController ()

@property (nonatomic , assign) NSInteger mark;
@property (nonatomic , retain) MPMoviePlayerController *player;
@property (nonatomic , retain) MPMoviePlayerViewController *playerVC;

@end

@implementation DownloadMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"离线播放";
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;

    NSURL *url = [[NSURL alloc]initFileURLWithPath:self.path];
    _playerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    _player = [_playerVC moviePlayer];
    
    [_player prepareToPlay];
    
    [_player play];
    
    [self.view addSubview:_player.view];
    
    // 自动播放打开
    _player.shouldAutoplay = YES;
    [_player setControlStyle:MPMovieControlStyleDefault];
    // 是否充满全屏
    [_player setFullscreen:YES];
    [_player.view setFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
