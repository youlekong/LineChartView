//
//  YLLineChartView.m
//  Fullbcn
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 Cisetech. All rights reserved.
//

#import "YLLineChartView.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

const CGFloat viewHeight = 135.f;

static const CGFloat kLabelW = 30.f;
static const CGFloat kLabelH = 10.f;
static const CGFloat kLineW = 1.f;

@interface YLLineChartView ()
{
    CAGradientLayer *gradient;
}
@property (nonatomic, assign) CGFloat xLabelWidth;
@end

@implementation YLLineChartView

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (NSArray *)datasource
{
    if (!_datasource) {
        _datasource = @[@"22",@"44",@"15",@"40",@"42", @"10", @"20"];
    }
    return _datasource;
}

#pragma mark - override setter method for V line
- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSInteger num = 0;
    if (xLabels.count<=1) {
        num = 1;
    } else {
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - kLabelW)/num;
    
    // x轴的标度
    for (NSInteger i=0; i<num; i++) {
        CGRect lbF = CGRectMake(i*_xLabelWidth+kLabelW/2, self.frame.size.height-kLabelH, _xLabelWidth, kLabelH);
        UILabel *lb = [self lbWithFrame:lbF];
        lb.text =  xLabels[i];
        [self addSubview:lb];
    }
    
    // x轴的分割线条
    for (NSInteger i=0; i<num+1; i++) {
        CAShapeLayer *shapeLayer =[CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kLabelW+i*_xLabelWidth, kLabelH)];
        [path addLineToPoint:CGPointMake(kLabelW+i*_xLabelWidth, self.frame.size.height-kLabelH)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor;
        shapeLayer.lineWidth = 0.5f;
        [self.layer addSublayer:shapeLayer];
    }
}

#pragma mark - override setter method for H line
- (void)setYLabels:(NSArray *)yLabels
{
    _yLabels = yLabels;
    NSInteger num = 0;
    if (yLabels.count<=1) {
        num = 1;
    } else {
        num = yLabels.count;
    }
    
    // y轴的标度
    CGFloat levelHeight = (self.frame.size.height - kLabelH*2)/(num-1);
    for (NSInteger i=0; i<num; i++) {
        CGRect lbF = CGRectMake(0, self.frame.size.height-i*levelHeight-kLabelH, kLabelW, kLabelH);
        UILabel *lb = [self lbWithFrame:lbF];
        lb.text =  yLabels[i];
        [self addSubview:lb];
    }
    
    // y轴的分割线条
    for (NSInteger i=0; i<num; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kLabelW, kLabelH+i*levelHeight)];
        [path addLineToPoint:CGPointMake(self.frame.size.width-kLabelW,kLabelH+i*levelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.5f;
        [self.layer addSublayer:shapeLayer];
    }
}

- (void)configGradient
{
    NSArray *fillColors = @[UIColorFromRGB(0xf7b8b8),
                            UIColorFromRGB(0xfbd7d7),
                            UIColorFromRGB(0xffffff)];
    
    if(fillColors.count){
        
        NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:fillColors.count];
        
        for (UIColor* color in fillColors) {
            if ([color isKindOfClass:[UIColor class]]) {
                [colors addObject:(id)[color CGColor]];
            } else {
                [colors addObject:(id)color];
            }
        }
        fillColors=colors;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = fillColors;
        [self.layer addSublayer:gradient];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = [UIColor redColor].CGColor;
    ((CAShapeLayer *)self.layer).path = [self strokeChartWithSize:self.frame.size].CGPath;
    
    ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = [UIColor whiteColor].CGColor;
    ((CAShapeLayer *)self.layer).path = [self pathTopLineWithSize:self.frame.size].CGPath;

    ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = [UIColor redColor].CGColor;
    ((CAShapeLayer *)self.layer).path = [self pathBottomLineWithSize:self.frame.size].CGPath;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _yValueMax = 50.f;
        _yValueMin = 0.f;
        _xLabelWidth = 20.f;
        self.xLabels = @[@"11/4", @"11/5", @"11/6", @"11/7", @"11/8", @"11/9", @"11/10"];
        self.yLabels = @[@"0", @"10", @"20", @"30", @"40", @"50"];
        self.clipsToBounds = YES;
        
        [self configGradient];
        
//        CAShapeLayer *chartLine = [self shaperLayer];
//        chartLine.path = [self strokeChartWithSize:self.frame.size].CGPath;
//        [self addAnimationWithLayer:chartLine];
    }
    return self;
}

#pragma mark -
- (CAShapeLayer *)shaperLayer
{
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.fillColor = [UIColor whiteColor].CGColor;
    chartLine.strokeColor = [UIColor redColor].CGColor;
    chartLine.lineWidth = kLineW;
    [self.layer addSublayer:chartLine];
    return chartLine;
}

