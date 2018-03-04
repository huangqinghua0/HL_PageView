//
//  HL_SegmentViewDelegate.h
//  HL_PageView
//
//  Created by zjht_macos on 2018/3/3.
//  Copyright © 2018年 黄清华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HL_SegmentView;

@protocol HL_SegmentViewDelegate <NSObject>

///选中标签后回调
- (void)segmentView:(HL_SegmentView *)segement SelectedItemCallBackItem:(UIButton *)item;

@end

