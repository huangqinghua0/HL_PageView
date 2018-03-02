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
    CGFloat _norRed , _norGreen , _norBlue;
    CGFloat _selRed , _selGreen , _selBlue;
    UIColor *_titleNorColor , *_titleSelColor;
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



- (void)setTitleNorColor:(UIColor *)titleNorColor {
    _titleNorColor = titleNorColor;
    for (UIButton *btn in self.itemScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn != self.selectedButton) [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        }
    }
    [self getColorRGBColor:titleNorColor IsSelColor:NO];
}

#pragma mark set/get

- (UIScrollView *)itemScrollView {
    if (_itemScrollView != nil) {
        return _itemScrollView;
    }
    _itemScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _pageWidth, 44)];
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    return _itemScrollView;
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
