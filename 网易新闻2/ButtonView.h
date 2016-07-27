//
//  ButtonView.h
//  网易新闻2
//
//  Created by yangqinglong on 16/2/20.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>

//前向声明
@class ButtonView;
@protocol ItemnButtonViewDelegate <NSObject>
//点击事件发生
-(void)buttonViewDidClicked:(ButtonView *)sender;
//长按事件发生
-(void)buttonViewDidLongPressed:(ButtonView *)sender;
//删除按钮
-(void)deleteButtonDidClicked:(ButtonView *)sender;
@end

@interface ButtonView : UIView
//标题
@property (nonatomic,strong) NSString *title;
//记录按钮是哪个模块
@property (nonatomic,assign) kButtonModule module;
//回调点击和长按事件
@property (nonatomic,assign)id<ItemnButtonViewDelegate>delegate;

//是否显示delete标签
-(void)deleteButtonHidden:(BOOL)status;
//是否接收长按事件
-(void)canCatchLongPress:(BOOL)isCan;
//是否是选中状态
-(void)isSelected:(BOOL)selected;
@end
