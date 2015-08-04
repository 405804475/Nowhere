//
//  CategoryModel.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        // 判断字典中是否存在下面的东西
        if (![dic isKindOfClass:[NSNull class]]) {
            self.id90 = dic[@"id"];
            self.title = dic[@"title"];
            self.image_smallURL = dic[@"image_small"];
            self.white_imageURL = dic[@"white_image"];
        }
    }
    return self;
}


- (void)dealloc
{
    _id90 = nil;
    _title = nil;
    _image_smallURL = nil;
    _white_imageURL = nil;
    [super dealloc];
}


@end
