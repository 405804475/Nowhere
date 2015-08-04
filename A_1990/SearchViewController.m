//
//  SearchViewController.m
//  A_1990
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailsViewController.h"



@interface SearchViewController ()<UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , NetworkEngineDelegate>

@property (nonatomic , retain) NSString *lastTime;
@property (nonatomic , retain) NSMutableArray *dataArray;

@end

@implementation SearchViewController

- (void)loadView
{
    [super loadView];
    self.searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60)];
   
    self.view = self.searchView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    self.lastTime = @"0";
    self.navigationItem.title = @"搜索";
    
    self.searchView.tableView.dataSource = self;
    self.searchView.tableView.delegate = self;
    self.searchView.searchBar.delegate = self;
    
    
    

}


#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    PostModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
//    cell.textLabel.numberOfLines = 0;
    //cell辅助样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - searchbar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchView.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchView.searchBar.showsCancelButton = NO;
    [self.searchView.searchBar resignFirstResponder];
}

#pragma mark - 搜索请求
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataArray removeAllObjects];
    [self requsetData];
    [searchBar resignFirstResponder];
}

- (void)requsetData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://app.qdaily.com/app/searches/post_list?last_time=%@&search=%@" ,self.lastTime , self.searchView.searchBar.text];
    NSURL *url = [NSURL URLWithString:urlStr];
    NetworkEngine *enging = [NetworkEngine networkEngineWithURL:url params:nil delegate:self];
    [enging startWithDic:nil];
    
    [self.searchView.tableView.footer endRefreshing];
    
    
}

- (void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data
{
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [[[dic objectForKey:@"response"] objectForKey:@"searches"] objectForKey:@"list"];
    self.lastTime = [[[dic objectForKey:@"response"] objectForKey:@"searches"] objectForKey:@"last_time"];
    if (arr.count == 0) {
        UIAlertView *alertView = [Function creatAletViewWithFrame:CGRectMake(0, 0, 100, 30) andTitile:@"搜索结果不存在" andMessage:nil andCancelButtonTitile:@"取消" andOtherTitle1:nil];
        [alertView show];
    }
    for (NSDictionary *temp in arr) {
        NSLog(@"%@" , temp);
        PostModel *model = [[PostModel alloc] init];
        model.title = [[temp objectForKey:@"post"] objectForKey:@"title"];
        model.appview = [[temp objectForKey:@"post"] objectForKey:@"appview"];
        [self.dataArray addObject:model];
        
    }
    
    // 上拉刷新
    MyDownLoadGitFooter *footer = [MyDownLoadGitFooter footerWithRefreshingTarget:self refreshingAction:@selector(requsetData)];
    footer.refreshingTitleHidden = YES;
    self.searchView.tableView.footer = footer;
    
    
    // 拿到数据之后, 刷新tableView
    [self.searchView.tableView reloadData];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailVC = [[DetailsViewController  alloc] init];
    PostModel *model = [self.dataArray objectAtIndex:indexPath.row];
    detailVC.model= model;
    detailVC.webHtml = model.appview;
    [self presentViewController:detailVC animated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc
{
    [self.dataArray release];
    [self.searchView release];
    [super dealloc];
}


@end
