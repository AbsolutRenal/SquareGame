//
//  GameDisplayArrow.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 12/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplayArrow.h"
#import "ArrowView.h"

@interface GameDisplayArrow()

@property (strong, nonatomic)ArrowView *arrow;

@end

@implementation GameDisplayArrow

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
    
    if(!self.arrow){
        self.arrow = [[ArrowView alloc] init];
        self.arrow.bounds = CGRectMake(0, 0, self.squareSize / 8, self.squareSize / 4);
        [self addSubview:self.arrow];
        [self rotateArrow];
    }
}

- (void)rotateArrow{
    CGFloat angle;
    objswitch(self.direction)
    objcase(@"l"){
        angle = M_PI;
    };
    objcase(@"t"){
        angle = -M_PI * .5;
    };
    objcase(@"r"){
        angle = 0;
    };
    objcase(@"b"){
        angle = M_PI * .5;
    };
    defaultcase{
        angle = 0.;
        NSLog(@"NONE");
    };
    endswitch

    _arrow.transform =  CGAffineTransformMakeRotation(angle);
    _arrow.frame = CGRectMake((self.bounds.size.width - _arrow.frame.size.width) * .5, (self.bounds.size.height - _arrow.frame.size.height) * .5, _arrow.frame.size.width, _arrow.frame.size.height);
}

@end
