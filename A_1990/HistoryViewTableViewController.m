//
//  HistoryViewTableViewController.m
//  YinYueTai
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "HistoryViewTableViewController.h"
#import "HistoryCell.h"
#import "MovieViewController.h"

@interface HistoryViewTableViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic , retain) NSArray *historyModelArr;

@end

@implementation HistoryViewTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSString *filePath = [[Function getCachePath] stringByAppendingString:@"/history"];
    self.dataArr = [NSMutableArray arrayWithContentsOfFile:filePath];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"播放历史";
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[HistoryCell class] forCellReuseIdentifier:@"cellID"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
}

-(void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"完成";
    }else {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"编辑";
    }
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
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *dataArray = [self.dataArr objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dataArray objectAtIndex:0];
    cell.historyImage.imageURL = [NSURL URLWithString:[dataArray objectAtIndex:2]];
    cell.singerLabel.text = [dataArray objectAtIndex:1];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    
    NSArray *arr = [self.dataArr objectAtIndex:indexPath.row];
    
    MTVModel *model = [[MTVModel alloc] init];
    model.title = [arr objectAtIndex:0];
    model.artistName = [arr objectAtIndex:1];
    model.posterPic = [arr objectAtIndex:2];
    model.mtvUrl = [arr objectAtIndex:3];
    movieVC.model = model;
    
    [self.navigationController pushViewController:movieVC animated:YES];
    [movieVC release];

}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}



#pragma mark - TableView Edit

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:YES];
//    [self.tableView setEditing:YES animated:YES];
//}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.dataArr objectAtIndex:indexPath.row];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [[Function getCachePath] stringByAppendingString:@"/history"];
//    self.dataArr = [NSMutableArray arrayWithContentsOfFile:filePath];
   
    [self.dataArr removeObject:arr];
    [self.tableView reloadData];
    [manager removeItemAtPath:filePath error:nil];
        [self.dataArr writeToFile:filePath atomically:YES];
    NSLog(@"fsdfd");
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)dealloc
{
    [_dataArr release];
//    [_historyModelArr release];
    [_HistoryTitle release];
    [super dealloc];
}
@end
