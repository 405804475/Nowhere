//
//  PostTableViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "PaperTableViewController.h"
#import "DetailsViewController.h"



@interface PaperTableViewController ()<UITableViewDelegate, UITableViewDataSource, NetworkEngineDelegate> //遵守协议

//@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic , retain) NSMutableArray *papersModels; //存放数据的model数组

@property (nonatomic , retain) NSString *lastTime;


@end

@implementation PaperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //关闭tableView的垂直滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.lastTime = @"0";
    
    [self getDataFromUrl];
    
    

}

//-(void)viewDidAppear:(BOOL)animated
//{
//    
//    self.view.frame = CGRectMake(self.view.frame.size.width, kTopBtnHeight , self.view.frame.size.width, self.view.frame.size.height - kTopBtnHeight);
//}

#pragma mark - 请求数据方法
- (void)getDataFromUrl
{
    PostModel *model = (PostModel *)[self.papersModels lastObject];
    CGFloat last = [model.id90 floatValue];
    
    //最后一条数据的id为9715
    if (last != 9715) {
      
        // 请求数据
        NSString *url = [NSString stringWithFormat:@"http://app.qdaily.com/app/papers/index/%@.json?" , self.lastTime];
        NetworkEngine *engine = [NetworkEngine networkEngineWithURL:[NSURL URLWithString:url] params:nil delegate:self];
        
        [engine startWithDic:nil];
    }
    
    // 结束刷新
    [self.tableView.footer endRefreshing];
    [self.tableView.header endRefreshing];
}

#pragma mark - 请求数据成功的代理方法
-(void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data
{

#pragma mark - 数据刷新  -- 当 所有 有效数据加载完时,程序会崩溃 (原因: 当最后一组数据加载完时,last_time的value值为null,关键性key值has_more为FALSE,之前都为TRUE)
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *arr = [[[dic objectForKey:@"response"] objectForKey:@"feeds"] objectForKey:@"list"];
    self.lastTime = [[[dic objectForKey:@"response"] objectForKey:@"feeds"] objectForKey:@"last_time"];
    NSLog(@"%@" , self.lastTime);
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dict = [[arr objectAtIndex:i] objectForKey:@"post"];
        PostModel *item = [[PostModel alloc] initWithDictionary:dict];
        
        //添加判断,剔除"投票"类内容
        if (![dict objectForKey:@"image"]) {
            NSString *imageURl = [[arr objectAtIndex:i] objectForKey:@"image"];
            item.imageViewURL = imageURl;
            [self.papersModels addObject:item];
            
            [item release];
        }
    }
    
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    // 上拉刷新
    MyDownLoadGitFooter *footer = [MyDownLoadGitFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataFromUrl)];
    footer.refreshingTitleHidden = YES;
    self.tableView.footer = footer;
    
    
    // 拿到数据之后, 刷新tableView
    [self.tableView reloadData];
    
}

#pragma mark - 下拉刷新
-(void)loadNewData
{
    self.lastTime = @"0";
    
    [self.papersModels removeAllObjects];
    [self.tableView reloadData];
    [self getDataFromUrl];
}


#pragma mark - 懒加载paperModels
- (NSMutableArray *)papersModels
{
    if (!_papersModels) {
        self.papersModels = [NSMutableArray array];
    }
    return _papersModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.papersModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *papersCellID = @"papersCellID";
    PapersCell *cell = [tableView dequeueReusableCellWithIdentifier:papersCellID];
    if (nil == cell) {
        cell = [[PapersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:papersCellID];
    }
    PostModel *model = [self.papersModels objectAtIndex:indexPath.row];
    NSLog(@"%@" , model.title);
    
    // 获取文章title
    cell.titleLabel.text = model.title;
    // 获取文章description
    cell.descriptionLabel.text = model.description90;
    // 获取文章大图
    cell.bigImageView.imageURL = [NSURL URLWithString:model.imageViewURL];
    // 获取category小图
    cell.imageSmallView.imageURL = [NSURL URLWithString:model.category.image_smallURL];
    
    
    return cell;
}

// 跳转到详情界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    PostModel *model = [self.papersModels objectAtIndex:indexPath.row];
    detailVC.webHtml = model.appview;
    detailVC.model = model;
    
    [self presentViewController:detailVC animated:YES completion:nil];
    
    
}


//#pragma mark - 隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 295;
}

- (void)dealloc
{
    [_papersModels release];
    _lastTime = nil;
    [super dealloc];
}

@end
