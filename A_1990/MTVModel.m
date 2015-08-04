//
//  MTVModel.m
//  YinYueTai
//
//  Created by lanouhn on 15/6/30.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//

#import "MTVModel.h"

@implementation MTVModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (![dic isKindOfClass:[NSNull class]]) {
            self.id120 = dic[@"id"];
            self.title = dic[@"title"];
            self.artistName = dic[@"artistName"];
            self.mtvUrl = dic[@"url"];
            self.posterPic = dic[@"albumImg"];
        }
    }
    return self;
}

- (void)dealloc
{
    _posterPic = nil;
    _id120 = nil;
    _title = nil;
    _artistName = nil;
    _mtvUrl = nil;
    [super dealloc];
}

@end
