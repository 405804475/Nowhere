//
//  SearchView.m
//  A_1990
//
//  Created by lanouhn on 15/7/4.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width, 50)];
        self.searchBar.placeholder = @"请输入关键字";
        [self addSubview:self.searchBar];
    }
    return _searchBar;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y + self.searchBar.frame.size.height, self.searchBar.frame.size.width, self.frame.size.height - self.searchBar.frame.size.height)];
        
        [self addSubview:self.tableView];
    }
    return _tableView;
}

//- (UILabel *)countLabel
//{
//    if (!_countLabel) {
//        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y + self.searchBar.frame.size.height, self.searchBar.frame.size.width, 30)];
//        self.countLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:self.countLabel];
//        
//    }
//    return _countLabel;
//}


- (void)dealloc
{
    [self.countLabel release];
    [self.tableView release];
    [self.searchBar release];
    [super dealloc];
}


@end
