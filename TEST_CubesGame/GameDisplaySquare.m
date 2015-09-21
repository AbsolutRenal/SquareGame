//
//  GameDisplaySquare.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 12/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplaySquare.h"
#import "ArrowView.h"
#import "LayerMask.h"

@interface GameDisplaySquare(){
    BOOL _ready;
    BOOL _overArrow;
    BOOL _forceTint;
}

@property (strong, nonatomic)ArrowView *arrow;
@property (strong, nonatomic)UITapGestureRecognizer *tap;
@property (strong, nonatomic)UIView *dotOvelay;
@property (strong, nonatomic)CALayer *maskLayer;
@property (strong, nonatomic)LayerMask *mask;
@property (strong, nonatomic)UIColor *previousOverlayColor;

@end

@implementation GameDisplaySquare


#pragma mark - Instance Public Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched)];
        [self addGestureRecognizer:self.tap];
        
        _ready = NO;
        _overArrow = NO;
        _forceTint = NO;
    }
    return self;
}

- (BOOL)isRight{
    //    NSLog(@"isRight:%i | optional:%i", _isRight, self.optional);
    return _isRight || self.optional;
}

- (void)tintArrow:(BOOL)over animated:(BOOL)animated{
    if(over != _overArrow || _forceTint){
        if(!_ready){
            _forceTint = YES;
            //            return;
        }
        _overArrow = over;
        
        [self.arrow tintOver:over animated:animated];
    }
}

- (void)showDotOverlayColor:(UIColor *)color animated:(BOOL)animated{
    CGRect fram;
    
    if(color){
        if(![color isEqual:self.previousOverlayColor]){
            self.mask.frame = CGRectMake(self.bounds.size.width * .5, -self.bounds.size.height * .5, self.bounds.size.width, self.bounds.size.height);
        }
        
        if([color isEqual:self.itemColor]){
            _isRight = YES;
            self.dotOvelay.backgroundColor = [UIColor colorWithWhite:0. alpha:.3];
        } else {
            _isRight = NO;
            self.dotOvelay.backgroundColor = color;
        }
        fram = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } else {
        _isRight = NO;
        fram = CGRectMake(self.bounds.size.width * .5, -self.bounds.size.height * .5, self.bounds.size.width, self.bounds.size.height);
    }
    
    if(animated){
        [UIView animateWithDuration:.4 animations:^{
            self.mask.frame = fram;
        }];
    } else {
        self.mask.frame = fram;
    }
    
    self.previousOverlayColor = color;
}

- (void)resetPosition{
    [self setPosition:self.initialPosition];
    self.frame = [self getFrame];
    
    self.direction = self.initialDirection;
    [self rotateArrowAnimated:NO];
}

- (void)restoreStateWithPosition:(NSString *)position widthDirection:(NSString *)direction{
    [self setPosition:position];
    [self move];
    
    self.direction = direction;
    [self rotateArrowAnimated:YES];
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
        self.arrow.bounds = CGRectMake(0, 0, self.squareSize / 6, self.squareSize / 3);
        [self addSubview:self.arrow];
        [self rotateArrowAnimated:NO];
    }
    
    self.dotOvelay = [[UIView alloc] init];
    self.dotOvelay.frame = self.bounds;
    self.dotOvelay.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.dotOvelay];
    self.maskLayer = [CALayer layer];
    self.mask = [[LayerMask alloc] initWithFrame:CGRectMake(self.bounds.size.width * .5, -self.bounds.size.height * .5, self.bounds.size.width, self.bounds.size.height)];
    self.mask.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
    self.maskLayer.contents = self.mask;
    self.dotOvelay.layer.mask = self.mask.layer;
    
    _ready = YES;
    
    if(_forceTint){
        [self tintArrow:_overArrow animated:NO];
        _forceTint = NO;
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


#pragma mark - Instance Private Methods

- (void)touched{
//    NSLog(@"TOUCHED");
    
    if(![self.delegate respondsToSelector:@selector(shouldMove)] || [self.delegate shouldMove]){
        if(!_ready)
            return;
        
        _ready = NO;
        
        self.posX += _xSpeed;
        self.posY += _ySpeed;
        
        [self updatePosition];
    }
}

- (void)move{
    _ready = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.frame = [self getFrame];
    } completion:^(BOOL finished) {
        _ready = YES;
    }];
}

@end
