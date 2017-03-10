//
//  SXLineChart.m
//  课堂测评第三期封装的View
//
//  Created by wanglei on 17/3/9.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "SXLineChart.h"
@interface SXLineChart()
{
    NSArray * _chartArray;
    BOOL _showNumLabel;
    NSArray * _colors;
    BOOL _isPercentage;
    
    CGFloat _width;
    CGFloat _height;
    
    NSMutableArray * _leftLabelsArray;
    NSMutableArray * _linesArray;
    
    NSNumber * _maxNum;
    CGFloat _horizontalLineWidth;
    CGFloat _verticalLineHeight;
    CGFloat _bottomLabelCenterX;
    CGFloat _lineWidth;
    
    NSMutableArray * _pointsCenterArrayArray;
}
@end

@implementation SXLineChart

-(instancetype)initWithFrame:(CGRect)frame andChartArray:(NSArray *)chartArray andIsShowNumLabel:(BOOL)showNumLabel andColorArray:(NSArray *)colors andIsPercentage:(BOOL)isPercentage{
    if ( self = [super init] ) {
        self.frame = frame;
        _width = frame.size.width;
        _height = frame.size.height;
        _chartArray = chartArray;
        _showNumLabel = showNumLabel;
        _colors = colors;
        _isPercentage = isPercentage;
        [self addBackGroundView];
        if ( _chartArray.count == 0 ) {
            return self;
        }
        [self defineLineArray];//重新定义折现的数据模型（id，name，[点值Array])
        [self caculateMaxNumAndDefineLeftLabelText];
        [self addPoint];
        [self addLabel];
        [self strokeLine];
    }
    return self;
}

- (void)addBackGroundView{
    self.backgroundColor = [UIColor whiteColor];
    
    //add top and bottom line
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 1)];
    topLine.backgroundColor = Color_With_Rgb(170,170,170,1);
    [self addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _height - 1, _width, 1)];
    bottomLine.backgroundColor = Color_With_Rgb(170,170,170,1);
    [self addSubview:bottomLine];
    
    //add left label and  horizontal line
    CGFloat lineHeight = (_height - 27 - 43) / 10;
    _leftLabelsArray = @[].mutableCopy;
    _horizontalLineWidth = _width - 30 - 8;
    for ( int i = 0; i < 11; i++ ) {
        CGFloat leftLabelCenterY = 27 + i * lineHeight;
        UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(30, leftLabelCenterY, _horizontalLineWidth, 1)];
        horizontalLine.backgroundColor = Color_With_Rgb(170,170,170,1);
        [self addSubview:horizontalLine];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftLabelCenterY - 15, 35, 30)];
        [_leftLabelsArray addObject:leftLabel];
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.textColor = Color_With_Rgb(170,170,170,1);
        [self addSubview:leftLabel];
    }
    
    //add bottom label and  vertical line
    _verticalLineHeight = (_height - 27 - 43);
    if ( _chartArray.count == 1 ) {
        _bottomLabelCenterX = _width - 8 - _horizontalLineWidth / 2;
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_bottomLabelCenterX, 27 + 1, 1, _verticalLineHeight)];
        verticalLine.backgroundColor = Color_With_Rgb(170,170,170,1);
        [self addSubview:verticalLine];
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        bottomLabel.center = CGPointMake(_bottomLabelCenterX - 0.5, _height - 17.5);
        bottomLabel.text = ((NSDictionary *)(_chartArray[0]))[@"name"];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.textColor = Color_With_Rgb(170,170,170,1);
        [self addSubview:bottomLabel];
    }
    else{
        _lineWidth = (_width - 103) / (_chartArray.count - 1);
        for ( int i = 0 ; i < _chartArray.count ; i++ ) {
            CGFloat bottomLabelCenterX = 65 + _lineWidth * i;
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(bottomLabelCenterX - 0.5, 27 + 1, 1, _verticalLineHeight)];
            verticalLine.backgroundColor = Color_With_Rgb(170,170,170,1);
            [self addSubview:verticalLine];
            
            UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
            bottomLabel.center = CGPointMake(bottomLabelCenterX, _height - 17.5);
            bottomLabel.text = ((NSDictionary *)(_chartArray[i]))[@"name"];
            bottomLabel.font = [UIFont systemFontOfSize:13];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            bottomLabel.textColor = Color_With_Rgb(170,170,170,1);
            [self addSubview:bottomLabel];
        }
    }
}

