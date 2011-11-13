//
//  PCBorderView.m
//  PerfectCrossfade
//
//  Created by Eric-Paul Lecluse on 13-11-11.
//  Copyright (c) 2011 epologee. All rights reserved.
//

#import "PCBorderView.h"

@implementation PCBorderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [[[UIColor blueColor] colorWithAlphaComponent:0.3] setFill];
    CGContextFillRect(context, rect);

    CGRect inside = CGRectInset(rect, 10, 10);
    CGContextClearRect(context, inside);
}


@end
