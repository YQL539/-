//
//  MainViewController.m
//  网易新闻2
//
//  Created by yangqinglong on 16/2/18.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "MainViewController.h"
#import "NewsView.h"


@interface MainViewController ()
@property (nonatomic,strong) NSDictionary *dataSourceDic;
@property (nonatomic,strong) NewsView *nView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网易";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置不自动适应滚动视图的偏移值
    self.automaticallyAdjustsScrollViewInsets = NO;
    //读取数据
    [self loadData];
    self.nView = [[NewsView alloc]initWithFrame:self.view.bounds];
    _nView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_nView];
    //传递数据源
    
    _nView.dataSourceDic = self.dataSourceDic;
}

//从plist文件中读取数据
-(void)loadData{
    //获取文件的路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"newsPlist" ofType:@"plist"];
    
    //读取内容
    self.dataSourceDic = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
