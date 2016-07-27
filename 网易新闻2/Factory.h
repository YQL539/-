//
//  Factory.h
//  网易新闻2
//
//  Created by yangqinglong on 16/2/18.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Factory : NSObject
//计算文本的宽高
+(CGSize)sizeWithText:(NSString *)text size:(CGFloat)size;
//传递文本 创建一个适应大小的button
+(UIButton *)buttonWithTitle:(NSString *)title size:(CGFloat)size frame:(CGRect)frame;

//获取x坐标
+(CGFloat)xPositionWithFramesArray:(NSArray *)framesArray space:(CGFloat)space;
@end
