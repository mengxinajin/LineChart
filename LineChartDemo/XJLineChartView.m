//
//  XJLineChartView.m
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import "XJLineChartView.h"
#define fromTag 999
#define MARGIN            40   // 坐标轴与画布间距
#define Y_EVERY_MARGIN    100   // y轴每一个值的间隔数
static CGRect myFrame;
static int _xCount;
@interface XJLineChartView ()

{
    NSInteger _min;
    NSInteger _max;
    float x_space;//像素间距
    float value_xSpace;//x方向间距
    float y_space;//
    float value_ySpace;//y方向间距
    float x_start;//第一条竖线坐标x值
    float y_start;//
    float x_width;//轴线的总长度，第一根线到最后一根线的长度
    float y_height;//轴线高度
    float scaleX;
    float scaleY;
    CAShapeLayer *shapeLayer;
    NSMutableArray *pointShapeLayers;
    NSMutableArray *xLabels;
}


@end
@implementation XJLineChartView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //背景视图
         UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
         [self addSubview:backView];
        pointShapeLayers = [NSMutableArray new];
        xLabels = [NSMutableArray new];
         myFrame = frame;
    }
    return self;
}
- (void)drawLineChartViewWithX_Value_Names:(NSMutableArray<XJYAxisModel *> *)y_names xCount:(int)xCount{
    _xCount = xCount;
    
    //Y轴
    for (int i=0; i<y_names.count; i++) {
        XJYAxisModel *model = y_names[i];
      CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        NSLog(@"Y-5 = %.2f",Y-5);
      UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
      textLabel.text = model.title;
      textLabel.font = self.y_TextFont?self.y_TextFont:[UIFont systemFontOfSize:10];
      textLabel.textAlignment = NSTextAlignmentCenter;
      textLabel.textColor = model.clolor;
      [self addSubview:textLabel];
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint: CGPointMake(MARGIN + 1, Y)];
        [path1 addLineToPoint: CGPointMake(self.frame.size.width - 5, Y)];
        path1.lineWidth = 2;
        CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
        shapeLayer2.path = path1.CGPath;
        shapeLayer2.strokeColor = [model.clolor CGColor];
        shapeLayer2.fillColor = [UIColor clearColor].CGColor;
        shapeLayer2.borderWidth = 2.0;
        [shapeLayer2 setLineJoin:kCALineJoinBevel];
        [shapeLayer2 setLineDashPattern:@[@10,@5]];
        [self.subviews[0].layer addSublayer:shapeLayer2];
        if (i == 0) {
            y_start = Y;
        }else if (i == y_names.count - 1){
            y_height = y_start - Y;
        }
  }
    //X轴
    float space = (CGRectGetWidth(myFrame) - MARGIN)/xCount;
    
    for (int i=0; i<xCount; i++) {
        CGFloat X = MARGIN + space*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, space, 25)];
        textLabel.text = @"";
        textLabel.font = self.y_TextFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
        [xLabels addObject:textLabel];
        CGPoint point = CGPointMake(textLabel.bounds.size.width * 0.5 +X, CGRectGetHeight(myFrame)-MARGIN);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, MARGIN)];
        CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
       shapeLayer2.path = path.CGPath;
       shapeLayer2.strokeColor = [[UIColor lightGrayColor] CGColor];
       shapeLayer2.fillColor = [UIColor clearColor].CGColor;
       shapeLayer2.borderWidth = 2.0;
       [self.subviews[0].layer addSublayer:shapeLayer2];
        textLabel.tag = fromTag+i;
        if (i == 0) {
            x_start = point.x;
        }else if (i == xCount - 1){
            x_width = point.x - x_start;

        }
    }
    
}
- (void)setXAxisData:(NSArray< XJXAxisModel * >*)xAxis{
    if (xAxis.count == 0) {
        return;
    }
    for (int i = 0; i < xAxis.count; i++) {
        XJXAxisModel*model = xAxis[i];
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == fromTag + i) {
                obj.textColor = model.clolor;
                obj.font = model.textFont?model.textFont : [UIFont systemFontOfSize:10];
                obj.text = model.title;
                *stop = YES;
            }
        }];
        if (i == 0) {
            _min = model.value.integerValue;
        }
        if (i == xAxis.count - 1) {
            _max = model.value.integerValue;
        }
    }
    x_space = (x_width - x_start) / (_xCount - 1);
    value_xSpace = (_max - _min) /(_xCount - 1);
    scaleX = x_width/(_max - _min);
    scaleY = y_height / (self.maxValue - self.minValue);// yheight/value_max ->200pi / 100   = 2
    NSLog(@"start = %.2f,width = %.2f,space = %.2f,y_start = %.2f,y_height = %.2f,scaleX = %.2f,scaleY = %.2f",x_start,x_width,x_space,y_start,y_height,scaleX,scaleY);
    
    
}
/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names{
    
UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴、X轴的直线
//    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN, MARGIN)];
//
//    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//
//    //2.添加箭头
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5)];
//    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5)];
//
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN-5)];
//    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
//    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5, CGRectGetHeight(myFrame)-MARGIN+5)];

    //3.添加索引格
    //X轴
