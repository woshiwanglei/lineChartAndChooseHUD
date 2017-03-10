//
//  ViewController.m
//  课堂测评第三期封装的View
//
//  Created by wanglei on 17/3/7.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "SXClassTestReportChooseView.h"
#import "SXLineChart.h"

@interface ViewController ()
{
    NSDictionary *rootDic;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil];
    rootDic = [NSDictionary dictionaryWithContentsOfFile:filepath];
//    [self showChooseView];
    [self showChartView];
}

- (void)showChooseView{
    NSArray *gradeArray = ((NSArray *)rootDic[ @"gradeArray" ]).copy;
    UIView *classTestReportChooseView = [[SXClassTestReportChooseView alloc] initWithFromY:100 withGradeArray:gradeArray withChooseButtonClickBlock:^(SXReportChooseType reportChooseType, NSString *name, NSNumber *ID) {
        if ( reportChooseType == Time ) {
            NSLog(@"选取的时间为%@,id=%@",name,ID);
        }
        else{
            NSLog(@"选取的年级为%@,id=%@",name,ID);
        }
    }];
    [self.view addSubview:classTestReportChooseView];
}

- (void)showChartView{
    NSArray *chartDataArray = ((NSArray *)rootDic[ @"rows" ]).copy;
    SXLineChart *lineChart = [[SXLineChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400) andChartArray:chartDataArray andIsShowNumLabel:YES andColorArray:nil andIsPercentage:YES];
    [self.view addSubview:lineChart];
}


@end
