//
//  ItemBaseView.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/19.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "ItemBaseView.h"

@interface ItemBaseView ()
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@property (nonatomic,copy)ItemBaseBlock block;

@end

@implementation ItemBaseView
-(instancetype)initWithFrame:(CGRect)frame isSelectedView:(BOOL)status selectedItemIndex:(NSInteger)index buttonClickedBlock:(ItemBaseBlock)block {
    if (self = [super initWithFrame:frame]) {
        _isSelectedView = status;
        _isSelectedView = index;
        self.block = block;
        self.buttonsArray = [NSMutableArray array];
    }
    return self;
}
#pragma mark-----setter
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (_buttonsArray.count != 0) {
        ButtonView *btnView = [_buttonsArray objectAtIndex:_selectedIndex];
        [btnView isSelected:YES];
    }
}
-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    for (int i= 0; i<_dataSourceArray.count; i++) {
        //获取按钮显示的标题
        NSDictionary *dic = [_dataSourceArray objectAtIndex:i];
        NSString *title = [[dic allKeys]lastObject];
        //计算按钮的行列数
        int colum =  i % 4;
        int row = i / 4;
        CGFloat x = 8 +(70 +8 )*colum;
        CGFloat y = 15 +(30+15)*row;
        //创建按钮
        ButtonView *btnView = [[ButtonView alloc]initWithFrame:CGRectMake(x,y, 70, 30)];
        btnView.delegate = self;
        
        btnView.title = title;
        [btnView deleteButtonHidden:YES];
        [btnView canCatchLongPress:YES];
        [self addSubview:btnView];
        //判断按钮是不是showingView上的第一个按钮
        if ((_isSelectedView ==YES&&i!=0)||_isSelectedView ==NO) {
            btnView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btnView.layer.cornerRadius = 15;
            btnView.layer.borderWidth = 1;
        }
        //设置按钮属于哪个模块
        if (_isSelectedView == YES) {
            btnView.module = kButtonModuleShowingView;
        }else{
            btnView.module = kButtonModuleHiddingView;
        }
        [self addSubview:btnView];
        
        //将这个按钮添加到数组里面去
        [self.buttonsArray addObject:btnView];
    }
}
#pragma mark------ButtonViewDelegate-----
-(void)buttonViewDidClicked:(ButtonView *)sender{
    //NSLog(@"%ld",[_buttonsArray indexOfObject:sender]);
    self.block([_buttonsArray indexOfObject:sender],sender);
}
#pragma mark-----Method
-(void)removeButtonView:(ButtonView *)btn{
    [_buttonsArray removeObject:btn];
    [btn removeFromSuperview];
}
@end












