//
//  NetworkEngine.h
//  UI_0618QiuBaiDemo
//
//  Created by lanouhn on 15/6/18.
//  Copyright (c) 2015年 石晨欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkEngine;

@protocol NetworkEngineDelegate <NSObject>

@optional
//请求成功时的代理协议
-(void)networkDidFinishLoading:(NetworkEngine *)engine withInfo:(NSData *)data;

//开始请求时的代理协议
-(void)networkDidStartLoading:(NetworkEngine *)engine;

@end

@interface NetworkEngine : NSObject



//外界初始化网络请求的方法
+(id)networkEngineWithURL:(NSURL *)url params:(NSDictionary *)params delegate:(id<NetworkEngineDelegate>)delegate;
//设置请求方式
-(void)setHTTPType:(NSString *)method;
//启动网络请求
-(void)startWithDic:(NSDictionary *)dic;



@end
