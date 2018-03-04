//
//  HL_SegmentView.m
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import "HL_SegmentView.h"
#import "HL_PageView.h"

@interface HL_SegmentView () <HL_PageViewDelegate>
@property (nonatomic, strong) UIScrollView *itemScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *selLine;
@property (nonatomic, strong) UIButton *selectedButton;
//@property (nonatomic, assign) BOOL isClickItem;

@end

@implementation HL_SegmentView {
    CGFloat _previousItemoffset;
    CGRect _previousItemFrame;
    CGFloat _norRed , _norGreen , _norBlue;
    CGFloat _selRed , _selGreen , _selBlue;
    UIColor *_titleNorColor , *_titleSelColor;
    CGFloat _segmentWidth , _segmentHeight;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        _segmentWidth = frame.size.width;
        _segmentHeight = frame.size.height;
        [self setUpUI];
    }
    return self;
}

#pragma mark - HL_PageViewDelegate

- (void)pageView:(HL_PageView *)pageView ScrollAnimationToPrograss:(CGFloat)prograss {
    CGFloat redOffset = _selRed - _norRed;
    CGFloat greenOffset = _selGreen - _norGreen;
    CGFloat blueOffset = _selBlue - _norBlue;
    UIButton *nextBtn = self.itemScrollView.subviews[self.willSelctedIndex];
    CGFloat lineWidthOffset = nextBtn.frame.size.width - _previousItemFrame.size.width;
    CGFloat lineXOffset = nextBtn.frame.origin.x - _previousItemFrame.origin.x;
    CGRect lineFrame = _previousItemFrame;
    CGFloat x = lineFrame.origin.x;
    CGFloat width = lineFrame.size.width;
    lineFrame.origin.x =  x + prograss *lineXOffset;
    lineFrame.size.width =  width + prograss *lineWidthOffset;
    [nextBtn setTitleColor:[[UIColor alloc] initWithRed:(_norRed + redOffset*prograss)/255.0 green:(_norGreen + greenOffset*prograss)/255.0 blue:(_norBlue + blueOffset*prograss)/255.0 alpha:1] forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:[[UIColor alloc] initWithRed:(_selRed - redOffset*prograss)/255.0 green:(_selGreen - greenOffset*prograss)/255.0 blue:(_selBlue - blueOffset*prograss)/255.0 alpha:1] forState:UIControlStateNormal];
    
    CGFloat centerXOffset = nextBtn.center.x - _segmentWidth/2.0;
    if (nextBtn.center.x  + _segmentWidth/2.0 > self.itemScrollView.contentSize.width)
        centerXOffset = self.itemScrollView.contentSize.width - _segmentWidth;//向后滚
    if (centerXOffset < 0) {//往回滚
        centerXOffset = 0;
    }
    [self.itemScrollView setContentOffset:CGPointMake(_previousItemoffset + (centerXOffset - _previousItemoffset )*prograss , 0)];
    self.selLine.frame = lineFrame;
}

- (void)pageViewScrollEndAnimationCheckColorWithpageView:(HL_PageView *)pageView {
    [self handleItemColor];
}


#pragma mark - 自定义按钮

- (void)didClickItem:(UIButton *)item {
    if (self.pageVcScrollView.isDecelerating || self.pageVcScrollView.isDragging || item == self.selectedButton) return;
    NSInteger index = item.tag;
    self.willSelctedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:SelectedItemCallBackItem:)]) {
        [self.delegate segmentView:self SelectedItemCallBackItem:item];
    }
}

#pragma mark - 私有方法
- (void)setUpUI {
    [self addSubview:self.itemScrollView];
    CGFloat speaceW = 16;
    UIButton *previousBtn = nil;
    for (int i = 0; i < self.titles.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(didClickItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.frame = CGRectMake(10, 0, [self getTextWidthWithString:self.titles[i]], 41);
        }else {
            btn.frame = CGRectMake(CGRectGetMaxX(previousBtn.frame) + speaceW, 0, [self getTextWidthWithString:self.titles[i]], 41);
        }
        previousBtn = btn;
        [self.itemScrollView addSubview:btn];
    }
    [self.itemScrollView setContentSize:CGSizeMake(CGRectGetMaxX(previousBtn.frame) + 10, 0)];
    self.selectedIndex = 0;
}

- (CGFloat)getTextWidthWithString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 41) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.width;
}

- (void)getColorRGBColor:(UIColor *)color IsSelColor:(BOOL)isSelColor {
    
    CGFloat r=0,g=0,b=0,a=0;
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    if (isSelColor) {
        _selRed = r*255.0 ;_selGreen =g*255.0 ;_selBlue = b*255.0;
    }else {
        _norRed = r*255.0 ;_norGreen = g*255.0 ;_norBlue = b*255.0;
    }
}

- (void)handleItemColor {
    self.selLine.frame = CGRectMake(self.selectedButton.frame.origin.x, 41, self.selectedButton.frame.size.width, 3);
    CGFloat centerXOffset = self.selectedButton.center.x - _segmentWidth/2.0;
    if (self.selectedButton.center.x  + _segmentWidth/2.0 > self.itemScrollView.contentSize.width) centerXOffset = self.itemScrollView.contentSize.width - _segmentWidth;//向后滚
    if (centerXOffset < 0) {//往回滚
        centerXOffset = 0;
    }
    [self.itemScrollView setContentOffset:CGPointMake(centerXOffset , 0)];
    _previousItemoffset = self.itemScrollView.contentOffset.x;
    _previousItemFrame = self.selLine.frame;
    
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        }
    }
    [self.selectedButton setTitleColor:self.titleSelColor forState:UIControlStateNormal];
}


#pragma mark - get/set

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.selectedButton = self.itemScrollView.subviews[self.selectedIndex];
    [self handleItemColor];
}

- (void)setTitleNorColor:(UIColor *)titleNorColor {
    _titleNorColor = titleNorColor;
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        }
    }
    [self getColorRGBColor:titleNorColor IsSelColor:NO];
}

- (UIColor *)titleNorColor {
    if (_titleNorColor == nil) {
        UIColor *norColor = [UIColor grayColor];
        [self getColorRGBColor:norColor IsSelColor:NO];
        self.titleNorColor = norColor;
    }
    return _titleNorColor;
}

- (void)setTitleSelColor:(UIColor *)titleSelColor {
    _titleSelColor = titleSelColor;
    [self.selectedButton setTitleColor:titleSelColor forState:UIControlStateNormal];
    [self getColorRGBColor:titleSelColor IsSelColor:YES];
}

- (UIColor *)titleSelColor {
    if (_titleSelColor == nil) {
        UIColor *selColor = [UIColor blackColor];
        [self getColorRGBColor:selColor IsSelColor:YES];
        self.titleSelColor = selColor;
    }
    return _titleSelColor;
}

- (UIScrollView *)itemScrollView {
    if (_itemScrollView != nil) {
        return _itemScrollView;
    }
    _itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _segmentWidth, _segmentHeight)];
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    return _itemScrollView;
}

- (UIView *)selLine {
    if (_selLine != nil) {
        return _selLine;
    }
    _selLine = [[UIView alloc]initWithFrame:CGRectZero];
    _selLine.backgroundColor = [UIColor redColor];
    [self.itemScrollView addSubview:_selLine];
    return _selLine;
}



@end

