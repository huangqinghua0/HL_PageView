//
//  HL_SegmentView.h
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HL_SegmentViewDelegate.h"
#import "HL_PageViewDelegate.h"


@interface HL_SegmentView : UIView<HL_PageViewDelegate>

///pageViewController中的scrollView
@property (nonatomic, weak) UIScrollView *pageVcScrollView;
///标签未选中的颜色  默认gray
@property (nonatomic, strong) UIColor *titleNorColor;
///标签选中的颜色 默认black
@property (nonatomic, strong) UIColor *titleSelColor;
@property (nonatomic, weak) id<HL_SegmentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger willSelctedIndex;//拖拽时的下一个index


/**
 创建segement
 
 @param frame frame值
 @param titles 标签数组
 @return 返回segment
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
@end

