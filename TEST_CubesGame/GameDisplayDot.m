//
//  GameDisplayDot.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 12/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplayDot.h"

@implementation GameDisplayDot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSLog(@"DRAW DOT");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextAddEllipseInRect(ctx, CGRectMake(20, 20, self.squareSize - 40, self.squareSize - 40));
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.itemColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
}

@end