- (UIBezierPath *)strokeChartWithSize:(CGSize)size
{
    UIBezierPath *progressLine = [UIBezierPath bezierPath];
    [progressLine setLineWidth:kLineW];
    
    for (NSInteger i=0; i<self.datasource.count; i++) {
        NSString *valueStr = _datasource[i];
        float grade =([valueStr floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
        CGPoint point = CGPointMake(kLabelW+i*_xLabelWidth, (1 - grade )* size.height);
        
        if (i == self.datasource.count-1) {
            [self addPoint:point index:i value:[valueStr floatValue]];
        }
        
        if (i==0) {
            [progressLine moveToPoint:point];
        }
        
        [progressLine addLineToPoint:point];
    }
    
    CGFloat lastValue = [[self.datasource objectAtIndex:_datasource.count-1] floatValue];
    float grade = ((float)lastValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    CGPoint lastPoint=CGPointMake(kLabelW+(_datasource.count-1)*_xLabelWidth, size.height - grade * size.height);
    
    CGFloat firstValue = [[self.datasource objectAtIndex:0] floatValue];
    grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    CGPoint firstPoint = CGPointMake(kLabelW, size.height - grade * size.height);
    
    [progressLine addLineToPoint:CGPointMake(lastPoint.x,self.bounds.size.height-kLabelH)];
    [progressLine addLineToPoint:CGPointMake(firstPoint.x,self.bounds.size.height-kLabelH)];
    [progressLine addLineToPoint:firstPoint];
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = progressLine.CGPath;
    gradient.mask=maskLayer;
    
    return progressLine;
}

- (UIBezierPath *)pathTopLineWithSize:(CGSize)size
{
    UIBezierPath *progressLine = [UIBezierPath bezierPath];
    [progressLine setLineWidth:kLineW];
    
    CGFloat lastValue = [[self.datasource objectAtIndex:_datasource.count-1] floatValue];
    float grade = ((float)lastValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    CGPoint lastPoint=CGPointMake(kLabelW+(_datasource.count-1)*_xLabelWidth, size.height - grade * size.height);
    
    CGFloat firstValue = [[self.datasource objectAtIndex:0] floatValue];
    grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    CGPoint firstPoint = CGPointMake(kLabelW, size.height - grade * size.height);
    
    [progressLine moveToPoint:CGPointMake(lastPoint.x,self.bounds.size.height-20)];
    [progressLine addLineToPoint:CGPointMake(firstPoint.x,self.bounds.size.height-20)];
    [progressLine addLineToPoint:firstPoint];
    
    return progressLine;
}

- (UIBezierPath *)pathBottomLineWithSize:(CGSize)size
{
    UIBezierPath *progressLine = [UIBezierPath bezierPath];
    [progressLine setLineWidth:kLineW];
    
    for (NSInteger i=0; i<self.datasource.count; i++) {
        NSString *valueStr = _datasource[i];
        float grade =([valueStr floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
        CGPoint point = CGPointMake(kLabelW+i*_xLabelWidth, (1 - grade )* size.height);
        
        if (i == self.datasource.count-1) {
            [self addPoint:point index:i value:[valueStr floatValue]];
        }
        
        if (i==0) {
            [progressLine moveToPoint:point];
        }
        
        [progressLine addLineToPoint:point];
    }
    
    return progressLine;
}

- (void)addAnimationWithLayer:(CAShapeLayer *)chartLine
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.datasource.count*0.4;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @(0.f);
    pathAnimation.toValue = @(1.f);
    pathAnimation.autoreverses = NO;
    [chartLine addAnimation:pathAnimation
                     forKey:@"strokeEndAnimation"];
    chartLine.strokeEnd = 1.f;
}

#pragma mark - private
- (void)addPoint:(CGPoint)point index:(NSInteger)index value:(CGFloat)value
{
    CGRect frame = CGRectMake(5, 5, 4, 4);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2.f;
    view.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = view.backgroundColor;
    label.text = [NSString stringWithFormat:@"%ld",(long)value];
    CGFloat ww = [self widthOfLabel:label.text fontSize:10.f]+4;
    label.frame = CGRectMake(point.x-ww/2.0, point.y-8*2, ww, 12);
    label.layer.cornerRadius = 12/2;
    label.layer.masksToBounds = YES;
    [self addSubview:label];
    [self addSubview:view];
}

- (UILabel *)lbWithFrame:(CGRect)frame
{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    [lb setLineBreakMode:NSLineBreakByWordWrapping];
    [lb setMinimumScaleFactor:5.0f];
    [lb setNumberOfLines:1];
    [lb setFont:[UIFont boldSystemFontOfSize:9.0f]];
    [lb setTextColor: [UIColor colorWithRed:99.0/255.0
                                      green:99.0/255.0
                                       blue:99.0/255.0
                                      alpha:1.0f]];
    lb.backgroundColor = [UIColor clearColor];
    lb.opaque = NO;
    [lb setTextAlignment:NSTextAlignmentCenter];
    lb.userInteractionEnabled = YES;
    return lb;
}


- (CGFloat)widthOfLabel:(NSString *)strText
               fontSize:(CGFloat)fontSize;

{
    CGSize size;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine|
                                        NSStringDrawingUsesLineFragmentOrigin |
                                            NSStringDrawingUsesFontLeading;
    NSDictionary *attribute = @{NSFontAttributeName:font};
    size = [strText boundingRectWithSize:CGSizeMake(0, MAXFLOAT)
                                 options:options
                              attributes:attribute context:nil].size;
    
    return size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
