//
//  SmallLockView.h
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//  结果预览图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface SmallLockView : UIView
@property (nonatomic, copy) NSArray<NSString *> *code;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;   ///< 边框颜色
@property (nonatomic, strong) IBInspectable UIColor *selectColor;   ///< 选择状态下颜色
@end

NS_ASSUME_NONNULL_END
