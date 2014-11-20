//
//  InterruptedLineView.m
//  iAlarmClock
//
//  Created by Mac on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterruptedLineView.h"
#import "Utilities.h"

@implementation InterruptedLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.alpha = 0.5f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextSetLineWidth(context, 1);
    
    CGFloat dashArray[] = {4, 2, 4, 2};
    CGContextSetLineDash(context, 3, dashArray, 4);

    CGContextAddLineToPoint(context, 295, 0);
    
    [[Utilities currentThemeColor] setStroke];
    
    CGContextStrokePath(context);
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
