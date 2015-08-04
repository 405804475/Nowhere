//
//  NetworkEngine.m
//  UI_0618QiuBaiDemo
//
//  Created by lanouhn on 15/6/18.
//  Copyright (c) 2015年 石晨欣. All rights reserved.
//

#import "NetworkEngine.h"

@interface NetworkEngine ()

@property (nonatomic , assign) id<NetworkEngineDelegate>delegate;
//参数
@property (nonatomic , retain) NSDictionary *params;
//请求地址
@property (nonatomic , retain) NSURL *url;
//请求方式
@property (nonatomic , retain) NSString *HTTPMethod;
//由参数拼接成的字符串
@property (nonatomic , retain) NSString *stringFromParams;


@end

@implementation NetworkEngine

+(id)networkEngineWithURL:(NSURL *)url params:(NSDictionary *)params delegate:(id<NetworkEngineDelegate>)delegate
{
    NetworkEngine *engine = [[NetworkEngine alloc]init];
    engine.delegate = delegate;
    engine.url = url;
    engine.params = params;
    engine.HTTPMethod = @"GET";
    return [engine autorelease];
}

//设置请求方式
-(void)setHTTPType:(NSString *)method
{
    if (!method) {
        return;
    }
    //保存请求方式
    self.HTTPMethod = method;
}

#pragma mark - 把参数列表转变成字符串
-(NSString *)returnStringFromParams:(NSDictionary *)params
{
    //准备一个可变数组
    NSMutableArray *array = [NSMutableArray array];
    //循环遍历 (范围写错 ， params[key]写错)
    for (NSString *key in params) {
        NSString *currentStr = [NSString stringWithFormat:@"%@=%@" , key , params[key]];
        [array addObject:currentStr];
    }
    //按照特定的字符，把这些字符串从数组里拼接出来
    NSString *resultStr = [array componentsJoinedByString:@"&"];
    
    return resultStr;
    
}

#pragma mark - 设定参数列表（params属性的setter方法）
-(void)setParams:(NSDictionary *)params
{
    if (!params) {
        return;
    }
    //如果参数字典存在，直接调用私有方法，将该参数转变成参数列表字符串
    self.stringFromParams = [self returnStringFromParams:params];
}

#pragma mark - 启动网络的方法
-(void)startWithDic:(NSDictionary *)dic
{
    if ([self.HTTPMethod isEqualToString:@"GET"] && self.stringFromParams) {
        NSString *getUrlStr = [self.url.absoluteString stringByAppendingFormat:@"?%@" , self.stringFromParams];
        
        self.url = [NSURL URLWithString:getUrlStr];
    }
    //创建可变的请求对象 （cachePolicy参数写错）
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    request.allHTTPHeaderFields = dic;
    
    //设置请求方式
    request.HTTPMethod = self.HTTPMethod;
    if ([self.HTTPMethod isEqualToString:@"POST"]) {
        //使用POST请求，需要给可变的请求体属性赋值参数字符串
        request.HTTPBody = [self.stringFromParams dataUsingEncoding:NSUTF8StringEncoding];
    }
    //使用异步方式来连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(_delegate && [_delegate respondsToSelector:@selector(networkDidFinishLoading:withInfo:)]){
            [_delegate networkDidFinishLoading:self withInfo:data];
        }
    }];
    
    
}


-(void)dealloc
{
    _stringFromParams = nil;
    _HTTPMethod = nil;
    [_url release];
    _params = nil;
    _delegate = nil;
    [super dealloc];
}

@end