- (void)defineLineArray{
    _linesArray = @[].mutableCopy;
    NSMutableArray *allPointArray = @[].mutableCopy;
    for (NSDictionary *dic in _chartArray) {
        NSArray *rows = dic[@"rows"];
        [allPointArray addObjectsFromArray:rows];
    }
    for ( int i = 0 ; i < ((NSArray *)((NSDictionary *)_chartArray[0])[@"rows"]).count; i++ ) {
        NSDictionary * bodyMessage = ((NSArray *)((NSDictionary *)_chartArray[0])[@"rows"])[i];
        NSMutableDictionary * lineDic = bodyMessage.mutableCopy;//每条线的信息
        [lineDic removeObjectForKey:@"rank"];
        NSMutableArray *linePointsArray = @[].mutableCopy;//每条线的每个点的集合
        for (NSDictionary *dic in allPointArray) {
            if ( [lineDic[@"id"] integerValue] == [dic[@"id"] integerValue] ) {
                [linePointsArray addObject:dic[@"rank"]];
            }
        }
        [lineDic setObject:linePointsArray forKey:@"linePointsArray"];
        [_linesArray addObject:lineDic];
    }
}

- (void)caculateMaxNumAndDefineLeftLabelText{
    NSMutableArray * allPointsNum = @[].mutableCopy;
    for ( NSDictionary *lineDic in _linesArray ) {
        [allPointsNum addObjectsFromArray:lineDic[@"linePointsArray"]];
    }
    NSNumber * maxInAllNum = [allPointsNum valueForKeyPath:@"@max.floatValue"];
    int minNum = @((([maxInAllNum integerValue] / 10) + 1)).intValue;
    _maxNum = @(minNum * 10).copy;
    
    for (int i = 0; i < _leftLabelsArray.count; i++ ) {
        UILabel *leftLabel = _leftLabelsArray[i];
        if ( _isPercentage ) {
            leftLabel.text = [NSString stringWithFormat:@"%@%%",@( (10 - i) * 10)];
        }
        else{
            leftLabel.text = @(minNum * i).stringValue;
        }
    }
}

- (void)addPoint{
    if ( !_colors ) {
        _colors = @[SXBLUE,SXRED,Color_With_Rgb(134,165,23,1)];
    }
    if ( _chartArray.count == 1 ) {
        if ( _isPercentage ) {
            for (int i = 0; i < _linesArray.count; i++ ) {
                UIColor *currentLineColor = _colors[i];
                CGFloat centerX = _bottomLabelCenterX;
                NSArray *linePointsArray = ((NSDictionary *)(_linesArray[i]))[@"linePointsArray"];
                CGFloat centerY = ( 1 - ([linePointsArray[0] floatValue] / 100.0) * _verticalLineHeight ) + 27.0;
                UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                pointView.center = CGPointMake(centerX, centerY);
                pointView.layer.cornerRadius = 5;
                pointView.backgroundColor = currentLineColor;
                [self addSubview:pointView];
            }
        }
        else{
            for (int i = 0; i < _linesArray.count; i++ ) {
                UIColor *currentLineColor = _colors[i];
                CGFloat centerX = _bottomLabelCenterX;
                NSArray *linePointsArray = ((NSDictionary *)(_linesArray[i]))[@"linePointsArray"];
                CGFloat centerY = ([linePointsArray[0] floatValue] / _maxNum.floatValue) * _verticalLineHeight + 27.0;
                UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                pointView.center = CGPointMake(centerX, centerY);
                pointView.layer.cornerRadius = 5;
                pointView.backgroundColor = currentLineColor;
                [self addSubview:pointView];
            }
        }
    }
    else{
        _pointsCenterArrayArray = @[].mutableCopy;
        if ( _isPercentage ) {
            for (int i = 0 ; i < _linesArray.count; i++ ) {
                UIColor *currentLineColor = _colors[i];
                NSArray *linePointsArray = ((NSDictionary *)(_linesArray[i]))[@"linePointsArray"];
                NSMutableArray * pointsCenterArray = @[].mutableCopy;
                for (int j = 0;  j < linePointsArray.count ; j++ ) {
                    CGFloat centerX = 65 + _lineWidth * j;
                    CGFloat centerY = (1 - ([linePointsArray[j] floatValue] / 100.0)) * _verticalLineHeight + 27.0;
                    UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                    pointView.center = CGPointMake(centerX, centerY);
                    pointView.layer.cornerRadius = 5;
                    pointView.backgroundColor = currentLineColor;
                    [self addSubview:pointView];
                    
                    NSValue *centerValue = [NSValue valueWithCGPoint:pointView.center];
                    [pointsCenterArray addObject:centerValue];
                }
                [_pointsCenterArrayArray addObject:pointsCenterArray];
            }
        }
        else{
            for (int i = 0 ; i < _linesArray.count; i++ ) {
                UIColor *currentLineColor = _colors[i];
                NSArray *linePointsArray = ((NSDictionary *)(_linesArray[i]))[@"linePointsArray"];
                NSMutableArray * pointsCenterArray = @[].mutableCopy;
                for (int j = 0;  j < linePointsArray.count ; j++ ) {
                    CGFloat centerX = 65 + _lineWidth * j;
                    CGFloat centerY = ([linePointsArray[j] floatValue] / _maxNum.floatValue) * _verticalLineHeight + 27.0;
                    UIView * pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                    pointView.center = CGPointMake(centerX, centerY);
                    pointView.layer.cornerRadius = 5;
                    pointView.backgroundColor = currentLineColor;
                    [self addSubview:pointView];
                    
                    NSValue *centerValue = [NSValue valueWithCGPoint:pointView.center];
                    [pointsCenterArray addObject:centerValue];
                }
                [_pointsCenterArrayArray addObject:pointsCenterArray];
            }
        }
    }
}

