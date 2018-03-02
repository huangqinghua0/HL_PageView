//
//  HL_SegmentView.m
//  pageDemo
//
//  Created by 黄清华 on 2018/3/2.
//  Copyright © 2018年 zjht_macos. All rights reserved.
//

#import "HL_SegmentView.h"

@interface HL_SegmentView ()
@property (nonatomic, strong) UIScrollView *itemScrollView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *selLine;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation HL_SegmentView {
    CGFloat _previousItemoffset;
    CGRect _previousItemFrame;
    CGFloat _norRed , _norGreen , _norBlue;
    CGFloat _selRed , _selGreen , _selBlue;
    UIColor *_titleNorColor , *_titleSelColor;
    CGFloat _segmentWidth;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        _segmentWidth = frame.size.width;
        [self setUpUI];
    }
    return self;
}

#pragma mark - 自定义按钮

- (void)didClickItem:(UIButton *)item {
//    if (self.pageVcScrollView.isDecelerating) return;
//    NSInteger index = item.tag;
//    self.willSelctedIndex = index;
//    NSInteger direction = index - self.selectedIndex;
//    UIViewController *vc = self.childControllers[index];
//    [self.pageViewController setViewControllers:@[vc] direction:direction < 0 animated:YES completion:nil];
//    _isClickItem = YES;
}


#pragma mark 私有方法

- (void)setUpUI {
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


#pragma mark set/get

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.selectedButton setTitleColor:self.titleNorColor forState:UIControlStateNormal];
    UIButton *btn = self.itemScrollView.subviews[selectedIndex];
    [btn setTitleColor:self.titleSelColor forState:UIControlStateNormal];
    self.selLine.frame = CGRectMake(btn.frame.origin.x, 41, btn.frame.size.width, 3);
    self.selectedButton = btn;
    CGFloat centerXOffset = btn.center.x - _segmentWidth/2.0;
    if (btn.center.x  + _segmentWidth/2.0 > self.itemScrollView.contentSize.width) centerXOffset = self.itemScrollView.contentSize.width - _pageWidth;//向后滚
    if (centerXOffset < 0) {//往回滚
        centerXOffset = 0;
    }
    [self.itemScrollView setContentOffset:CGPointMake(centerXOffset , 0)];
    _previousItemoffset = self.itemScrollView.contentOffset.x;
    _previousItemFrame = self.selLine.frame;
}

- (UIScrollView *)itemScrollView {
    if (_itemScrollView != nil) {
        return _itemScrollView;
    }
    _itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _segmentWidth, 44)];
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    return _itemScrollView;
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
