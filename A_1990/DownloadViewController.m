//
//  DownloadViewController.m
//  A_1990
//
//  Created by lanouhn on 15/7/7.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "DownloadViewController.h"
#import "MovieViewController.h"
#import "DownloadMovieViewController.h"

@interface DownloadViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain) NSMutableArray *dataArray;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的下载";
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    NSString *filePath = [[Function getCachePath] stringByAppendingPathComponent:@"downLoad"];
    if (filePath) {
        self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
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
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    DownloadMovieViewController *downloadMV = [[DownloadMovieViewController alloc]init];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4" , [self.dataArray objectAtIndex:indexPath.row]]];
    
//    movieVC.model.mtvUrl = path;
    downloadMV.path = path;
    [self.navigationController pushViewController:downloadMV animated:YES];
    [movieVC release];
    [downloadMV release];
}



@end
