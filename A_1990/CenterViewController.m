//
//  CenterViewController.m
//  A_1990
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "CenterViewController.h"

#import "CollectViewController.h"
#import "HistoryViewTableViewController.h"
#import "SetViewController.h"
#import "DownloadViewController.h"

@interface CenterViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain) UITableView *tableView;


@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    self.navigationItem.title = @"个人中心";
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}


#pragma mark - UItableView Delegate 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *centerCellID = @"centerCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellID];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:centerCellID];
        }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"播放历史";
        }else {
            cell.textLabel.text = @"我的下载";
        }
        //cell辅助样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"设置";
        //cell辅助样式
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.textLabel.text = @"清除缓存";
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            CollectViewController *collectVC = [[CollectViewController alloc]init];
            [self.navigationController pushViewController:collectVC animated:YES];
        }else if (indexPath.row == 1){
            HistoryViewTableViewController *historyVC = [[HistoryViewTableViewController alloc]init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }else {
            DownloadViewController *downloadVC = [[DownloadViewController alloc]init];
            [self.navigationController pushViewController:downloadVC animated:YES];
        }
    }else if (indexPath.section == 1){
        SetViewController *setVC = [[SetViewController alloc]init];
        [self.navigationController pushViewController:setVC animated:YES];
    }else {
#pragma mark - 清除缓存操作
        EGOCache *egachae = [[EGOCache alloc] init];
        [egachae clearCache];
        UIAlertView *alertView = [Function creatAletViewWithFrame:CGRectMake(self.view.frame.size.width / 2 - 25, self.view.frame.size.height / 2 - 25, 50, 50) andTitile:@"清理缓存成功" andMessage:nil andCancelButtonTitile:@"确定" andOtherTitle1:nil];
        [alertView show];
    }
}



-(void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
