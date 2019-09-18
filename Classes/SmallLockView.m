//
//  SmallLockView.m
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "SmallLockView.h"
#import "IBView.h"

@interface SmallLockView ()
@property (strong, nonatomic) IBOutlet IBView *view0;
@property (strong, nonatomic) IBOutlet IBView *view1;
@property (strong, nonatomic) IBOutlet IBView *view2;
@property (strong, nonatomic) IBOutlet IBView *view3;
@property (strong, nonatomic) IBOutlet IBView *view4;
@property (strong, nonatomic) IBOutlet IBView *view5;
@property (strong, nonatomic) IBOutlet IBView *view6;
@property (strong, nonatomic) IBOutlet IBView *view7;
@property (strong, nonatomic) IBOutlet IBView *view8;

@property (nonatomic, strong) NSArray<IBView *> *arrAnchorView;///< 所有锚点视图
@property (nonatomic, strong) NSMutableArray<IBView *> *arrSelectView;///< 已选锚点视图
@end

@implementation SmallLockView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Subjoin
- (void)loadViewFromXib
{
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (void)viewConfig
{
    _arrAnchorView = @[_view0, _view1, _view2, _view3, _view4, _view5, _view6, _view7, _view8];
    
    _arrSelectView = [NSMutableArray arrayWithCapacity:_arrAnchorView.count];
    
    self.code = @[];
}

#pragma mark - Set
- (void)setCode:(NSArray<NSString *> *)code
{
    _code = code;
    
    [_arrSelectView removeAllObjects];
    
    // 选中
    for (NSString *strNum in code) {
        NSInteger index = [strNum integerValue];
        if (NSLocationInRange(index, NSMakeRange(0, _arrAnchorView.count))) {
            IBView *view = _arrAnchorView[index];
            [_arrSelectView addObject:view];
        }
    }
    
    // 样式
    for (IBView *view in _arrAnchorView) {
        if ([_arrSelectView containsObject:view]) {
            view.borderColor = [UIColor clearColor];
            view.backgroundColor = _selectColor;
        } else {
            view.borderColor = _borderColor;
            view.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    for (IBView *view in _arrAnchorView) {
        view.borderColor = borderColor;
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    for (IBView *view in _arrAnchorView) {
        view.backgroundColor = selectColor;
    }
}

@end
