//
//  Factory.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/18.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "Factory.h"

@implementation Factory
+(CGSize)sizeWithText:(NSString *)text size:(CGFloat)size{
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGSize bigSize = CGSizeMake(2000, 40);
    CGSize realSize = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil].size;
    return realSize ;
}
+(UIButton *)buttonWithTitle:(NSString *)title size:(CGFloat)size frame:(CGRect)frame {
    CGSize realSize = [Factory sizeWithText:title size:size];
    //创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(frame.origin.x, frame.origin.y, realSize.width+2*15, frame.size.height)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [btn setBackgroundColor:[UIColor clearColor]];
     return btn;
}
+(CGFloat)xPositionWithFramesArray:(NSArray *)framesArray space:(CGFloat)space{
    CGFloat x = 0;
    for (int i = 0; i<framesArray.count; i++) {
        //NSValue 转化为CGRect
        CGRect frame = [[framesArray objectAtIndex:i]CGRectValue];
        //i对应的按钮的宽度
        x += frame.size.width;
    }
    return x;
    
}
@end




















