//
//  CollectViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "CollectViewController.h"



//item cell 的重用标识符
#define kListCellID @"ListCellID"

@interface CollectViewController ()<UICollectionViewDataSource , UICollectionViewDelegate>

@end

@implementation CollectViewController

-(void)viewWillAppear:(BOOL)animated
{
    NSString *filePath = [[Function getCachePath] stringByAppendingPathComponent:@"collect"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSLog(@"%@" , self.dataArray);
    NSLog(@"%ld" , self.dataArray.count);
    [self.collectView.myCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"我的收藏";
    
    //在列表分类页面隐藏navigation上的home , paper按钮
    UIButton *btn1 = (UIButton *)[self.navigationController.view viewWithTag:101];
    btn1.hidden = YES;
    UIButton *btn2 = (UIButton *)[self.navigationController.view viewWithTag:102];
    btn2.hidden = YES;
    
    
    self.collectView = [[ListView alloc] initWithFrame:self.view.frame];
    self.view = self.collectView;
    [self.collectView release];

    
    self.collectView.myCollectionView.delegate = self;
    self.collectView.myCollectionView.dataSource = self;
    // 注册item
    [self.collectView.myCollectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kListCellID];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kListCellID forIndexPath:indexPath];
 
    NSArray *inforArray = [self.dataArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = [inforArray objectAtIndex:0];
    cell.homeImage.imageURL = [NSURL URLWithString:[inforArray objectAtIndex:1]];
   
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    
    
    NSArray *arr = [self.dataArray objectAtIndex:indexPath.row];
    detailVC.webHtml = [arr objectAtIndex:2];
    
    PostModel *model = [[PostModel alloc] init];
    model.title = [arr objectAtIndex:0];
    model.imageViewURL = [arr objectAtIndex:1];
    model.appview = [arr objectAtIndex:2];
    
    detailVC.model = model;
    
    [self presentViewController:detailVC animated:YES completion:nil];
    
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    [detailVC release];
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

- (void)dealloc
{
    [_collectView release];
    [super dealloc];
}

@end
