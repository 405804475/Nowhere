//
//  LeftSideView.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "LeftSideView.h"




@implementation LeftSideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    // 添加背景图片
//    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
//    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    //背景图充满scrollView的内容视图
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.backgroundImageView];
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
 
    //添加五芒星
    NSDictionary *valueDic = kInitPentacle;
    //创建五芒星视图
    self.spiderView = [[BTSpiderPlotterView alloc]initWithFrame:CGRectMake(25, 50, 200 , 200) valueDictionary:valueDic];
//    self.spiderView.backgroundColor = [UIColor yellowColor];
    [self.spiderView setMaxValue:1.0];
    [self addSubview:_spiderView];
    [self.spiderView release];
    
    // 添加头像
    self.headImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"profile"]]; //设置默认头像图片
    self.headImageView.frame = CGRectMake(70, 70, 60, 60);
//    _headImageView.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:185.0/255.0 blue:190.0/255.0 alpha:1.0];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = _headImageView.bounds.size.width/2;
    [self.spiderView addSubview:_headImageView];
    
    
    // 添加 进入个人中心 Button
    self.centerButton = [Function createButtonWithName:@"个人中心" andFrame:CGRectMake(koriginX , Koriginy - 60, Kwidth, Kheight)];
    self.centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.centerButton setTitleColor:[UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.centerButton];
    
    self.loginBtn = [Function createButtonWithName:@"登录" andFrame:CGRectMake(koriginX + Kwidth + kSpace , Koriginy - 60, Kwidth, Kheight)];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.loginBtn setTitleColor:[UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self addSubview:self.loginBtn];
    
    // 添加首页Button
    self.firstPageButton = [Function createButtonWithName:@"随便" andFrame:CGRectMake(koriginX, Koriginy, Kwidth, Kheight)];
    self.firstPageButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.firstPageButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    [self addSubview:self.firstPageButton];
    
    // 添加收藏Button
    self.collectButton = [Function createButtonWithName:@"收藏" andFrame:CGRectMake(koriginX + Kwidth + kSpace , Koriginy , Kwidth, Kheight)];
    self.collectButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.collectButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    [self addSubview:self.collectButton];
    
    // 1.商业button
    self.commerceButton = [Function createButtonWithName:@"商业" andFrame:CGRectMake(koriginX , Koriginy + Kheight + kSpace, Kwidth, Kheight)];
    self.commerceButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.commerceButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.commerceButton.tag = kBusiness;
    [self addSubview:self.commerceButton];
    
    // 2.智能Button
    self.intelligentButton = [Function createButtonWithName:@"智能" andFrame:CGRectMake(self.commerceButton.frame.origin.x + Kwidth + kSpace , self.commerceButton.frame.origin.y , Kwidth, Kheight)];
    self.intelligentButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.intelligentButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.intelligentButton.tag = kIntelligent;
    [self addSubview:self.intelligentButton];
    
    // 3.设计Button
    self.desginButton = [Function createButtonWithName:@"设计" andFrame:CGRectMake(koriginX, self.commerceButton.frame.origin.y + Kheight + kSpace, Kwidth, Kheight)];
    self.desginButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.desginButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.desginButton.tag = kDesign;
    [self addSubview:self.desginButton];
    
    // 4.时尚button
    self.fashionButton = [Function createButtonWithName:@"时尚" andFrame:CGRectMake(koriginX + Kwidth + kSpace , self.desginButton.frame.origin.y , Kwidth, Kheight)];
    self.fashionButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.fashionButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.fashionButton.tag = kFashion;
    [self addSubview:self.fashionButton];
    
    // 5.娱乐button
    self.entertainButton = [Function createButtonWithName:@"娱乐" andFrame:CGRectMake(koriginX, self.desginButton.frame.origin.y + Kheight + kSpace, Kwidth, Kheight)];
    self.entertainButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.entertainButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.entertainButton.tag = kEntertainment;
    [self addSubview:self.entertainButton];
    
    // 6.城市button
    self.cityButton = [Function createButtonWithName:@"城市" andFrame:CGRectMake(koriginX + Kwidth + kSpace, self.entertainButton.frame.origin.y , Kwidth, Kheight)];
    self.cityButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.cityButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.cityButton.tag = kCity;
    [self addSubview:self.cityButton];
    
    // 7.游戏button
    self.gameButton = [Function createButtonWithName:@"游戏" andFrame:CGRectMake(koriginX , self.entertainButton.frame.origin.y + Kheight + kSpace, Kwidth, Kheight)];
    self.gameButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.gameButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.gameButton.tag = kGame;
    [self addSubview:self.gameButton];
    
    // 8.音乐button
    self.mvButton = [Function createButtonWithName:@"音乐" andFrame:CGRectMake(koriginX + Kwidth + kSpace, self.gameButton.frame.origin.y , Kwidth, Kheight)];
    self.mvButton.backgroundColor = [UIColor colorWithRed:36.0/ 255.0 green:47.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
    self.mvButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    self.mvButton.tag = kMV;
    [self addSubview:self.mvButton];
    
    
    // 设置Button
    self.setButton = [Function createButtonWithName:@"设置" andFrame:CGRectMake(koriginX , self.gameButton.frame.origin.y + Kheight + kSpace, Kwidth, Kheight)];
    self.setButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    [self addSubview:self.setButton];
    
    // 查找Button
    self.searchButton = [Function createButtonWithName:@"搜索" andFrame:CGRectMake(koriginX + Kwidth + kSpace, self.setButton.frame.origin.y , Kwidth, Kheight)];
    self.searchButton.tintColor = [UIColor colorWithRed:0 green:216.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    [self addSubview:self.searchButton];
    
    
    
}

- (void)dealloc
{
    [_backgroundImageView release];
    [_spiderView release];
    [_headImageView release];
    [_centerButton release];
    [_firstPageButton release];
    [_collectButton release];
    [_commerceButton release];
    [_intelligentButton release];
    [_desginButton release];
    [_fashionButton release];
    [_entertainButton release];
    [_cityButton release];
    [_gameButton release];
    [_mvButton release];
    [_setButton release];
    [_searchButton release];
    [super dealloc];
}


@end
