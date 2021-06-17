//
//  RollView.m
//
//  Created by 王振钢 on 2019/6/25.
//  Copyright © 2019 王振钢. All rights reserved.
//

#import "RollView.h"

@interface RollView ()
/// 代理
@property (nonatomic, weak)   id<RollViewDelegate> delegate;
/// 自定义 view
@property (nonatomic, strong) UIView *customView;
/// 时间
@property (nonatomic, assign) NSTimeInterval duration;
/// 方向
@property (nonatomic, assign) RollDirection direction;
/// 动画设置
@property (nonatomic, assign) UIViewAnimationOptions options;

@end

@implementation RollView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<RollViewDelegate>)delegate
                     duration:(NSTimeInterval)duration
                    direction:(RollDirection)direction
                       custom:(UIView *)view {
    
    self = [super initWithFrame:frame];
    if (!view) {
        return self;
    }
    if (self) {
        
        self.clipsToBounds = YES;
        self.state         = RollViewStateDidInit;
        self.delegate      = delegate;
        self.duration      = (duration   <= 0.f ? 5.f : duration);
        self.direction     = ((direction < 1 || direction > 4) ? 1 : direction);
        self.customView    = view;
        self.options       = UIViewAnimationOptionLayoutSubviews|
                             UIViewAnimationOptionCurveLinear|
                             UIViewAnimationOptionAllowUserInteraction;
//                             UIViewAnimationOptionRepeat;
        
        [self addSubview:self.customView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(rollViewSate:customView:)]) {
            [self.delegate rollViewSate: self.state customView: view];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rollViewWillEnterForeground) name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)setCustomView:(UIView *)customView {
    
    if (_customView != customView) {
        _customView  = customView;
        
        if (CGRectEqualToRect(self.customView.frame, CGRectZero)) {
            [self.customView setFrame:self.bounds];
        }
    }
}

- (void)start {
    
    if (self.state == RollViewStateDidStop || self.state == RollViewStateRolling) {
        return;
    }
    
    self.state = RollViewStateWillBegin;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollViewSate:customView:)]) {
        [self.delegate rollViewSate: self.state customView: self.customView];
    }
    
    if (self.direction == RollDirectionUp ||
        self.direction == RollDirectionDown) {
        [self scorllVertical];
    } else {
        [self scrollHorizontal];
    }
}

- (void)stop {
    
    self.state = RollViewStateDidStop;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollViewSate:customView:)]) {
        [self.delegate rollViewSate: self.state customView: self.customView];
    }
}

#pragma mark - Direction

///水平方向的滚动
- (void)scrollHorizontal {
    
    if (self.state == RollViewStateDidStop) {
        return;
    }
    
    [self.customView setHidden:NO];
    [self beginPoint];
    
    self.state = RollViewStateRolling;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollViewSate:customView:)]) {
        [self.delegate rollViewSate: self.state customView: self.customView];
    }
    
    [UIView animateWithDuration:self.duration delay:0 options:self.options animations:^{
        [self endPoint];
    } completion:^(BOOL finished) {
        [self.customView setHidden:YES];
        [self scrollHorizontal];
    }];
}

///垂直方向的滚动
- (void)scorllVertical {
    
    if (self.state == RollViewStateDidStop) {
        return;
    }
    
    [self.customView setHidden:NO];
    [self beginPoint];
    
    self.state = RollViewStateRolling;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollViewSate:customView:)]) {
        [self.delegate rollViewSate: self.state customView: self.customView];
    }
    
    CGFloat del = 1.f;
    CGFloat dur = (self.duration - del ) / 2.f;
    [UIView animateWithDuration:dur delay:(dur + del) options:self.options animations:^{
        [self middleOrigin];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:dur delay:del options:self.options animations:^{
                [self endPoint];
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.customView setHidden:YES];
                    [self scorllVertical];
                }
            }];
        }
    }];
}

#pragma mark - Point

///开始位置
- (void)beginPoint {
    
    switch (self.direction) {
        case RollDirectionRight:  [self leftOrigin];  break;
        case RollDirectionUp:     [self downOrigin];  break;
        case RollDirectionDown:   [self upOrigin];    break;
        default:                  [self rightOrigin]; break;
    }
}

///结束位置
- (void)endPoint {
    
    switch (self.direction) {
        case RollDirectionRight:  [self rightOrigin]; break;
        case RollDirectionUp:     [self upOrigin];    break;
        case RollDirectionDown:   [self downOrigin];  break;
        default:                  [self leftOrigin];  break;
    }
}

#pragma mark - Frame

///右
- (void)rightOrigin {
    CGRect frame            = self.customView.frame;
    frame.origin.x          = self.bounds.size.width;
    self.customView.frame   = frame;
}

///左
- (void)leftOrigin {
    CGRect frame            = self.customView.frame;
    frame.origin.x          = -self.customView.bounds.size.width;
    self.customView.frame   = frame;
}

///上
- (void)upOrigin {
    CGRect frame            = self.customView.frame;
    frame.origin.y          = -self.bounds.size.height;
    self.customView.frame   = frame;
}

///下
- (void)downOrigin {
    CGRect frame            = self.customView.frame;
    frame.origin.y          = self.bounds.size.height;
    self.customView.frame   = frame;
}

///中
- (void)middleOrigin {
    CGRect frame            = self.customView.frame;
    frame.origin.y          = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.customView.frame)) / 2.f;
    self.customView.frame   = frame;
}

#pragma mark - Other

- (void)rollViewWillEnterForeground {
    if (self.state == RollViewStateRolling &&
        (self.direction == RollDirectionUp ||
         self.direction == RollDirectionDown)) {
        self.state = RollViewStateDidInit;
        [self start];
    }
}


@end
