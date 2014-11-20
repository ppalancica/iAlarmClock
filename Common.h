//
//  Common.h
//  iAlarmClock
//
//  Created by Mac on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, 
                        CGRect rect, 
                        CGColorRef startColor, 
                        CGColorRef endColor);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, 
                   CGPoint startPoint, 
                   CGPoint endPoint, 
                   CGColorRef color);