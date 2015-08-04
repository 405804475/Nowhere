//
//  Function.m
//  UILesson8_PassValueDemo
//
//  Created by lanouhn on 15/5/26.
//  Copyright (c) 2015年 scx. All rights reserved.
//

#import "Function.h"

@implementation Function


//创建label
+(UILabel *)createLabelWithName:(NSString *)name andFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = name;
    
    return [label autorelease];
}

//创建输入框
+(UITextField *)createTextFieldWithName:(NSString *)name andFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = name;
    return [textField autorelease];
}

//创建Button
+(UIButton *)createButtonWithName:(NSString *)name andFrame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:frame];
    [btn setTitle:name forState:UIControlStateNormal];
    return btn;
}

//创建imageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:@"117.jpg"];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    return [imageView autorelease];
}

// 创建alertView
+(UIAlertView *)creatAletViewWithFrame:(CGRect)frame andTitile:(NSString *)title andMessage:(NSString *)message andCancelButtonTitile:(NSString *)cancelTitle andOtherTitle1:(NSString *)title1
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:title1, nil];
    alertView.frame = frame;
    return [alertView autorelease];
}

#pragma mark - 获得沙盒路径下的缓存文件夹的路径
+ (NSString *)getCachePath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [array objectAtIndex:0];
    
    return path;
}






@end
