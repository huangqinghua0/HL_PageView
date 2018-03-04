//
//  HL_PageView.h
//  pageDemo
//
//  Created by zjht_macos on 2018/3/1.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HL_SegmentView.h"
#import "HL_PageViewDelegate.h"
#import "HL_SegmentViewDelegate.h"


@interface HL_PageView : UIView<HL_SegmentViewDelegate>

@property (nonatomic, weak) id<HL_PageViewDelegate> delegate;



/**
 创建pageView
 
 @param frame frame值
 @param superController 父控制器
 @param childControllers 自控制器
 @return 返回pageView
 */
- (instancetype)initWithFrame:(CGRect)frame
                  segmentView:(HL_SegmentView *)segmentView
              superController:(UIViewController *)superController
             childControllers:(NSArray *)childControllers;
@end

