//
//  LayerMask.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 18/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LayerMask.h"

@implementation LayerMask

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, self.bounds.size.width * .5, 0);
    CGContextAddCurveToPoint(ctx, self.bounds.size.width * .85, 0, self.bounds.size.width, self.bounds.size.height * .15, self.bounds.size.width, self.bounds.size.height * .5);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
    CGContextMoveToPoint(ctx, self.bounds.size.width * .5, 0);
    
//    CGContextMoveToPoint(ctx, 0, 0);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width - self.bounds.size.width * .5, 0);
//    CGContextAddCurveToPoint(ctx, self.bounds.size.width * .85, 0, self.bounds.size.width, self.bounds.size.height * .15, self.bounds.size.width, self.bounds.size.width * .5);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
//    CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
//    CGContextAddLineToPoint(ctx, 0, 0);
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    CGContextDrawPath(ctx, kCGPathFill);
}


@end
