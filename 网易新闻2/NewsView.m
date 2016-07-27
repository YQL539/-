//
//  NewsView.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/18.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "NewsView.h"
#import "Factory.h"
#import "ItemEditing.h"

#define kNormalSize 15
#define kSelectedSize 18
@interface NewsView()
@property (nonatomic,strong) NSMutableArray *showsArray;
@property (nonatomic,strong) UIScrollView *itemScrollView;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) NSMutableArray *framesArray;
@property (nonatomic,strong) UIButton *lastSelectedButton;
@property (nonatomic,assign) kScrollDirection direction;
@property (nonatomic,assign) double rate;

@end

@implementation NewsView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建栏目的scrollView
        self.itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+20, frame.size.width-60, 40)];
        _itemScrollView.showsHorizontalScrollIndicator = NO;
        _itemScrollView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        _itemScrollView.tag = 2016;
        [self addSubview:_itemScrollView];
        
        //创建栏目具体内容的scrollView
        self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _itemScrollView.frame.origin.y+40, frame.size.width, frame.size.height-20-44-40)];
        _contentScrollView.showsHorizontalScrollIndicator =NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        [self addSubview:_contentScrollView];
        
        //开始加载的时候是没有滚动的
        _direction = kScrollDirectionNormal;
        
        //添加+号按钮
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(frame.size.width - 60+14, 44+20+3, 32, 32);
        [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(editItemScrollView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
    }
    return self;
}
#pragma mark----lazyload------
-(NSMutableArray *)framesArray{
    if (_framesArray == nil) {
        self.framesArray = [NSMutableArray array];
    }
    return _framesArray;
}

