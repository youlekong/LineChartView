//
//  YLLineChartView.h
//  Fullbcn
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 Cisetech. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat viewHeight;

@interface YLLineChartView : UIView

@property (nonatomic, copy) NSArray *xLabels;
@property (nonatomic, copy) NSArray *yLabels;

@property (nonatomic, assign) CGFloat yValueMin;
@property (nonatomic, assign) CGFloat yValueMax;

@property (nonatomic, copy) NSArray *datasource;


@end
