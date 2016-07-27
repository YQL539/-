//
//  ItemEditing.h
//  网易新闻2
//
//  Created by yangqinglong on 16/2/19.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>

//将被点击的按钮的索引值传递到上一层
typedef void(^ItemChangeBlock)(NSInteger index,NSDictionary *dic);

@interface ItemEditing : UIView
@property (nonatomic,strong) NSMutableDictionary *itemsDic;
@property (nonatomic,assign) NSInteger selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame itemChangeBlock:(ItemChangeBlock)block;
@end
