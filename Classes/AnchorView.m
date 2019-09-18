//
//  AnchorView.m
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "AnchorView.h"
#import "IBView.h"

@interface AnchorView ()
@property (strong, nonatomic) IBOutlet IBView *viewBorder;
@property (strong, nonatomic) IBOutlet UIView *viewCenter;

@end

@implementation AnchorView
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
    [self resetStatus];
}

#pragma mark - Set
- (void)setStatus:(NSInteger)status
{
    _status = status;
    
    switch (status) {
        case AnchorViewStatus_Normal:
        {
            _viewCenter.hidden = YES;
            _viewBorder.borderColor = _normalColor;
            _viewCenter.backgroundColor = _normalColor;
        }
            break;
        case AnchorViewStatus_Select:
        {
            _viewCenter.hidden = NO;
            _viewBorder.borderColor = _selectColor;
            _viewCenter.backgroundColor = _selectColor;
        }
            break;
        case AnchorViewStatus_Error:
        {
            _viewCenter.hidden = NO;
            _viewBorder.borderColor = _errorColor;
            _viewCenter.backgroundColor = _errorColor;
        }
            break;
        default:
            break;
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.status = _status;
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    self.status = _status;
}

- (void)setErrorColor:(UIColor *)errorColor
{
    _errorColor = errorColor;
    self.status = _status;
}

#pragma mark - Private
- (void)resetStatus
{
    self.status = AnchorViewStatus_Normal;
}

#pragma mark - Overwrite
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 圆形
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
}

@end