//    for (int i=0; i<x_names.count; i++) {
//        CGFloat X = MARGIN + MARGIN*(i+1);
//        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-MARGIN);
//        [path moveToPoint:point];
//        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
//    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
//    for (int i=0; i<11; i++) {
//        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
//        CGPoint point = CGPointMake(MARGIN,Y);
//        [path moveToPoint:point];
//        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
//    }
    NSArray *colors = @[[UIColor orangeColor],[UIColor blueColor],[UIColor redColor]];
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, MARGIN, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
        CGPoint point = CGPointMake(textLabel.bounds.size.width * 0.5 +X, CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(textLabel.bounds.size.width * 0.5 +X, MARGIN)];
    }
    //Y轴
    for (int i=0; i<3; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-Y_EVERY_MARGIN*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%d",50*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = colors[i];
        [self addSubview:textLabel];
    }
    
   
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
//
    //Y轴
    for (int i=0; i<3; i++) {
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        CGFloat Y = CGRectGetHeight(myFrame)- MARGIN - Y_EVERY_MARGIN * i;
        [path1 moveToPoint: CGPointMake(MARGIN + 1, Y)];
        [path1 addLineToPoint: CGPointMake(self.frame.size.width, Y)];
        path1.lineWidth = 2;
        CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
        shapeLayer2.path = path1.CGPath;
        shapeLayer2.strokeColor = [colors[i] CGColor];
        shapeLayer2.fillColor = [UIColor clearColor].CGColor;
        shapeLayer2.borderWidth = 2.0;
        [shapeLayer2 setLineJoin:kCALineJoinBevel];
        [shapeLayer2 setLineDashPattern:@[@10,@5]];
        [self.subviews[0].layer addSublayer:shapeLayer2];
    }
    
    
}
- (void)reset{
//    清空线，清空x轴描述
    NSMutableArray *muSub = [[NSMutableArray alloc] initWithArray:[self.subviews[0].layer sublayers]];
    [muSub removeObject:shapeLayer];
    [muSub removeObjectsInArray:pointShapeLayers];
    [pointShapeLayers removeAllObjects];
    self.subviews[0].layer.sublayers = muSub;
    [xLabels enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = @"";
    }];
}
- (void)drawLineChartViewWithDataModels:(NSArray<XJDataModel *> *)datas withXAxisData:(NSArray< XJXAxisModel * >*)xAxis{
    [self reset];
    [self setXAxisData:xAxis];
    if (datas.count == 0) {
        return;
    }
//    [shapeLayer removeFromSuperlayer];
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i = 0; i < datas.count; i++) {
        XJDataModel *model = [datas objectAtIndex:i];
        float Y = y_start - scaleY * model.yValue.floatValue;
        float X = x_start + scaleX * model.xValue.floatValue;
        NSLog(@"X,Y = (%.2f,%.2f)",X,Y);
        CGPoint point = CGPointMake(X, Y);
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
//    画线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    for (int i =0; i<allPoints.count; i++) {
        if (i==0) {
            PrePonit = [allPoints[0] CGPointValue];
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
            PrePonit = NowPoint;
        }
    }
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 3.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
//    加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    [shapeLayer addAnimation:animation forKey:@"strokeEnd"];
    for (int i = 0; i < datas.count; i++) {
        CGPoint point =[allPoints[i] CGPointValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-2.5, point.y-2.5, 5, 5) cornerRadius:5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [pointShapeLayers addObject:layer];
    }
}

///**
// *  画折线图
// */
//-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType{
//    
//    //1.画坐标轴
//    [self drawXYLine:x_names];
//    //2.获取目标值点坐标
//    NSMutableArray *allPoints = [NSMutableArray array];
//    for (int i=0; i<targetValues.count; i++) {
//        CGFloat doubleValue = 2*[targetValues[i] floatValue]; //目标值放大两倍
//        CGFloat X = MARGIN + MARGIN*(i+1);
//        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-doubleValue;
//        CGPoint point = CGPointMake(X,Y);
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.strokeColor = [UIColor purpleColor].CGColor;
//        layer.fillColor = [UIColor purpleColor].CGColor;
//        layer.path = path.CGPath;
//        [self.subviews[0].layer addSublayer:layer];
//        [allPoints addObject:[NSValue valueWithCGPoint:point]];
//    }
//
//    //3.坐标连线
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:[allPoints[0] CGPointValue]];
//    CGPoint PrePonit;
//    switch (lineType) {
//        case LineType_Straight: //直线
//            for (int i =1; i<allPoints.count; i++) {
//                CGPoint point = [allPoints[i] CGPointValue];
//                [path addLineToPoint:point];
//            }
//            break;
//        case LineType_Curve:   //曲线
//            for (int i =0; i<allPoints.count; i++) {
//                if (i==0) {
//                    PrePonit = [allPoints[0] CGPointValue];
//                }else{
//                    CGPoint NowPoint = [allPoints[i] CGPointValue];
//                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
//                    PrePonit = NowPoint;
//                }
//            }
//            break;
//    }
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = path.CGPath;
//    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.borderWidth = 2.0;
//    [self.subviews[0].layer addSublayer:shapeLayer];
//    
//    //4.添加目标值文字
//    for (int i =0; i<allPoints.count; i++) {
//        UILabel *label = [[UILabel alloc] init];
//        label.textColor = [UIColor purpleColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:10];
//        [self.subviews[0] addSubview:label];
//        
//        if (i==0) {
//            CGPoint NowPoint = [allPoints[0] CGPointValue];
//            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
//            label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
//            PrePonit = NowPoint;
//        }else{
//            CGPoint NowPoint = [allPoints[i] CGPointValue];
//            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
//                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y-20, MARGIN, 20);
//            }else{ //文字置于点下方
//                label.frame = CGRectMake(NowPoint.x-MARGIN/2, NowPoint.y, MARGIN, 20);
//            }
//            label.text = [NSString stringWithFormat:@"%.0lf",(CGRectGetHeight(myFrame)-NowPoint.y-MARGIN)/2];
//            PrePonit = NowPoint;
//        }
//    }
//    
//}
@end