- (void)strokeLine{
    if ( _chartArray.count != 1 ) {
        for ( int i = 0; i < _pointsCenterArrayArray.count; i++ ) {
            NSArray * pointsCenterArray = _pointsCenterArrayArray[i];
            //划线
            CAShapeLayer *_chartLine = [CAShapeLayer layer];
            _chartLine.lineCap = kCALineCapRound;
            _chartLine.lineJoin = kCALineJoinBevel;
            _chartLine.fillColor   = [[UIColor clearColor] CGColor];
            _chartLine.lineWidth   = 2.5;
            _chartLine.strokeEnd   = 0.0;
            [self.layer addSublayer:_chartLine];
            
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            CGPoint firstPointCenter = [[pointsCenterArray objectAtIndex:0] CGPointValue];
            [progressline moveToPoint:firstPointCenter];
            [progressline setLineWidth:2.0];
            [progressline setLineCapStyle:kCGLineCapRound];
            [progressline setLineJoinStyle:kCGLineJoinRound];
            for (int j = 1; j < pointsCenterArray.count; j++ ) {
                [progressline addLineToPoint:[[pointsCenterArray objectAtIndex:j] CGPointValue]];
            }
            
            _chartLine.path = progressline.CGPath;
            _chartLine.strokeColor = ((UIColor *)_colors[i]).CGColor;
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = pointsCenterArray.count*0.4;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnimation.autoreverses = NO;
            [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _chartLine.strokeEnd = 1.0;
        }
    }
}

- (void)addLabel{
    if ( _showNumLabel ) {
        NSMutableArray *linePointsNumsArray = @[].mutableCopy;
        for (NSDictionary *dic in _linesArray) {
            NSArray *linePointsArray = dic[@"linePointsArray"];
            [linePointsNumsArray addObjectsFromArray:linePointsArray];
        }
        for (int i = 0; i < _pointsCenterArrayArray.count; i++ ) {
            NSArray *array = _pointsCenterArrayArray[i];
            UIColor *textColor = _colors[i];
            for (int j = 0; j < array.count; j++ ) {
                NSValue *value = array[j];
                CGPoint point = value.CGPointValue;
                point.y -= 13;
                UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
                topLabel.textAlignment = NSTextAlignmentCenter;
                topLabel.textColor = textColor;
                topLabel.center = point;
                topLabel.font = [UIFont systemFontOfSize:13];
                if ( _isPercentage ) {
                    topLabel.text = [NSString stringWithFormat:@"%.2f%%",[(linePointsNumsArray[_chartArray.count * i + j]) floatValue]];
                }
                else{
                    topLabel.text = [(linePointsNumsArray[_chartArray.count * i + j]) stringValue];
                }
                [self addSubview:topLabel];
            }
        }
    }
}

@end
