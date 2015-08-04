//
//  MTVModel.h
//  YinYueTai
//
//  Created by lanouhn on 15/6/30.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MTVModel : NSObject



// model对应的ID
@property (nonatomic , retain) NSString *id120;
// MTV的title
@property (nonatomic , retain) NSString *title;
// MTV的歌手名
@property (nonatomic , retain) NSString *artistName;
// MTV播放地址
@property (nonatomic , retain) NSString *mtvUrl;
// MTV缩略图
@property (nonatomic , retain) NSString *posterPic;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
