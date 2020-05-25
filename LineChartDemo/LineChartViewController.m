//
//  LineChartViewController.m
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import "LineChartViewController.h"
#import "XJLineChartView.h"
#define XJ_Screen_W [UIScreen mainScreen].bounds.size.width
#define XJ_Screen_H [UIScreen mainScreen].bounds.size.height
@interface LineChartViewController ()
{
   int xCount;
}
/** <#注释#> */
@property (nonatomic,strong) XJLineChartView *chartView;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    xCount = 7;
    float chartH = 300;
    self.title = @"不等距曲线图";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    XJLineChartView *chartView = [[XJLineChartView alloc] initWithFrame:CGRectMake(10, 20, XJ_Screen_W - 20, chartH)];
    [self.view addSubview:chartView];
    self.chartView = chartView;
    chartView.backgroundColor = [UIColor blackColor];
    [self setChartView];//设置，并画x、y轴线
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, chartH + 50, XJ_Screen_W - 100, 30);
    [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setChartView{
    self.chartView.y_TextFont = [UIFont systemFontOfSize:14];
    self.chartView.minValue = 0;
    self.chartView.maxValue = 100;
    self.chartView.isDoubleX = self.isDoubleX;
    if (self.isDoubleX) {
        self.chartView.isYDash = NO;
    }else{
        self.chartView.isYDash = YES;
    }
    NSArray *x_names = @[@"清醒",@"一般",@"较好",@"黄金"];
    NSArray *xValue = @[@0,@33,@66,@100];
    NSArray *x_colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor yellowColor]];
    NSMutableArray *xAxis = [NSMutableArray new];
    for (int i = 0; i < x_names.count; i++) {
        XJYAxisModel * model = [XJYAxisModel new];
        model.color = x_colors[i];
        model.value = xValue[i];
        model.title = x_names[i];
        [xAxis addObject:model];
    }
    [self.chartView drawLineChartViewWithX_Value_Names:xAxis xCount:xCount];
}
- (NSArray *)setXAxis{
//    最大值和最小值 -> 每个轴线上的值 ， 比如最大值90，最小值是0，10条轴线(9个间隙)，则每条轴线的间距是10(0、10、20、30、40、50、60、70、80、90)
    float min = 0;
    float max = 90;
    float space = (max - min)/(xCount - 1);
    NSMutableArray *xAxisArr = [NSMutableArray new];
    for (int i = 0 ; i < xCount; i++) {
        XJXAxisModel *model  = [XJXAxisModel new];
        model.value = [NSNumber numberWithFloat: i * space];
        model.title = [NSString stringWithFormat:@"12.0%d",i+1];
        model.color = [UIColor whiteColor];
        model.textFont = [UIFont systemFontOfSize:10];
        [xAxisArr addObject:model];
    }
    
    return xAxisArr;
}
- (void)refreshData{
    static int a = 0;
    NSMutableArray *topdatas = [NSMutableArray new];
   NSArray *titles = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
   for (int i = 0; i < xCount; i++) {
       XJXAxisModel *model = [XJXAxisModel new];
       model.title = titles[i];
        model.color = [UIColor whiteColor];
        model.textFont = [UIFont systemFontOfSize:10];
       [topdatas addObject:model];
   }
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
        [self.chartView drawLineChartViewWithDataModels:datas withXAxisData: [self setXAxis] withTopXAxisData:self.isDoubleX?topdatas:@[]];
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
        [self.chartView drawLineChartViewWithDataModels:datas withXAxisData:[self setXAxis] withTopXAxisData:self.isDoubleX?topdatas:@[]];
        a = 0;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.chartView drawLineChartViewWithDataModels:@[] withXAxisData:@[] withTopXAxisData:@[]];
}
@end
