//
//  Helper.m
//  MyVideos
//
//  Created by lanouhn on 15-4-10.
//  Copyright (c) 2015年 LIUTAO. All rights reserved.
//

#import "Helper.h"
#import "AFNetworking.h"
@implementation Helper
+ (Helper *)shareHelp {
    static Helper *helper = nil;
    if (helper == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[Helper alloc] init];
        });
    }
    return helper;
}
@end
