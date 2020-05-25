//
//  XJDataModel.h
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJDataModel : NSObject

/** x */
@property (nonatomic,strong) NSNumber *xValue;
/** y */
@property (nonatomic,strong) NSNumber *yValue;

@end

NS_ASSUME_NONNULL_END
