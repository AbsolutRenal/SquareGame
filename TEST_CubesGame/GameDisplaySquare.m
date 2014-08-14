//
//  GameDisplaySquare.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 12/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplaySquare.h"
#import "ArrowView.h"

@interface GameDisplaySquare(){
    BOOL _ready;
}

@property (strong, nonatomic)ArrowView *arrow;
@property (strong, nonatomic)UITapGestureRecognizer *tap;
@end

@implementation GameDisplaySquare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched)];
        [self addGestureRecognizer:self.tap];
        
        _ready = YES;
    }
    return self;
}

- (void)touched{
//    NSLog(@"TOUCHED");
    
    if(!_ready)
        return;
    
    _ready = NO;
    
    self.posX += _xSpeed;
    self.posY += _ySpeed;
    
    [self updatePosition];
}

- (void)move{
    _ready = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = [self getFrame];
    } completion:^(BOOL finished) {
        _ready = YES;
    }];
}

- (void)resetPosition{
    [self setPosition:self.initialPosition];
    self.frame = [self getFrame];
    
    self.direction = self.initialDirection;
    [self rotateArrowAnimated:NO];
}

- (void)moveToPosition:(NSString *)position{
    [self setPosition:position];
    [self move];
}

- (void)updatePosition{
    [self move];
    [self.delegate squareMoved:self];
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
//    [super drawRect:rect];
    
//    NSLog(@"ARROW:%@ \\ %@", _arrow, self);
    
//    NSLog(@"DRAW SQUARE");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextAddRect(ctx, self.bounds);
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.itemColor.CGColor);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    if(!self.arrow){
//        NSLog(@"ADD ARROW");
        self.arrow = [[ArrowView alloc] initWithColor:[UIColor whiteColor]];
        self.arrow.bounds = CGRectMake(0, 0, self.squareSize / 8, self.squareSize / 4);
        [self addSubview:self.arrow];
        [self rotateArrowAnimated:NO];
    }
}

- (void)rotateArrowAnimated:(BOOL)animated{
    CGFloat angle;
    objswitch(self.direction)
    objcase(@"l"){
        angle = M_PI;
        _xSpeed = -1;
        _ySpeed = 0;
    };
    objcase(@"t"){
        angle = -M_PI * .5;
        _xSpeed = 0;
        _ySpeed = -1;
    };
    objcase(@"r"){
        angle = 0;
        _xSpeed = 1;
        _ySpeed = 0;
    };
    objcase(@"b"){
        angle = M_PI * .5;
        _xSpeed = 0;
        _ySpeed = 1;
    };
    defaultcase{
        angle = 0.;
        NSLog(@"NONE");
        _xSpeed = 0;
        _ySpeed = 0;
    };
    endswitch
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            _arrow.transform =  CGAffineTransformMakeRotation(angle);
//            _arrow.center = self.center;
            _arrow.frame = CGRectMake((self.bounds.size.width - _arrow.frame.size.width) * .5, (self.bounds.size.height - _arrow.frame.size.height) * .5, _arrow.frame.size.width, _arrow.frame.size.height);
        }];
    } else {
        _arrow.transform =  CGAffineTransformMakeRotation(angle);
//        _arrow.center = self.center;
        _arrow.frame = CGRectMake((self.bounds.size.width - _arrow.frame.size.width) * .5, (self.bounds.size.height - _arrow.frame.size.height) * .5, _arrow.frame.size.width, _arrow.frame.size.height);
    }
}

- (void)didMoveToSuperview{
    if(!self.superview){
//        NSLog(@"--[SUB CLASS] CLEAN ITEM");
        [self.arrow removeFromSuperview];
        self.arrow = nil;
        self.delegate = nil;
        [self removeGestureRecognizer:self.tap];
    }
}

@end
