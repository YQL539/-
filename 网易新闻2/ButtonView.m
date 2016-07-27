//
//  ButtonView.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/20.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "ButtonView.h"
@interface ButtonView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *deleteButton;
@end
@implementation ButtonView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, frame.size.width - 20, frame.size.height-10)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor= [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Melon" size:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(-4, -4, 16, 16);
        [_deleteButton addTarget:self action:@selector(btnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidClicked)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark -----setter 
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}
#pragma mark-----外部接口方法
-(void)isSelected:(BOOL)selected{
    if (selected == YES) {
        _titleLabel.textColor = [UIColor redColor];
    }else{
        _titleLabel.textColor = [UIColor blackColor];
    }
}

-(void)deleteButtonHidden:(BOOL)status{
    _deleteButton.hidden = status;
}

-(void)canCatchLongPress:(BOOL)isCan{
    if (isCan) {
        //添加长按事件
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(viewIsLongPressed)];
        longPressGesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressGesture];
    }
}
//视图被点击
-(void)viewDidClicked{
    if ([_delegate respondsToSelector:@selector(buttonViewDidClicked:)]) {
        [_delegate buttonViewDidClicked:self];
    }
}


//长按事件发生
-(void)viewIsLongPressed{
    NSLog(@"长按");
}
//删除按钮按下
-(void)btnDidClicked{
    NSLog(@"删除按钮");
}
@end











