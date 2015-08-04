//
//  ViewPager.m
//  A_1990
//
//  Created by lanouhn on 15/6/28.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "ViewPager.h"

@implementation ViewPager

-(instancetype)initWithFrame:(CGRect)frame andPages:(NSArray *)pages
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubviews:pages];
    }
    return self;
}

-(void)addSubviews:(NSArray *)pages
{
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    
    //设置代理
    self.myScrollView.delegate = self;
    NSInteger views = [pages count];
    self.myScrollView.contentSize = CGSizeMake(self.frame.size.width * views , 0);
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    //边缘无弹回效果
    self.myScrollView.bounces = NO;
    
    self.myScrollView.userInteractionEnabled = YES;
    
    for (int i = 0 ; i < [pages count] ; i++) {
        EGOImageView *image = [[EGOImageView alloc]init];
        UILabel *label = [Function createLabelWithName:nil andFrame:CGRectMake(20 , self.frame.size.height - 50 - 20, self.frame.size.width - 40, 50)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        image.userInteractionEnabled = YES;
        image.frame = CGRectMake(self.frame.size.width * i , 0, self.frame.size.width, self.frame.size.height);
        PostModel *model = (PostModel *)[pages objectAtIndex:i];
        NSString *urlStr = model.imageViewURL;
        label.text = model.title;
        image.imageURL = [NSURL URLWithString:urlStr];
        image.tag = 101 + i;
        
        [image addSubview:label];
        [self.myScrollView addSubview:image];
        [image release];
    }
    
    [self addSubview:self.myScrollView];
    
    //创建PageControl
    self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20 , self.frame.size.width, 20)];
    self.myPageControl.numberOfPages = [pages count];
    self.myPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [self addSubview:self.myPageControl];
    
    [self.myPageControl release];
    [self.myScrollView release];
    
    //开启定时器
    [self addTimer];
   
}

-(void)addTimer
{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
#warning 轮播图定时器开启
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//开启定时器后 , 根据当前页更改scrollView的偏移量
-(void)nextImage
{
    //self.myPageControl.currentPage首页为0
    int page = (int)self.myPageControl.currentPage;
    if (page == self.myPageControl.numberOfPages - 1) {
        page = 0;
    }else {
        page++;
    }
    
    //设置scrollView滚动偏移量
    CGFloat x = page * self.myScrollView.frame.size.width;
    self.myScrollView.contentOffset = CGPointMake(x, 0);
    
}
//scrollView滚动时调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"滚动中");
    
//    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = x / self.myScrollView.frame.size.width;
    
    if (page == self.myPageControl.numberOfPages - 1) {
        page = 0;
    }
    
    self.myPageControl.currentPage = page;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //开启定时器
    [self addTimer];
}
//开始拖拽时调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //注意:定时器一旦关闭,将无法再开启
//    [self removeTimer];
    [self.timer invalidate];
}

//关闭定时器
//-(void)removeTimer
//{
//    [self.timer invalidate];
//}


@end
