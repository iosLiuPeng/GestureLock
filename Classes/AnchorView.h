//
//  AnchorView.h
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//  锚点视图，用来修改成UI设计的样式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnchorViewStatus) {
    AnchorViewStatus_Normal,
    AnchorViewStatus_Select,
    AnchorViewStatus_Error,
};

IB_DESIGNABLE
@interface AnchorView : UIView
@property (nonatomic, assign) IBInspectable NSInteger status;  ///< 当前显示状态

@property (nonatomic, strong) IBInspectable UIColor *normalColor;   ///< 正常状态下颜色
@property (nonatomic, strong) IBInspectable UIColor *selectColor;   ///< 选择状态下颜色
@property (nonatomic, strong) IBInspectable UIColor *errorColor;    ///< 错误状态下颜色
@end

NS_ASSUME_NONNULL_END
