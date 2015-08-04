//
//  CategoryModel.h
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.

// Categfory 分类model的属性

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic , retain) NSString *id90; //分类的ID

@property (nonatomic , retain) NSString *title; // 分类名称

@property (nonatomic , retain) NSString *image_smallURL; // 分类展示LOGO

@property (nonatomic , retain) NSString *white_imageURL; 


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
