//
//  LeftSideView.h
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSideView : UIScrollView

@property (nonatomic , retain) BTSpiderPlotterView *spiderView;

@property (nonatomic , retain) UIImageView *backgroundImageView;
@property (nonatomic , retain) UIButton *centerButton;
@property (nonatomic , retain) UIButton *loginBtn;

@property (nonatomic , retain) UIButton *firstPageButton;
@property (nonatomic , retain) UIButton *collectButton;
@property (nonatomic , retain) UIButton *commerceButton;
@property (nonatomic , retain) UIButton *intelligentButton;
@property (nonatomic , retain) UIButton *desginButton;
@property (nonatomic , retain) UIButton *fashionButton;
@property (nonatomic , retain) UIButton *entertainButton;
@property (nonatomic , retain) UIButton *cityButton;
@property (nonatomic , retain) UIButton *gameButton;
@property (nonatomic , retain) UIButton *mvButton;

@property (nonatomic , retain) UIButton *setButton;
@property (nonatomic , retain) UIButton *searchButton;

@property (nonatomic , retain) EGOImageView *headImageView;

@end
