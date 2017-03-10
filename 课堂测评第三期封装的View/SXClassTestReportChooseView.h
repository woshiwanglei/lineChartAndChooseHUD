//
//  SXClassTestReportChooseView.h
//  课堂测评第三期封装的View
//
//  Created by wanglei on 17/3/7.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define SXBLUE [UIColor colorWithRed:38 / 255.0 green:154 / 255.0 blue:229 / 255.0 alpha:1]
typedef NS_ENUM(NSInteger, SXReportChooseType) {
    Time = 0,
    Grade
};
typedef void ( ^ clickChooseButtonBlock ) ( SXReportChooseType reportChooseType , NSString * name , NSNumber * ID );

@interface SXClassTestReportChooseView : UIView

- (instancetype)initWithFromY:(CGFloat)y withGradeArray:(NSArray *)gradeArray withChooseButtonClickBlock:(clickChooseButtonBlock)clickChooseButtonBlock;//选择时间则gradeArray的值nil。

@end
