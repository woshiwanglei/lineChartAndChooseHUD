//
//  SXLineChart.h
//  课堂测评第三期封装的View
//
//  Created by wanglei on 17/3/9.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SXBLUE [UIColor colorWithRed:38 / 255.0 green:154 / 255.0 blue:229 / 255.0 alpha:1]
#define Color_With_Rgb(r,g,b,a)   ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define SXRED [UIColor colorWithRed:242 / 255.0 green:156 / 255.0 blue:161 / 255.0 alpha:1]
@interface SXLineChart : UIView

-(instancetype)initWithFrame:(CGRect)frame andChartArray:(NSArray *)chartArray andIsShowNumLabel:(BOOL)showNumLabel andColorArray:(NSArray *)colors andIsPercentage:(BOOL)isPercentage;

@end
