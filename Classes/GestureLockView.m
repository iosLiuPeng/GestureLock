//
//  GestureLockView.m
//  Example
//
//  Created by 刘鹏i on 2019/9/18.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "GestureLockView.h"
#import "AnchorView.h"

typedef NS_ENUM(NSUInteger, GestureLockViewStatus) {
    GestureLockViewStatus_Normal,
    GestureLockViewStatus_Select,
    GestureLockViewStatus_Error,
    GestureLockViewStatus_End,
};

@interface GestureLockView ()
@property (strong, nonatomic) IBOutlet AnchorView *anchorView0;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView1;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView2;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView3;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView4;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView5;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView6;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView7;
@property (strong, nonatomic) IBOutlet AnchorView *anchorView8;

@property (nonatomic, strong) NSArray<AnchorView *> *arrAnchorView;///< 所有锚点视图
@property (nonatomic, strong) NSMutableArray<AnchorView *> *arrSelectView;///< 已选锚点视图
@property (nonatomic, strong) NSValue *currentPoint;        ///< 当前手指位置
@property (nonatomic, assign) GestureLockViewStatus status; ///< 当前显示状态
@end

@implementation GestureLockView
+ (Class)layerClass
{
    return [CAShapeLayer class];
}

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
    _arrAnchorView = @[_anchorView0, _anchorView1, _anchorView2, _anchorView3, _anchorView4, _anchorView5, _anchorView6, _anchorView7, _anchorView8];
    
    _arrSelectView = [NSMutableArray arrayWithCapacity:_arrAnchorView.count];
    
    self.status = GestureLockViewStatus_Normal;
    
    _minCount = 4;
}

#pragma mark - Private
/// 已选序号
- (NSArray<NSString *> *)codeWithSelectedItem
{
    NSMutableArray *arrCode = [[NSMutableArray alloc] init];
    for (AnchorView *view in _arrSelectView) {
        NSInteger index = [_arrAnchorView indexOfObject:view];
        [arrCode addObject:[NSString stringWithFormat:@"%ld", index]];
    }
    return [arrCode copy];
}

#pragma mark - Overwrite
- (void)drawRect:(CGRect)rect
{
    if (_arrSelectView.count == 0) {
        return;
    }
    
    // 连线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < _arrSelectView.count; i++) {
        AnchorView *view = _arrSelectView[i];
        CGPoint center = [view.superview convertPoint:view.center toView:self];
        if (i == 0) {
            [bezierPath moveToPoint:center];
        } else {
            [bezierPath addLineToPoint:center];
        }
    }
    
    if (_currentPoint) {
        [bezierPath addLineToPoint:[_currentPoint CGPointValue]];
    }
    
    bezierPath.lineWidth = _lineWidth;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    if (_status == GestureLockViewStatus_Error) {
        [_errorColor setStroke];
    } else {
        [_selectColor setStroke];
    }
    [bezierPath stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.currentPoint = [NSValue valueWithCGPoint:point];
    
    self.status = GestureLockViewStatus_Normal;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.currentPoint = [NSValue valueWithCGPoint:point];
    
    self.status = GestureLockViewStatus_Select;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = nil;
    NSArray *code = [self codeWithSelectedItem];
    if (code.count == 0) {
        return;
    }

    if (_arrSelectView.count < _minCount) {
        // 没达到最小选择个数
        self.status = GestureLockViewStatus_Error;
    } else if (_verifyCode.count && [_verifyCode isEqualToArray:code] == NO) {
        // 与传入的校验码不一致
        self.status = GestureLockViewStatus_Error;
    } else {
        // 正常
        self.status = GestureLockViewStatus_End;
    }
    
    if ([_delegate respondsToSelector:@selector(gestureLockView:didEndWithCode:)]) {
        [_delegate gestureLockView:self didEndWithCode:code];
    }
    
    if (_status == GestureLockViewStatus_End) {
        if ([_delegate respondsToSelector:@selector(gestureLockView:didSuccessWithCode:)]) {
            [_delegate gestureLockView:self didSuccessWithCode:code];
        }
    }
    
    // 自动恢复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 因为是延时执行，所以还没执行前，可能已经手动又开始连接了，此时不能重置用户已连接的状态
        if (self.status != GestureLockViewStatus_Select) {
            self.status = GestureLockViewStatus_Normal;
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Set
- (void)setCurrentPoint:(NSValue *)currentPoint
{
    _currentPoint = currentPoint;
    
    if (currentPoint == nil) {
        return;
    }
    
    CGPoint point = [currentPoint CGPointValue];
    // 当前选中的锚点
    AnchorView *currentAnchor = nil;
    for (AnchorView *view in _arrAnchorView) {
        CGRect viewFrame = [view convertRect:view.bounds toView:self];
        if (CGRectContainsPoint(viewFrame, point)) {
            currentAnchor = view;
            break;
        }
    }

    if (currentAnchor && [_arrSelectView containsObject:currentAnchor] == NO) {
        [_arrSelectView addObject:currentAnchor];
    }
}

- (void)setStatus:(GestureLockViewStatus)status
{
    _status = status;
    
    for (AnchorView *view in _arrSelectView) {
        switch (status) {
            case GestureLockViewStatus_Normal:
            case GestureLockViewStatus_Select:
            case GestureLockViewStatus_Error:
                view.status = status;
                break;
            case GestureLockViewStatus_End:
                view.status = GestureLockViewStatus_Select;
                break;
            default:
                break;
        }
    }
    
    if (_status == GestureLockViewStatus_Normal) {
        [_arrSelectView removeAllObjects];
    }
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    self.status = _status;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    for (AnchorView *view in _arrAnchorView) {
        view.normalColor = normalColor;
    }
    
    self.status = _status;
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    for (AnchorView *view in _arrAnchorView) {
        view.selectColor = selectColor;
    }
    
    self.status = _status;
}

- (void)setErrorColor:(UIColor *)errorColor
{
    _errorColor = errorColor;
    
    for (AnchorView *view in _arrAnchorView) {
        view.errorColor = errorColor;
    }
    
    self.status = _status;
}

#pragma mark - Prepare
/// 预览时调用，程序实际运行时不调用
- (void)prepareForInterfaceBuilder
{
    [_arrSelectView removeAllObjects];
    [_arrSelectView addObjectsFromArray:@[_anchorView0, _anchorView3, _anchorView6, _anchorView7,  _anchorView8]];

    self.status = GestureLockViewStatus_Select;
}

@end
