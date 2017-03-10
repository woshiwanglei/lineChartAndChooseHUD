//
//  SXClassTestReportChooseView.m
//  课堂测评第三期封装的View
//
//  Created by wanglei on 17/3/7.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "SXClassTestReportChooseView.h"
@interface SXClassTestReportChooseView()
{
    SXReportChooseType _reportChooseType;
    clickChooseButtonBlock _clickChooseButtonBlock;
    NSArray * _gradeArray;
    NSArray * _timeStringArray;
}
@end

@implementation SXClassTestReportChooseView

- (instancetype)initWithFromY:(CGFloat)y withGradeArray:(NSArray *)gradeArray withChooseButtonClickBlock:(clickChooseButtonBlock)clickChooseButtonBlock{
    if ( self = [super init] ) {
        _clickChooseButtonBlock = clickChooseButtonBlock;
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
        [self addGestureRecognizer:tapGR];
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, y, WIDTH, HEIGHT - y)];
        maskView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.2];
        [self addSubview:maskView];
        UIView *chooseView = [UIView new];
        [maskView addSubview:chooseView];
        CGFloat buttonWidth = (WIDTH - 15 * 4) / 3;
        if ( gradeArray && gradeArray.count ) {
            _gradeArray = gradeArray;
            
            chooseView.frame = CGRectMake(0, 0, WIDTH, (15 + 32) * ((gradeArray.count +2) / 3) + 15);
            chooseView.backgroundColor = [UIColor whiteColor];
            for ( int i = 0; i < gradeArray.count; i++ ) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i;
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(15 + (15 + buttonWidth) * (i % 3), 15 + (i / 3) * (15 + 32), buttonWidth, 32);
                button.layer.cornerRadius = 16;
                button.layer.masksToBounds = YES;
                button.layer.borderColor = SXBLUE.CGColor;
                button.layer.borderWidth = 1;
                [button setTitle:((NSDictionary *)gradeArray[i])[@"name"] forState:UIControlStateNormal];
                [button setTitleColor:SXBLUE forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseView addSubview:button];
            }
            _reportChooseType = Grade;
        }
        else{
            chooseView.frame = CGRectMake(0, 0, WIDTH, (15 + 32) + 15);
            chooseView.backgroundColor = [UIColor whiteColor];
            NSArray *timeStringArray = @[@"近一周",@"一个月",@"一学期"].copy;
            _timeStringArray = timeStringArray.copy;
            for ( int i = 0; i < 3; i++ ) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i;
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(15 + (15 + buttonWidth) * i, 15 , buttonWidth, 32);
                button.layer.cornerRadius = 16;
                button.layer.masksToBounds = YES;
                button.layer.borderColor = SXBLUE.CGColor;
                button.layer.borderWidth = 1;
                [button setTitle:timeStringArray[i] forState:UIControlStateNormal];
                [button setTitleColor:SXBLUE forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [chooseView addSubview:button];
            }
            _reportChooseType = Time;
        }
    }
    return self;
}

- (void)clickButton:(UIButton *)button{
    if ( _reportChooseType == Time ) {
        if ( _clickChooseButtonBlock ) {
            NSInteger tag = button.tag;
            _clickChooseButtonBlock(_reportChooseType,_timeStringArray[tag],@(tag));
        }
    }
    else{
        if ( _clickChooseButtonBlock ) {
            NSInteger tag = button.tag;
            _clickChooseButtonBlock(_reportChooseType,((NSDictionary *)_gradeArray[tag])[@"name"],((NSDictionary *)_gradeArray[tag])[@"id"]);
        }
    }
    [self removeFromSuperview];
}

@end
