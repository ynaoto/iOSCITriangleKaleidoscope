//
//  LabeledSlider.m
//  CIFilters
//
//  Created by Naoto Yoshioka on 2013/12/23.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "LabeledSlider.h"

@implementation LabeledSlider
{
    UILabel *valueLabel;
}

- (void)setupValueLabel
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h/2)];
    [self addSubview:valueLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupValueLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupValueLabel];
    }
    return self;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    valueLabel.text = [NSString stringWithFormat:@"%g", value];
    return result;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end