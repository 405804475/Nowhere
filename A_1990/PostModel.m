//
//  PostModel.m
//  A_1990
//
//  Created by lanouhn on 15/6/25.
//  Copyright (c) 2015年 1990. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        //判断字典是否存在
        if (![dic isKindOfClass:[NSNull class]]) {
            
            self.id90 = dic[@"id"];
            self.title = dic[@"title"];
            self.description90 = dic[@"description"];
            self.publish_time = dic[@"publish_time"];
            if (![dic[@"comment_count"] isKindOfClass:[NSNull class]]) {
                self.comment_count = dic[@"comment_count"];
            }
            if (![dic[@"praise_count"] isKindOfClass:[NSNull class]]) {
                self.praise_count  = dic[@"praise_count"];
            }
            self.appview = dic[@"appview"];
            
            self.category = [[CategoryModel alloc]initWithDictionary:dic[@"category"]];
        }
    }
    return self;
}


-(void)dealloc
{
    _id90 = nil;
    _title = nil;
    _description90 = nil;
    _publish_time = nil;
    _comment_count = nil;
    _praise_count = nil;
    _appview = nil;
    [_category release];
    [super dealloc];
}

@end
