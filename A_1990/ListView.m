//
//  ListView.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "ListView.h"


@implementation ListView


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
    

    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    CGFloat viewWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    // 设置item的大小
    layout.itemSize = CGSizeMake((self.frame.size.width - kMinimumInteritemSpacing)/2, (self.frame.size.width - 2)/2 * kImageHeight / kImageWidth + kTitleLabelHeight);
    layout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    layout.minimumLineSpacing = kMinimumLineSpacing;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.myCollectionView];
    
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (void)dealloc
{
    [self.myCollectionView release];
    [super dealloc];
}


@end
