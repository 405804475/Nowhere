//
//  ShowViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//
#define kListCellID @"ListCellID"
#import "ListViewController.h"
#import "ListCell.h"
@interface ListViewController ()<NetworkEngineDelegate>

@property (nonatomic , retain) NSString *lastTime;

@end

@implementation ListViewController : UIViewController

- (void)loadView
{
    [super loadView];
    self.listView = [[ListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.listView;
    [self.listView release];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加搜索 图标
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toSearchVC)];
    
    
    
    //根据listID得到的值,显示相应分类title
    switch (self.listID) {
        case 18:
            self.navigationItem.title = @"商业";
            break;
        case 17:
            self.navigationItem.title = @"设计";
            break;
        case 3:
            self.navigationItem.title = @"娱乐";
            break;
        case 4:
            self.navigationItem.title = @"智能";
            break;
        case 19:
            self.navigationItem.title = @"时尚";
            break;
        case 5:
            self.navigationItem.title = @"城市";
            break;
        case 54:
            self.navigationItem.title = @"游戏";
            break;
        case 11:
            self.navigationItem.title = @"数字";
            break;
        default:
            break;
    }
    
    self.lastTime = @"0";
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    
    self.listView.myCollectionView.delegate = self;
    self.listView.myCollectionView.dataSource = self;
    // 注册item
    [self.listView.myCollectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kListCellID];
   
    // 请求数据
    [self getDataFromUrl];
}

#pragma mark - 跳转 搜索 页面
-(void)toSearchVC
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)getDataFromUrl
{
    NetworkEngine *engine = [NetworkEngine networkEngineWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.qdaily.com/app/categories/index/%ld/%@.json?" , self.listID , self.lastTime]] params:nil delegate:self];
    [engine startWithDic:nil];
    
    //结束刷新
    [self.listView.myCollectionView.header endRefreshing];
    [self.listView.myCollectionView.footer endRefreshing];
}
#pragma mark - listModelArray懒加载
-(NSMutableArray *)listModelArray
{
    if (!_listModelArray) {
        self.listModelArray = [NSMutableArray array];
    }
    return _listModelArray;
}

#pragma mark - 请求数据成功的dailifangfa

-(void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data
{
    // 初始化存放model的数组
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = [[[dic objectForKey:@"response"] objectForKey:@"feeds"] objectForKey:@"list"];
     self.lastTime = [[[dic objectForKey:@"response"]objectForKey:@"feeds"]objectForKey:@"last_time"];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = [[array objectAtIndex:i] objectForKey:@"post"];
        PostModel *model = [[PostModel alloc] initWithDictionary:dict];
        NSString *imageUrl = [[array objectAtIndex:i]objectForKey:@"image"];
        model.imageViewURL = imageUrl;
        
        [self.listModelArray addObject:model];
        
        NSLog(@"********** %@" , model.appview);
        
        [model release];
    }
    
    //下拉刷新
    self.listView.myCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //上拉刷新
    MyDownLoadGitFooter *footer = [MyDownLoadGitFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataFromUrl)];
    footer.refreshingTitleHidden = YES;
    self.listView.myCollectionView.footer = footer;
    
    
    [self.listView.myCollectionView reloadData];
    
}

#pragma mark - 下拉刷新
-(void)loadNewData
{
    self.lastTime = @"0";
    //清空list的model数组
    [self.listModelArray removeAllObjects];
    [self.listView.myCollectionView reloadData];
    [self getDataFromUrl];
}


#pragma mark - collectionView 代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.listModelArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kListCellID forIndexPath:indexPath];
    PostModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.homeImage.imageURL = [NSURL URLWithString:model.imageViewURL];
    cell.whiteImage.imageURL = [NSURL URLWithString:model.category.white_imageURL];
    return cell;
}

#pragma mark - 跳转详情界面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailVC = [[DetailsViewController alloc]init];
    PostModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    detailVC.webHtml = model.appview;
    detailVC.model = model;
    NSLog(@"%@" , detailVC.webHtml);
#pragma mark - 列表页 跳转 详情页 页面的动画(cube)
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}
- (void)dealloc
{
    [_listModelArray release];
    [_listView release];
    [super dealloc];
}
@end
