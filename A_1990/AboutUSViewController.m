//
//  AboutUSViewController.m
//  A_1990
//
//  Created by lanouhn on 15/7/5.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    self.navigationItem.title = @"关于我们";
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"113" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UILabel *CTO = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 20, 200)];
    CTO.text = @"首席设计师 | 石晨欣";
    CTO.numberOfLines = 0;
    CTO.textColor = [UIColor colorWithRed:255.0 / 255.0 green:184.0 / 255.0 blue:7.0 / 255.0 alpha:1.0];
    
    
    UILabel *CEO = [[UILabel alloc] initWithFrame:CGRectMake(180, 220, 20, 200)];
    CEO.text = @"首席大法师 | 朱登迪";
    CEO.numberOfLines = 0;
    CEO.textColor = [UIColor blackColor];
    
    UILabel *CFO = [[UILabel alloc] initWithFrame:CGRectMake(260, 240, 20, 240)];
    CFO.text = @"首席技术总监 | 宋文浩";
    CFO.numberOfLines = 0;
    CFO.textColor = [UIColor whiteColor];
    
    
    [imageView addSubview:CEO];
    [imageView addSubview:CFO];
    [imageView addSubview:CTO];
    [self.view addSubview:imageView];
    [imageView release];
    [CFO release];
    [CEO release];
    [CTO release];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
