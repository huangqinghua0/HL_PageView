//
//  HL_SegmentView.h
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HL_SegmentView : UIView
///标签未选中的颜色  默认gray
@property (nonatomic, strong) UIColor *titleNorColor;
///标签选中的颜色 默认black
@property (nonatomic, strong) UIColor *titleSelColor;
///pageViewController内部的scrollView
@property (nonatomic, weak) UIScrollView *pageVcScrollView;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger willSelctedIndex;//拖拽时的下一个index

@end
