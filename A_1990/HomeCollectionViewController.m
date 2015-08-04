//
//  HomeViewController.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "DetailsViewController.h"
#import "ViewPager.h"


//section 头分区的重用标识符
#define kHeaderIdentifire @"HeaderIdentifire"

//section 脚分区的重用标识符
#define kFooterIdentifire @"FooterIdentifire"


@interface HomeCollectionViewController ()<NetworkEngineDelegate>

@property (nonatomic , retain) NSString *lastTime;
@property (nonatomic , retain) NSMutableArray *homeModels; //存放model
@property (nonatomic , retain) NSMutableArray *banners; //存放轮播图model

@property (nonatomic , retain) ViewPager *viewPager;

@property (nonatomic , retain) MBProgressHUD *hud;

@end

@implementation HomeCollectionViewController

-(instancetype)initWithFrame:(CGRect)frame
{
    //创建collectionView布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat viewWidth = CGRectGetWidth(frame);
//    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat itemWidth = (viewWidth - kMinimumInteritemSpacing) / 2;
    CGFloat itemHeight = itemWidth * kImageHeight / kImageWidth;
    //设置item大小
    layout.itemSize = CGSizeMake(itemWidth , itemHeight + kTitleLabelHeight);
    //item之间最小间距
    layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    //item行之间最小间距
    layout.minimumLineSpacing = kMinimumLineSpacing;
    
    //设置分区页眉（Header）大小
    layout.headerReferenceSize = CGSizeMake(viewWidth, viewWidth * kImageHeight / kImageWidth);
    
    return [self initWithCollectionViewLayout:layout];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    self.view.frame = CGRectMake(0 , kTopBtnHeight , self.view.frame.size.width, self.view.frame.size.height - kTopBtnHeight);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.hud = [[[MBProgressHUD alloc]init] autorelease];
    [self.view addSubview:self.hud];
    _hud.labelText = @"正在加载";
    _hud.mode = MBProgressHUDModeDeterminate;
    [_hud show:YES];
    
    self.lastTime = @"0";
    
    //请求数据
    [self getDataFromUrl];
    
    //关闭collectionView的垂直滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //注册item
    [self.collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:kHomeCellID];
    
    //注册页眉（section的Header）
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifire];
    
    //注册页脚（section的Footer）
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterIdentifire];
    
}

#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.homeModels count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellID forIndexPath:indexPath];

    PostModel *model = [self.homeModels objectAtIndex:indexPath.row];
    cell.homeImage.imageURL = [NSURL URLWithString:model.imageViewURL];
    cell.whiteImage.imageURL = [NSURL URLWithString:model.category.white_imageURL];
    cell.titleLabel.text = model.title;
    return cell;
    
}

#pragma mark - 跳转详情界面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsViewController *detailVC = [[DetailsViewController alloc]init];
    PostModel *model = [self.homeModels objectAtIndex:indexPath.row];
    detailVC.webHtml = model.appview;
#warning 此处必须传model,否则详情界面的收藏功能会无法写入数据
    detailVC.model = model;
    
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}


#pragma mark - homeModels数组懒加载
-(NSMutableArray *)homeModels
{
    if (!_homeModels) {
        self.homeModels = [NSMutableArray array];
    }
    return _homeModels;
}

#pragma mark - banners 数组懒加载
-(NSMutableArray *)banners
{
    if (!_banners) {
        self.banners = [NSMutableArray array];
    }
    return _banners;
}

#pragma mark - 请求数据
-(void)getDataFromUrl
{
    //网络请求
    NSString *url = [NSString stringWithFormat:@"http://app.qdaily.com/app/homes/index/%@.json?" , self.lastTime];
    NetworkEngine *engine = [NetworkEngine networkEngineWithURL:[NSURL URLWithString:url] params:nil delegate:self];
    //启动网络请求
    [engine startWithDic:nil];
    
    //结束刷新
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
}

