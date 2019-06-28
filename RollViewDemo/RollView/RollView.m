//
//  RollView.m
//
//  Created by 王振钢 on 2019/6/25.
//  Copyright © 2019 王振钢. All rights reserved.
//

#import "RollView.h"

@interface RollView ()
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) RollDirection direction;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RollView

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)duration direction:(RollDirection)direction custom:(UIView *)view {
    
    self = [super initWithFrame:frame];
    if (!view) {
        return self;
    }
    if (self) {
        
        self.clipsToBounds = YES;
        self.duration      = (duration   <= 0.f ? 5.f : duration);
        self.direction     = ((direction < 1 || direction > 4) ? 1 : direction);
        self.customView    = view;
        
        [self addSubview:self.customView];
        
        if (direction == RollDirectionUp ||
            direction == RollDirectionDown) {
            [self scorllVertical];
        } else {
            [self scrollHorizontal];
        }
        __weak RollView *weakSelf = self;
        CGFloat interval = self.duration + 0.1;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            switch (direction) {
                case RollDirectionDown:
                case RollDirectionUp:
                    [weakSelf scorllVertical];
                    break;
                case RollDirectionLeft:
                case RollDirectionRight:
                default:
                    [weakSelf scrollHorizontal];
                    break;
            }
        }];
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

///水平方向的滚动
- (void)scrollHorizontal {
    
    [self.customView setHidden:NO];
    [self beginPoint];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self endPoint];
    } completion:^(BOOL finished) {
        [self.customView setHidden:YES];
        [self beginPoint];
    }];
}

///垂直方向的滚动
- (void)scorllVertical {
    
    [self.customView setHidden:NO];
    [self beginPoint];
    CGFloat del = 1.f;
    CGFloat dur = (self.duration - del ) / 2.f;
    [UIView animateWithDuration:dur animations:^{
        [self middleOrigin];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:dur delay:del options:UIViewAnimationOptionCurveLinear animations:^{
            [self endPoint];
        } completion:^(BOOL finished) {
                [self.customView setHidden:YES];
                [self beginPoint];
        }];
    }];
}

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



@end
