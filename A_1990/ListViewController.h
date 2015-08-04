//
//  ShowViewController.h
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"
@interface ListViewController : UIViewController<UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , retain) ListView *listView;
@property (nonatomic , retain) NSMutableArray *listModelArray;
//@property (nonatomic , retain) NSMutableArray *bigImageViewArray;
@property (nonatomic , assign) long listID;

@end
