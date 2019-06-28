//
//  RollView.h
//
//  Created by 王振钢 on 2019/6/25.
//  Copyright © 2019 王振钢. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RollDirection) {
    RollDirectionLeft  = 1, //向左滚动
    RollDirectionRight = 2, //向右滚动
    RollDirectionUp    = 3, //向上滚动
    RollDirectionDown  = 4, //向下滚动
};


@interface RollView : UIView


- (instancetype)initWithFrame:(CGRect)frame             //frame
                     duration:(NSTimeInterval)duration  //动画时长，默认5秒
                    direction:(RollDirection)direction  //滚动方向，默认向左
                       custom:(UIView *)view;           //自定义view

@end

NS_ASSUME_NONNULL_END
