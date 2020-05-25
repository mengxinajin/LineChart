# LineChart
不等距曲线图

![RPReplay_Final1590370994.gif](https://upload-images.jianshu.io/upload_images/2459036-f17e6faff772f181.gif?imageMogr2/auto-orient/strip)
就是描点画线加动画，没有太难的。
我自定义了一个LineChartView，和几个模型，具体demo下面会给链接
![image.png](https://upload-images.jianshu.io/upload_images/2459036-19db7ba89f429803.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
给lineChartview暴露出了几个属性和方法,都有注释
![image.png](https://upload-images.jianshu.io/upload_images/2459036-9364229cbc2634f1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在controller里面进行初始化配置
![image.png](https://upload-images.jianshu.io/upload_images/2459036-1be8a79a47ac741a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
setChartView方法
```
self.chartView.y_TextFont = [UIFont systemFontOfSize:14];
    self.chartView.minValue = 0;
    self.chartView.maxValue = 100;
    NSArray *x_names = @[@"清醒",@"一般",@"黄金"];
    NSArray *xValue = @[@0,@50,@100];
    NSArray *x_colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor]];
    NSMutableArray *xAxis = [NSMutableArray new];
    for (int i = 0; i < x_names.count; i++) {
        XJYAxisModel * model = [XJYAxisModel new];
        model.clolor = x_colors[i];
        model.value = xValue[i];
        model.title = x_names[i];
        [xAxis addObject:model];
    }
    [self.chartView drawLineChartViewWithX_Value_Names:xAxis xCount:xCount];
```
我在controller里面定义了个方法setXAxis，用于设置x轴线上的模型具体实现
```
- (NSArray *)setXAxis{
//    最大值和最小值 -> 每个轴线上的值 ， 比如最大值90，最小值是0，10条轴线(9个间隙)，则每条轴线的间距是10(0、10、20、30、40、50、60、70、80、90)
    float min = 0;
    float max = 90;
    float space = (max - min)/(xCount - 1);
    NSMutableArray *xAxisArr = [NSMutableArray new];
    for (int i = 0 ; i < xCount; i++) {
        XJXAxisModel *model  = [XJXAxisModel new];
        model.value = [NSNumber numberWithFloat: i * space];
        model.title = [NSString stringWithFormat:@"12:0%d",i];
        model.clolor = [UIColor whiteColor];
        model.textFont = [UIFont systemFontOfSize:10];
        [xAxisArr addObject:model];
    }
    
    return xAxisArr;
}
```
页面上弄了一个按钮，用于触发赋值，
```
- (void)refreshData{
    static int a = 0;
    if (a == 0) {
        NSMutableArray *datas = [NSMutableArray new];
            NSArray *valueXs = @[@0,@5,@11,@19,@25,@31,@39,@43,@51,@59,@70,@85,@90];
            NSArray *valueYs = @[@0,@10,@55,@99,@88,@99,@77,@87,@10,@53,@80,@10,@0];
            for (int i = 0; i < valueXs.count; i++) {
                XJDataModel *model = [XJDataModel new];
                model.xValue = valueXs[i];
                model.yValue = valueYs[i];
                [datas addObject:model];
            }
        [self.chartView drawLineChartViewWithDataModels:datas withXAxisData:[self setXAxis]];
        a = 1;
    }else{
        NSMutableArray *datas = [NSMutableArray new];
            NSArray *valueXs = @[@0,@5,@11,@19,@25,@31,@39,@43,@51,@59,@70,@85,@90];
            NSArray *valueYs = @[@0,@90,@55,@9,@88,@19,@77,@87,@10,@93,@80,@10,@0];
            for (int i = 0; i < valueXs.count; i++) {
                XJDataModel *model = [XJDataModel new];
                model.xValue = valueXs[i];
                model.yValue = valueYs[i];
                [datas addObject:model];
            }
        [self.chartView drawLineChartViewWithDataModels:datas withXAxisData:[self setXAxis]];
        a = 0;
    }
}
```
在画线的具体实现里面，先赋值x轴文案，然后描点画线并设置动画效果
```
- (void)drawLineChartViewWithDataModels:(NSArray<XJDataModel *> *)datas withXAxisData:(NSArray< XJXAxisModel * >*)xAxis{
    [self reset];
//    1. 设置x轴文案
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
```
简单介绍到这里，[demo](https://github.com/mxj123/LineChart)