#pragma mark - 数据请求成功后,解析数据,封装model
-(void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //获取 collection需要展示的数据数组list(内存放每次得到的n个model)
    NSArray *arr = [[[dic objectForKey:@"response"]objectForKey:@"feeds"]objectForKey:@"list"];
    self.lastTime = [[[dic objectForKey:@"response"]objectForKey:@"feeds"]objectForKey:@"last_time"];
    
    //获取 轮播图 需要展示的数据数组list
    NSArray *views = [[[dic objectForKey:@"response"]objectForKey:@"banners"]objectForKey:@"list"];
    for (int i = 0 ; i < views.count ; i++) {
        NSDictionary *dict = [[views objectAtIndex:i]objectForKey:@"post"];
        PostModel *item = [[PostModel alloc]initWithDictionary:dict];
        //剔除"投票类"
        if (![dict objectForKey:@"image"]){
            NSString *imageUrl = [[views objectAtIndex:i]objectForKey:@"image"];
            item.imageViewURL = imageUrl;
            [self.banners addObject:item];
            [item release];
        }
        
    }
    [self.hud removeFromSuperview];
    
    //上拉刷新列表时,不断获取model,array用于存放刷新后的model
    for (int i = 0 ; i < arr.count ; i++) {
        NSDictionary *dict = [[arr objectAtIndex:i] objectForKey:@"post"];
        
        //剔除 "这个设计了不起" ,即description为空(null)
        if (![[dict objectForKey:@"description"]isKindOfClass:[NSNull class]]) {
            PostModel *item = [[PostModel alloc]initWithDictionary:dict];
            if (![dict objectForKey:@"image"]) {
            NSString *imageUrl = [[arr objectAtIndex:i]objectForKey:@"image"];
            item.imageViewURL = imageUrl;
            [self.homeModels addObject:item];
            
            [item release];
            }
        }
    }
    
    //下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    //上拉刷新
    MyDownLoadGitFooter *footer = [MyDownLoadGitFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataFromUrl)];
    footer.refreshingTitleHidden = YES;
    self.collectionView.footer = footer;
    
    //拿到数据后刷新collectionView
    [self.collectionView reloadData];
}

-(void)loadNewData
{
    self.lastTime = @"0";
    //下拉刷新时需要注意 **** self.banners **** 数组需要情空,否则,会一直重复添加轮播图元素
    [self.banners removeAllObjects];
    [self.collectionView reloadData];
    //清空home的model数组
    [self.homeModels removeAllObjects];
    [self getDataFromUrl];
}


#pragma mark - 添加轮播图(scrollView)
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifire forIndexPath:indexPath];
            
            //设置headerView的bounds,目的使scrollView轮播图与collectionView的cell有间隔
            headerView.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * kImageHeight / kImageWidth + 5);
            
            headerView.userInteractionEnabled = YES;
            
            self.viewPager = [[ViewPager alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.width * kImageHeight / kImageWidth ) andPages:self.banners];
            [headerView addSubview:self.viewPager];
        
            //给scrollView的视图添加tap手势
            for (int i = 0 ; i < self.viewPager.myPageControl.numberOfPages ; i++) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
                UIView *view = [self.viewPager.myScrollView viewWithTag:101 + i];
                [view addGestureRecognizer:tap];
            }
        
        return headerView;
    }else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterIdentifire forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor yellowColor];
        return footerView;
    }
}

#pragma mark - 轮播图tap手势点击进入详情界面
-(void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    //确定点击当前视图的View的tag值
    UIView *view = [gestureRecognizer view];
    PostModel *model = [self.banners objectAtIndex:view.tag - 101];
    DetailsViewController *detailsVC = [[DetailsViewController alloc]init];
    detailsVC.webHtml = model.appview;
    
//    detailsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
#pragma mark - 点击轮播图 切换 详情界面 水波纹效果
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:detailsVC animated:YES completion:nil];
}



-(void)dealloc
{
    _lastTime = nil;
    [_homeModels release];
    [_banners release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
