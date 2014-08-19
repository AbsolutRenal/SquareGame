//
//  ArrowView.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 13/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "ArrowView.h"

@interface ArrowView(){
    BOOL _ready;
}

@property (strong, nonatomic)UIColor *color;
@property (strong, nonatomic)UIColor *currentTint;

@end

@implementation ArrowView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        self.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
//    }
//    return self;
//}

- (instancetype)initWithColor:(UIColor *)color{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
        self.color = color;
        self.currentTint = color;
    }
    return self;
}

- (void)tintColorDidChange{
    [self setNeedsDisplay];
}

- (void)tintOver:(BOOL)over animated:(BOOL)animated{
    UIColor *tint = (over)? [UIColor colorWithWhite:0. alpha:.3] : [UIColor colorWithWhite:1. alpha:1.] ;
    self.currentTint = tint;
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            self.tintColor = tint;
        }];
    } else {
        self.tintColor = tint;
    }
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
//    if(!_ready){
//        [super drawRect:rect];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextBeginPath(ctx);
        
        CGContextMoveToPoint(ctx, self.bounds.size.width, self.bounds.size.height * .5);
        CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
        CGContextAddLineToPoint(ctx, 0, 0);
        
        CGContextClosePath(ctx);
        CGContextSetFillColorWithColor(ctx, self.currentTint.CGColor);
        
        CGContextDrawPath(ctx, kCGPathFill);
        _ready = YES;
        
//        NSLog(@"-- [FRAME] x:%f / y:%f", self.frame.origin.x, self.frame.origin.y);
//        NSLog(@"---- [BOUNDS] x:%f / y:%f", self.frame.origin.x, self.frame.origin.y);
//        NSLog(@"DRAW ARROW VIEW --- W:%f H:%f", self.bounds.size.width, self.bounds.size.height);
//    }

}

@end
