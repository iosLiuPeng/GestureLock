//
//  ViewController.m
//  Example
//
//  Created by 刘鹏i on 2019/9/16.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "ViewController.h"
#import "SmallLockView.h"
#import "GestureLockView.h"

@interface ViewController () <GestureLockViewDelegate>
@property (strong, nonatomic) IBOutlet SmallLockView *smallLockView;
@property (strong, nonatomic) IBOutlet UILabel *lblTip;
@property (strong, nonatomic) IBOutlet GestureLockView *gestureLockView;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTip.text = @"绘制解锁图案";
}

#pragma mark - GestureLockViewDelegate
/// 绘制结束
- (void)gestureLockView:(GestureLockView *)view didEndWithCode:(NSArray<NSString *> *)code
{
    NSLog(@"%@", [code componentsJoinedByString:@","]);
    
    if (code.count < 4) {
        _lblTip.text = @"至少需要连接4个点，请重新绘制";
    } else {
        if (_smallLockView.code.count == 0) {
            _smallLockView.code = code;
            
            _gestureLockView.verifyCode = code;
            _lblTip.text = @"请再次绘制解锁图案";
        } else {
            if ([code isEqualToArray:_gestureLockView.verifyCode]) {
                _lblTip.text = @"解锁图案设置成功";
                
                _smallLockView.code = @[];
                _gestureLockView.verifyCode = @[];
            } else {
                _lblTip.text = @"与上次绘制图案不一致，请重新绘制";
            }
        }
    }
}

/// 绘制成功
- (void)gestureLockView:(GestureLockView *)view didSuccessWithCode:(NSArray<NSString *> *)code
{
    NSLog(@"== 绘制成功：%@ ==", [code componentsJoinedByString:@","]);
}

@end
