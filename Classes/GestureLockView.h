//
//  GestureLockView.h
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GestureLockView;

@protocol GestureLockViewDelegate <NSObject>
/// 绘制结束
- (void)gestureLockView:(GestureLockView *)view didEndWithCode:(NSArray<NSString *> *)code;
/// 绘制成功
- (void)gestureLockView:(GestureLockView *)view didSuccessWithCode:(NSArray<NSString *> *)code;
@end

IB_DESIGNABLE
@interface GestureLockView : UIView
@property (nonatomic, strong) NSArray<NSString *> *verifyCode;///< 用于校验
@property (nonatomic, assign) NSInteger minCount;///< 最少选择个数（默认4）
@property (nonatomic, weak) IBOutlet id<GestureLockViewDelegate> delegate;   ///< 回调代理

@property (nonatomic, assign) IBInspectable CGFloat lineWidth;      ///< 线宽

@property (nonatomic, strong) IBInspectable UIColor *normalColor;   ///< 正常状态下颜色
@property (nonatomic, strong) IBInspectable UIColor *selectColor;   ///< 选择状态下颜色
@property (nonatomic, strong) IBInspectable UIColor *errorColor;    ///< 错误状态下颜色
@end

NS_ASSUME_NONNULL_END
