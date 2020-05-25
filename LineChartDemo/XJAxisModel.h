//
//  XJAxisModel.h
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XJAxisModel : NSObject

/** title */
@property (nonatomic,strong) NSString *title;
/** color */
@property (nonatomic,strong)  UIColor * clolor;//轴线颜色
/** value */
@property (nonatomic,strong) NSNumber* value;
/** 是否显示轴线 */
@property (nonatomic,assign) BOOL isShow;
/** 是否是虚线 */
@property (nonatomic,assign) BOOL isDash;
/** font */
@property (nonatomic,strong) UIFont *textFont;

@end

NS_ASSUME_NONNULL_END
