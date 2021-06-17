//
//  RollView.h
//
//  Created by 王振钢 on 2019/6/25.
//  Copyright © 2019 王振钢. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, RollDirection) {
    /// 向左滚动
    RollDirectionLeft  = 1,
    /// 向右滚动
    RollDirectionRight = 2,
    /// 向上滚动
    RollDirectionUp    = 3,
    /// 向下滚动
    RollDirectionDown  = 4,
};


typedef NS_ENUM(NSInteger, RollViewState) {
    /// 初始化
    RollViewStateDidInit    = 1,
    /// 开始滚动
    RollViewStateWillBegin  = 2,
    /// 滚动中
    RollViewStateRolling    = 3,
    /// 停止滚动
    RollViewStateDidStop    = 4,
};


@protocol RollViewDelegate <NSObject>

@optional
/// 滚动状态
- (void)rollViewSate:(RollViewState)state customView:(UIView *)view;

@end

@interface RollView : UIView

/// 滚动状态
@property (nonatomic, assign) RollViewState state;

/// 禁用的初始化方法
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/// 指定初始化方法，
- (instancetype)initWithFrame:(CGRect)frame                  //frame
                     delegate:(id<RollViewDelegate>)delegate //数据代理
                     duration:(NSTimeInterval)duration       //动画时长，默认5秒
                    direction:(RollDirection)direction       //滚动方向，默认向左
                       custom:(UIView *)view                 //自定义view
                        NS_DESIGNATED_INITIALIZER;

/// 初始化后需要手动调用此方法开始滚动
- (void)start;
/// 停止滚动
- (void)stop;

@end

NS_ASSUME_NONNULL_END
