//
//  ViewController.m
//  ScrollViewCycle
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *control;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSTimer *timer;//计时器 用来实现自动轮播

@end

@implementation ViewController

#pragma mark -懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, Screen_Width, 200)];
        _scrollView.backgroundColor = [UIColor purpleColor];
        _scrollView.pagingEnabled = YES;//分页
        _scrollView.delegate = self;//代理
        _scrollView.showsHorizontalScrollIndicator = NO;//滚动条
        _scrollView.bounces = NO;//弹簧效果
    }
    return _scrollView;
}

- (UIPageControl *)control
{
    if (!_control) {
        _control = [[UIPageControl alloc] initWithFrame:CGRectMake((Screen_Width - 100)/2.0, 180 + 100 - 10, 100, 20)];
        _control.pageIndicatorTintColor = [UIColor redColor];
        _control.currentPageIndicatorTintColor = [UIColor greenColor];
        _control.numberOfPages = 5;
//        [_control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self createUI];
    
}

#pragma mark -createUI
- (void)createUI
{
    [self.view addSubview:self.scrollView];
    
    CGFloat height = 200;
    CGFloat y = 0;
    
    NSInteger count = 5;
    
    for (int i = 0; i < count; i ++) {
        NSString *name = [NSString stringWithFormat:@"img%d", i];
        UIImage *img = [UIImage imageNamed:name];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = img;
        
        imgView.frame = CGRectMake(i * Screen_Width, y, Screen_Width, height);
        
        [self.scrollView addSubview:imgView];
    }
    
    self.scrollView.contentSize = CGSizeMake(Screen_Width * count, 0);
    
    [self.view addSubview:self.control];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    //把self.timer 加入消息循环的模式修改一下
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //拖拽它的时候 计时器会停止 消息模式问题
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 350, Screen_Width/2.0, 50)];
    textView.backgroundColor = [UIColor cyanColor];
    textView.text = @"发圣诞节放假啊塑料加工卢卡斯奖励卡收购价爱睡懒觉阿萨德刚加上噶计算机的高发噶啥可了解噶十几个管卡圣诞节放假啊塑料加工卢卡斯奖励卡收购价爱睡懒觉阿萨德刚加上噶计算机的高发噶啥可了解噶十几个管卡是那个静是那个静安寺";
    [self.view addSubview:textView];
}

//自动轮播
- (void)autoScroll
{
    NSLog(@"...");
    //修改scrollView的contentOffset的x的值
    
    //获取当前页索引
    NSInteger page = self.control.currentPage;
    page ++;
    
    //检测索引是否超过了总页数
    if (page > self.control.numberOfPages - 1) {
        page = 0;
    }
    
    //设置scrollView的contentOffset的x的值
    [self.scrollView setContentOffset:CGPointMake(Screen_Width * page, 0) animated:YES];
}

#pragma mark -UIPageControl
- (void)controlAction
{
    self.index ++;
    
    self.control.currentPage = self.index;
    
    if (self.index > self.control.numberOfPages - 1) {
        self.index = 0;
    }
    
    self.control.currentPage = self.index;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算当前滚动到第几页 已经滚动一半时 UIPageControl更换
    //偏移量 加上scrollView的frame宽度的一半
    self.control.currentPage = (scrollView.contentOffset.x + Screen_Width/2.0)/Screen_Width;
}

//开始拖拽 停止计时器  手动拖动的时候 防止计时器一直在运行 导致松手后 pageControll快速跳过
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

//开始计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //重新开启计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    //消息循环 模式修改
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
