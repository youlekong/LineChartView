//
//  ViewController.m
//  YLLineChart
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 Cisetech. All rights reserved.
//

#import "ViewController.h"
#import "YLLineChartView.h"

#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
@property (nonatomic, strong) YLLineChartView *chartView;
@end

@implementation ViewController

- (YLLineChartView *)chartView
{
    if (!_chartView) {
        CGRect rect = CGRectMake(0, 100, kScreen_Width, viewHeight);
        _chartView = [[YLLineChartView alloc] initWithFrame:rect];
        _chartView.backgroundColor = [UIColor whiteColor];
    }
    return _chartView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.chartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
