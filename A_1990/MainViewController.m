//
//  MainViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/26.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>



@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.homeBtn.hidden = NO;
    self.paperBtn.hidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //关闭导航条毛玻璃效果  
    self.navigationController.navigationBar.translucent = NO;
    
    
    
#pragma mark - 设置app的title
    self.navigationItem.title = @"No Where";
    
    //设置导航条的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:36.0 / 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = kTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTintColor ,NSForegroundColorAttributeName,  nil]];
    
    
    //添加leftItemBar，点击弹出侧边栏
    UIBarButtonItem *openItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(openBtnPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
    openItem.tintColor =  [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openBtnPressed)];
    
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    [openItem release];

    
    
    
    //获取屏幕宽度和高度
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    //创建home和paper按钮
    self.homeBtn = [Function createButtonWithName:@"眼界" andFrame:CGRectMake(50, 10, (viewWidth - 100) / 2 , kTopBtnHeight - 10)];
    self.homeBtn.tag = 101;
    [self.homeBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    //默认home按钮为选中状态
    self.homeBtn.selected = YES;
    
    self.paperBtn = [Function createButtonWithName:@"报告" andFrame:CGRectMake(50 + (viewWidth - 100) / 2 , 10, (viewWidth - 100) / 2 , kTopBtnHeight - 10)];
    self.paperBtn.tag = 102;
    [self.paperBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.homeBtn.backgroundColor = kBackgroundColor;
    self.paperBtn.backgroundColor = kBackgroundColor;
    
    self.homeBtn.tintColor = kTintColor;
    self.paperBtn.tintColor = kTintColor;
    
 
    //创建scrollView,控制home和paper两个界面的滑动切换
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , viewWidth, viewHeight - kTopBtnHeight)];
    //****  不允许垂直方向上进行滚动  ****
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2 , 0);
    //设置scrollView属性
    //整页翻动
    self.scrollView.pagingEnabled = YES;
    //边缘无弹回效果
    self.scrollView.bounces = NO;
    //不显示水平,垂直滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    //切换视图
    self.homeVC = [[HomeCollectionViewController alloc]initWithFrame:self.view.bounds];
    self.paperVC = [[PaperTableViewController alloc]init];
    UIView *view1 = self.homeVC.view;
    UIView *view2 = self.paperVC.view;

    view1.frame = CGRectMake(0, 0, viewWidth, viewHeight - kTopBtnHeight);
    view2.frame = CGRectMake(viewWidth ,0, viewWidth , viewHeight - kTopBtnHeight);
    //设置scrollView代理
    self.scrollView.delegate = self;
    
    //添加
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    [self.view addSubview:self.scrollView];
    
    [self.navigationController.view addSubview:self.homeBtn];
    [self.navigationController.view addSubview:self.paperBtn];
    

    [self addChildViewController:self.homeVC];
    [self addChildViewController:self.paperVC];
    
    
}

#pragma mark - 点击弹出菜单栏
-(void)openBtnPressed
{
    NSLog(@"弹出菜单栏");
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}


#pragma mark - top按钮点击选择
-(void)clickAction:(UIButton *)sender
{
    NSLog(@"测试topBtn点击");
    switch (sender.tag) {
        case 101:
            self.homeBtn.selected = YES;
            self.paperBtn.selected = NO;
            self.scrollView.contentOffset = CGPointMake(0 , 0);
            NSLog(@"测试homeBtn点击");
            break;
        case 102:
            self.homeBtn.selected = NO;
            self.paperBtn.selected = YES;
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width , 0);
            NSLog(@"测试paperBtn点击");
            break;
        default:
            break;
    }
}

#pragma mark - scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算偏移几个view的宽度
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    //滑动切换界面
    switch (index) {
        case 0:
            self.homeBtn.selected = YES;
            self.paperBtn.selected = NO;
            self.scrollView.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            self.paperBtn.selected = YES;
            self.homeBtn.selected = NO;
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
            break;
        default:
            break;
    }
}


-(void)dealloc
{
    [_homeBtn release];
    [_paperBtn release];
    [_scrollView release];
    [_homeVC release];
    [_paperVC release];
    [super dealloc];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
