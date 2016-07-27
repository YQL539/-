//
//  ItemEditing.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/19.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "ItemEditing.h"
#import "ItemBaseView.h"
#import "ButtonView.h"
typedef enum {
    kAddButtonAnimationTypeAppear,
    kAddButtonAnimationTypeDisAppear
}kAddButtonAnimationType;

@interface ItemEditing()
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ItemBaseView *showingItemsView;
@property (nonatomic,strong) ItemBaseView *hiddenItemsView;
@property (nonatomic,copy)ItemChangeBlock block;
@end
@implementation ItemEditing
-(instancetype)initWithFrame:(CGRect)frame itemChangeBlock:(ItemChangeBlock)block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        //设置背景为半透明
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0];
        
        //创建操作视图
        [self initBarTitleView];
        //创建SCROLLView
        [self initScrollView];
    }
    return self;
}
#pragma mark--------setter -------
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (_showingItemsView != nil) {
        _showingItemsView.selectedIndex = _selectedIndex;
    }
}

-(void)setItemsDic:(NSDictionary *)itemsDic{
    _itemsDic = [NSMutableDictionary dictionaryWithDictionary:itemsDic];
    //获取数据
    __block NSMutableArray *showsArray = [NSMutableArray arrayWithArray:[itemsDic objectForKey:@"show"]];
    __block NSMutableArray *hiddenArray = [NSMutableArray arrayWithArray:[_itemsDic objectForKey:@"hidden"]];
    
    //显示相应的模块按钮
    //计算高度
    CGFloat height = ((showsArray.count-1)/4+1)*(30+15)+15;
    self.showingItemsView = [[ItemBaseView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,height) isSelectedView:YES selectedItemIndex:_selectedIndex buttonClickedBlock:^(NSInteger index, ButtonView *btnView) {
        //itemBaseView 将点击的栏目的索引回调过来
        //又传递到上一层
        _selectedIndex = index;
        [self closeButtonDidClicked:nil];
    }];
    _showingItemsView.dataSourceArray = showsArray;
    [_scrollView addSubview:_showingItemsView];
    //添加没有选择的栏目的视图
    //计算高度
    CGFloat hiddenheight = ((showsArray.count - 1)/4+1)*(30+15)+15;
    self.hiddenItemsView = [[ItemBaseView alloc]initWithFrame:CGRectMake(0, height +50, self.frame.size.width,hiddenheight) isSelectedView:NO selectedItemIndex:0 buttonClickedBlock:^(NSInteger index, ButtonView *btnView) {
        //计算showing视图是否需要下拉
        if (showsArray.count%4 ==0) {
            [UIView animateWithDuration:0.3 animations:^{
                _showingItemsView.frame = CGRectMake(0, _showingItemsView.frame.origin.y, _showingItemsView.frame.size.width, _showingItemsView.frame.size.height+30+15);
                _hiddenItemsView.frame = CGRectMake(0, _hiddenItemsView.frame.origin.y+30+15, _hiddenItemsView.frame.size.width, _hiddenItemsView.frame.size.height);
            }];
            
            _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+30+15);
        }
        //计算目的位置
        NSInteger colum = (showsArray.count)%4;
        NSInteger row = showsArray.count /4;
        CGRect desFrame = CGRectMake(8+colum*(70+8), 15+row*(15+30), 70, 30);
        //计算这个按钮相对于showingView的坐标位置
        CGRect sourceFrame = CGRectMake(btnView.frame.origin.x, _showingItemsView.frame.size.height+50+btnView.frame.origin.y, 70, 30);
        
        //创建一个新的按钮
        ButtonView *newButtonView = [[ButtonView alloc]initWithFrame:sourceFrame];
        newButtonView.module = kButtonModuleShowingView;
        newButtonView.title = btnView.title;
        [newButtonView canCatchLongPress:YES];
        [newButtonView deleteButtonHidden:YES];
        newButtonView.delegate = _showingItemsView;
        newButtonView.layer.borderColor =[UIColor lightGrayColor].CGColor;
        newButtonView.layer.borderWidth = 1;
        newButtonView.layer.cornerRadius = 15;
        [_showingItemsView addSubview:newButtonView];
        //删掉旧的按钮
        [_hiddenItemsView removeButtonView:btnView];
        
        //移动的动画
        [UIView animateWithDuration:0.7 animations:^{
            newButtonView.frame = desFrame;
        }];
        //更改数据源
        NSDictionary *dic1 = [hiddenArray objectAtIndex:index];
        [showsArray addObject:dic1];
        [hiddenArray removeObject:dic1];
        
        //获取数据
        NSMutableArray *showsTempArray = [NSMutableArray arrayWithArray:[_itemsDic objectForKey:@"show"]];
        NSMutableArray *hiddenTempArray = [NSMutableArray arrayWithArray:[_itemsDic objectForKey:@"hidden"]];
        NSDictionary *dic2 = [hiddenTempArray objectAtIndex:index];
        [showsTempArray addObject:dic2];
        [hiddenTempArray addObject:dic2];
        [_itemsDic setObject:showsTempArray forKey:@"show"];
        [_itemsDic setObject:hiddenTempArray forKey:@"hidden"];
#warning 需要更改plist
    }];
    _hiddenItemsView.dataSourceArray = hiddenArray;
    [_scrollView addSubview:_hiddenItemsView];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, height +hiddenheight+50);
}
#pragma mark -----initView------------
-(void)initScrollView{
    //创建ScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 0)];
    _scrollView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.95];
    [self addSubview:_scrollView];
    
    //添加下拉动画
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _scrollView.frame = CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-20-44-44);
    } completion:nil];
}


-(void)initBarTitleView{
    //创建两个label
    [self createLabelWithText:@"   切换栏目" frame:CGRectMake(0,0,320,44)];
    //添加加号按钮
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(320-60+14, 3, 32, 32);
    [_addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(closeButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _addButton];
    
    //addButton出现动画
    [self rotateWithtype:kAddButtonAnimationTypeAppear];
}


#pragma mark---createLabel------
-(void)createLabelWithText:(NSString *)title frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
}

#pragma mark---------addButton----------
-(void)closeButtonDidClicked:(UIButton *)sender{
    [self rotateWithtype:kAddButtonAnimationTypeDisAppear];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _scrollView.frame = CGRectMake(0, 44, self.frame.size.width, 0);
    } completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(remove) userInfo:nil repeats:NO];
}

-(void)remove {
    //通知父视图 改变栏目了
    self.block(_selectedIndex,_itemsDic);
    [self removeFromSuperview];
}
-(void)rotateWithtype:(kAddButtonAnimationType)type{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    if (type == kAddButtonAnimationTypeAppear) {
        animation.toValue = @(M_PI_4);
        animation.fromValue = @0;
        
    }
    [_addButton.layer addAnimation:animation forKey:nil];
}
@end







