//
//  XJLineChartView.h
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJLineChartHeader.h"
// 线条类型
//typedef NS_ENUM(NSInteger, LineType) {
//    LineType_Straight, // 折线
//    LineType_Curve     // 曲线
//};
NS_ASSUME_NONNULL_BEGIN

@interface XJLineChartView : UIView
/** 最大值 */
@property (nonatomic,assign) float maxValue;
/** 最小值 */
@property (nonatomic,assign) float minValue;
/** y轴字体大小 */
@property (nonatomic,strong) UIFont *y_TextFont;

/** 是否是双X轴*/
@property (nonatomic,assign) BOOL isDoubleX;
/** Y轴横线是否是虚线 */
@property (nonatomic,assign) BOOL isYDash;

/**
 *  画轴线
 *  @param y_names      Y轴值的所有值名称
 *  @param xCount x轴的数据个数
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray<XJYAxisModel *> *)y_names xCount:(int)xCount;


/// 设置数据（曲线数据、x轴文案）
/// @param datas <#datas description#>
/// @param xAxis <#xAxis description#>
- (void)drawLineChartViewWithDataModels:(NSArray<XJDataModel *> *)datas withXAxisData:(NSArray< XJXAxisModel * >*)xAxis;

///  设置数据（曲线数据、双x轴文案）
/// @param datas <#datas description#>
/// @param xAxis <#xAxis description#>
/// @param topXAxis <#topXAxis description#>
- (void)drawLineChartViewWithDataModels:(NSArray<XJDataModel *> *)datas withXAxisData:(NSArray< XJXAxisModel * >*)xAxis withTopXAxisData:(NSArray< XJXAxisModel * >*)topXAxis;


- (void)reset;

@end

NS_ASSUME_NONNULL_END