#pragma mark --- 重写setter方法
-(void)setDataSourceDic:(NSDictionary *)dataSourceDic{
    _dataSourceDic = dataSourceDic;
    //获取显示的内容
    self.showsArray = [_dataSourceDic objectForKey:@"show"]  ;
}
-(void)setShowsArray:(NSMutableArray *)showsArray{
    _showsArray = showsArray;
    //显示栏目按钮
    [self loadItemScrollView];
    [self loadContentScrollView];
}
-(void)loadContentScrollView{
    for (int i = 0; i<_showsArray.count; i++) {
        //获取i对应的栏目的图片内容
        NSDictionary *dic = [_showsArray objectAtIndex:i];
        NSString *imageName = [[dic allValues] lastObject];
        UIImage *image = [UIImage imageNamed:imageName];
        
        //创建图片视图
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, _contentScrollView.frame.size.height)];
        imageView.image = image;
        [_contentScrollView addSubview:imageView];
    }
    _contentScrollView.contentSize = CGSizeMake(_showsArray.count*320, _contentScrollView.frame.size.height);
}
-(void)loadItemScrollView{
    for (UIButton *btn in _itemScrollView.subviews) {
        [btn removeFromSuperview];
    }
    
    [_framesArray removeAllObjects];
    //显示
    for (int i =0; i<_showsArray.count; i++) {
        //获取栏目对应的字典
        NSDictionary *itemDic = [_showsArray objectAtIndex:i];
        //获取栏目名
        NSString *itemTitle = [itemDic.allKeys lastObject];
        
        //计算这个按钮的坐标位置
        CGRect btnFrame = CGRectMake([Factory xPositionWithFramesArray:_framesArray space:15], 0, 0, 40);
        UIButton *btn = [Factory buttonWithTitle:itemTitle size:(i == 0?kSelectedSize:kNormalSize) frame:btnFrame];
        btn.tag = i;
        [btn addTarget:self action:@selector(changeNews:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemScrollView addSubview:btn];
        
        if (i ==0) {
            [btn setSelected:YES];
            _lastSelectedButton = btn;
        }
        //将当前添加的这个按钮的frame添加到数组里面去
        [self.framesArray addObject:[NSValue valueWithCGRect:btn.frame]];
    }
    //设置contentSize
    _itemScrollView.contentSize = CGSizeMake([Factory xPositionWithFramesArray:_framesArray space:15], 40);
}

-(void)changeNews:(UIButton *)sender{
    //设置按钮的状态为选中状态
    if (sender.tag != _lastSelectedButton.tag) {
        //回复之前的按钮的状态
        [_lastSelectedButton setSelected:NO];
        [_lastSelectedButton.titleLabel setFont:[UIFont systemFontOfSize:kNormalSize]];
        [_lastSelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //记录当前的选中的按钮
        _lastSelectedButton = sender;
        
        //设置选中按钮的状态和大小
        [sender setSelected:YES];
        [sender.titleLabel setFont:[UIFont systemFontOfSize:kSelectedSize]];
        
        //滚动下方的内容
        [_contentScrollView setContentOffset:CGPointMake(sender.tag *320, 0) animated:NO];
    }
    
    if (sender.tag > 2 && sender.tag <_showsArray.count - 2) {
        //需要滚动到中间
        CGFloat x = sender.center.x - self.frame.size.width/2.0;
        [_itemScrollView setContentOffset:CGPointMake(x, 0)animated:YES];
    }
    if (sender.tag <3) {
        [_itemScrollView setContentOffset:CGPointMake(0, 0)animated:YES];
    }
    if (sender.tag >= _showsArray.count - 2) {
        [_itemScrollView setContentOffset:CGPointMake((_itemScrollView.contentSize.width - _itemScrollView.frame.size.width), 0)animated:YES];
    }
    
}
#pragma mark------ScrollViewDelegate -----
//手指拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //记录滚动的方向
    if (scrollView.contentOffset.x > _lastSelectedButton.tag*320) {
        _direction = kScrollDirectionRight;
    }else{
        _direction = kScrollDirectionLeft;
    }
    //通过滚动的比例，计算放大缩小的比例
    double distance = fabs(scrollView.contentOffset.x - _lastSelectedButton.tag *320);
    _rate = distance/320.0;
    //对左右两边的按钮进行调整
    [self itemStatusChangeWhileScrollView];
    
}
//滚动的时候改变按钮的状态
-(void)itemStatusChangeWhileScrollView{
    //判断这个按钮的字体显示的大小，如果是选中的按钮就大字体
    CGFloat fontSize = 0;
    if (_direction == kScrollDirectionLeft) {
        //左边滚动，判断i是否是选中的按钮左边的那个，
        //获取左边的 按钮
        if (_lastSelectedButton.tag > 0) {
            UIButton *leftButton = [_itemScrollView viewWithTag:_lastSelectedButton.tag - 1];
            fontSize = kNormalSize + (kSelectedSize - kNormalSize)*_rate;
            [leftButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            [leftButton setTitleColor:[UIColor colorWithRed:255*_rate/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        }
    } else if (_direction == kScrollDirectionRight){
        if (_lastSelectedButton.tag < _showsArray.count-1) {
            UIButton *rightButton = [_itemScrollView viewWithTag:_lastSelectedButton.tag +1];
            fontSize = kNormalSize + (kSelectedSize - kNormalSize)*_rate;
            [rightButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
            [rightButton setTitleColor:[UIColor colorWithRed:255*_rate/255.0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        }
    }
    [_lastSelectedButton.titleLabel setFont:[UIFont systemFontOfSize:(kSelectedSize - (kSelectedSize - kNormalSize)*_rate )]];
    [_lastSelectedButton setTitleColor:[UIColor colorWithRed:255*(1-_rate)/255.0 green:0 blue:0 alpha:1] forState:UIControlStateSelected];
}
//停止滚动，计算当前页
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算当前是第几页
    int page = scrollView.contentOffset.x / 320;
    
    //判断当前显示的页面是否改变
    if (page != _lastSelectedButton.tag) {
        //获取page对应的按钮对象
        UIButton *sender = [_itemScrollView viewWithTag:page];
        [self changeNews:sender];
    }
}
#pragma mark-------栏目设置-------------
-(void)editItemScrollView{
    ItemEditing *editingView = [[ItemEditing alloc]initWithFrame:CGRectMake(0, 20+44, self.frame.size.width, self.frame.size.height-20-44) itemChangeBlock:^(NSInteger index, NSDictionary *dic) {
        if (_dataSourceDic !=dic) {
            self.dataSourceDic = dic;
            self.showsArray = [dic objectForKey:@"show"];
        }
        [self changeNews:[_itemScrollView viewWithTag:index]];
    }];
    //数据源
    editingView.itemsDic = [NSMutableDictionary dictionaryWithDictionary:self.dataSourceDic];
    //当前选中的栏目的索引
    editingView.selectedIndex = _lastSelectedButton.tag;
    [self addSubview:editingView];
}
@end




























