//
//  GameDisplayItem.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 11/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplayItem.h"
#import "GameDatas.h"

@interface GameDisplayItem(){
    NSString *_position;
}
@end

@implementation GameDisplayItem

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

- (CGRect)getFrame{
    return CGRectMake((_posX * _squareSize) + _offsetX, (_posY * _squareSize) + _offsetY, _squareSize, _squareSize);
}

- (void)setPosition:(NSString *)position{
    _position = position;
    
    if(!_initialPosition)
        _initialPosition = _position;
    
    NSArray *pos = [_position  componentsSeparatedByString:@","];
    _posX = [pos[0] intValue];
    _posY = [pos[1] intValue];
}

- (NSString *)position{
    return _position = [NSString stringWithFormat:@"%i,%i", _posX, _posY];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
//    NSLog(@"[GAME_DISPLAY_ITEM] -(void)willMoveToSuperView:");
//    NSLog(@"--- posX:%i / posY:%i / squareSize:%i", _posX, _posY, _squareSize);
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview){
        self.frame = [self getFrame];
        self.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
    }
}

- (void)setColor:(NSString *)color{
    _color = color;
    
    _itemColor = [GameDatas colorWithName:_color];
}

- (void)didMoveToSuperview{
    if(!self.superview){
//        NSLog(@"-- CLEAN ITEM");
        self.itemColor = nil;
//        self.position = nil;
//        self.color = nil;
//        self.type = nil;
    }
}

@end
