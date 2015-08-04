//
//  MTVCell.m
//  YinYueTai
//
//  Created by lanouhn on 15/7/1.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "MTVCell.h"

@implementation MTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
  
    
    // MTV缩略图
    self.mtvImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * kMtvImageViewHeight / kMtcImageViewWidth)];
    
    // MTV名字
    self.titleLabel = [Function createLabelWithName:nil andFrame:CGRectMake(10, self.mtvImageView.frame.size.height - 64, self.frame.size.width / 2, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];

    
    // 歌手名字
    self.artistNameLabel = [Function createLabelWithName:nil andFrame:CGRectMake(10, self.mtvImageView.frame.size.height - 34, self.frame.size.width / 2, 44)];
    self.artistNameLabel.textColor = [UIColor colorWithRed:0.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];

    
    
    
    [self addSubview:self.mtvImageView];
    [self.mtvImageView addSubview:self.titleLabel];
    [self.mtvImageView addSubview:self.artistNameLabel];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [_titleLabel release];
    [_artistNameLabel release];
    [_mtvImageView release];
    [super dealloc];
}
@end
