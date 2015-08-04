//
//  HistoryCell.m
//  YinYueTai
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

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

    
    // titleLabel
    self.titleLabel = [Function createLabelWithName:nil andFrame:CGRectMake(165, 15 ,[UIScreen mainScreen].bounds.size.width - 20 - 150, 60)];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    // 设置title不限制行数
    self.titleLabel.numberOfLines = 0;
    

    
    
    self.historyImage = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 25, 150, 150*kImageHeight/kImageWidth + 10)];
    
    // singerLabel
    self.singerLabel = [Function createLabelWithName:nil andFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 20, self.titleLabel.frame.size.width, self.frame.size.height - self.titleLabel.frame.size.height - self.titleLabel.frame.origin.y)];
    self.singerLabel.numberOfLines = 0;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.historyImage];
    [self.contentView addSubview:self.singerLabel];
    
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
    [_singerLabel release];
    [_titleLabel release];
    [_historyImage release];
    [super dealloc];
}




@end
