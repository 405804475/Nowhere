//
//  MTVTableViewController.m
//  YinYueTai
//
//  Created by lanouhn on 15/6/30.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "MTVTableViewController.h"
#import "MyDownLoadGitFooter.h"
#import "SXWaveCell.h"

// MTV 热播URL
//#define kYinYueTaiUrl @"http://mapi.yinyuetai.com/video/list.json?D-A=0&area=DAYVIEW_ALL&offset=%d&size=5"

// MTV 首播URL
#define kSBYinYueTaiUrl @"http://mapi.yinyuetai.com/video/list.json?D-A=0&area=ALL&offset=%d&size=5"

@interface MTVTableViewController ()<UITableViewDelegate, UITableViewDataSource, NetworkEngineDelegate>

@property (nonatomic , retain) NSMutableArray *arr;

@property (nonatomic , assign) int offset;
@property (nonatomic , assign) int size;
@property (nonatomic , retain) MBProgressHUD *hud;
@property (nonatomic , retain) SXWaveCell *wave;

@end

@implementation MTVTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =  @"音乐";
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;

    self.hud = [[[MBProgressHUD alloc]init] autorelease];
    [self.view addSubview:self.hud];
    
    _hud.labelText = @"正在加载";
    _hud.mode = MBProgressHUDModeCustomView;
    self.wave = [SXWaveCell wave];
    [self.wave setPrecent:nil textColor:[UIColor whiteColor] type:1 alpha:0.3];
    [self.wave addAnimateWithType:1];
    _hud.customView = self.wave;
    _hud.dimBackground = YES;
    [_hud show:YES];

    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[[UIRefreshControl alloc] init] autorelease];      //tableviewcontroll的子类
    [self.refreshControl addTarget:self action:@selector(handleRefreshAction:) forControlEvents:UIControlEventValueChanged];

    //offset 初始值为0
    self.offset = 0;
    self.size = 5;
    [self getDataFromUrl];
    
}

#pragma mark - 下拉刷新(得到最新数据)
-(void)handleRefreshAction:(UIRefreshControl *)sender
{
    //将offset重置为0
    self.offset = 0;
    [self getDataFromUrl];
}

#pragma mark - 请求数据方法
- (void)getDataFromUrl
{
    // 创建Url地址
    //offset 开始下标  size 可看为每次获取model数组的count数
    //totalCount 2540 数据库中一共有2540条数据
    NSString *urlStr = [NSString stringWithFormat:kSBYinYueTaiUrl ,self.offset];

    NSURL *url = [NSURL URLWithString:urlStr];
    
//    // 参数个数
    NSDictionary *dic =  @{@"Host":@"mapi.yinyuetai.com",
                                     @"App-Id":@"10101022" ,
                                     @"Authorization":@"Bearer web-de0c2894fb9ee893CP79z1ZBs9.d8658.0" ,
                                     @"Device-Id":@"a3f6da69a353a37c55d78974636536b9" ,
                                     @"Device-V":@"aVBob25lIE9TXzguM182NDAqMTEzNl8xMDAwMDEwMDBfaVBob25lNiwy"};

    NetworkEngine *engine = [NetworkEngine networkEngineWithURL:url params:nil delegate:self];
    
    [engine startWithDic:dic];
    
    //停止刷新数据
    [self.tableView.footer endRefreshing];
    
}


#pragma mark - 请求数据成功后的代理方法
- (void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data
{
  
    [self.refreshControl endRefreshing];
    if (self.offset == 0) {
        [self.arr removeAllObjects];//移除之前保存的数据
    }

    
    //让offset增加
    self.offset = self.offset + self.size;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *items = [dic objectForKey:@"videos"];
    for (NSDictionary *dict in items) {
        MTVModel *model = [[MTVModel alloc] initWithDictionary:dict];
        [_arr addObject:model];
        [model release];
    }
    
    [self.hud removeFromSuperview];
    
    //上拉刷新
    MyDownLoadGitFooter *footer = [MyDownLoadGitFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataFromUrl)];
    footer.refreshingTitleHidden = YES;
    self.tableView.footer = footer;
    
    
    //拿到数据之后,刷新tableView
    [self.tableView reloadData];
}


// 懒加载
- (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    MTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[MTVCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    MTVModel *model = [self.arr objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.artistNameLabel.text = model.artistName;
    cell.mtvImageView.imageURL = [NSURL URLWithString:model.posterPic];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

#pragma mark - 点击 进入视频播放界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieViewController *movieVC = [[MovieViewController alloc]init];
    MTVModel *model = [self.arr objectAtIndex:indexPath.row];
    movieVC.model = model;
    
#pragma mark - 添加进入mv播放页面 动画 (打开摄像头效果)
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = @"cameraIrisHollowOpen";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:movieVC animated:YES];
}

-(void)dealloc
{
    [_hud release];
    [_wave release];
    [super dealloc];
}

@end
