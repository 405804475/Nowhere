//
//  PapersCell.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "PapersCell.h"

@implementation PapersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加控件
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    // imageView 分页大图
    self.bigImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,[UIScreen mainScreen].bounds.size.width, kBigImageViewHeight)];
    
    // titleLabel
    self.titleLabel = [Function createLabelWithName:nil andFrame:CGRectMake(self.bigImageView.frame.origin.x, kBigImageViewHeight + kInspace,[UIScreen mainScreen].bounds.size.width, kTitleLabelHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    // 设置title不限制行数
    self.titleLabel.numberOfLines = 0;
    
    // description
    self.descriptionLabel = [Function createLabelWithName:nil andFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width, kDescriptionLabelHeight)];
    self.descriptionLabel.numberOfLines = 0;

    // imageSmallView
    self.imageSmallView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, kBigImageViewHeight - 60, 50, 50)];
    
    
    [self.bigImageView addSubview:self.imageSmallView];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.bigImageView];
    [self.contentView addSubview:self.titleLabel];
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{

    [_imageSmallView release];
    [_bigImageView release];
    [_category release];
    [_descriptionLabel release];
    [_titleLabel release];
    [super dealloc];
}

@end
