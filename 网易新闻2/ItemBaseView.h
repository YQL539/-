//
//  ItemBaseView.h
//  网易新闻2
//
//  Created by yangqinglong on 16/2/19.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"

//定义一个block回调当前被点击的栏目的索引
typedef void (^ItemBaseBlock)(NSInteger index,ButtonView *btnView);

@interface ItemBaseView : UIView<ItemnButtonViewDelegate>
//显示的按钮的数据源
@property (nonatomic,strong) NSArray *dataSourceArray;

//记录当前选中的索引值
@property (nonatomic,assign)NSInteger selectedIndex;

//记录是否是上面的那个showingView
@property (nonatomic,assign)BOOL isSelectedView;
//自定义一个init方法
-(instancetype)initWithFrame:(CGRect)frame isSelectedView:(BOOL)status selectedItemIndex:(NSInteger)index buttonClickedBlock:(ItemBaseBlock)block;
//删除一个按钮
-(void)removeButtonView:(ButtonView *)btn;
@end
