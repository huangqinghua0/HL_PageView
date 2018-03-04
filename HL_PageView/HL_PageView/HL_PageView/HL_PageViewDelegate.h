//
//  HL_PageViewDelegate.h
//  HL_PageView
//
//  Created by zjht_macos on 2018/3/3.
//  Copyright © 2018年 黄清华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HL_PageView;

@protocol HL_PageViewDelegate <NSObject>

///scrollView动画过程
- (void)pageView:(HL_PageView *)pageView ScrollAnimationToPrograss:(CGFloat)prograss;

///scrollView滚动结束矫正颜色
- (void)pageViewScrollEndAnimationCheckColorWithpageView:(HL_PageView *)pageView;

@end

