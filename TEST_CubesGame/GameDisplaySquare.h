//
//  GameDisplaySquare.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 12/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDisplayArrow.h"

@protocol GameDisplaySquareProtocol <NSObject>

@required
- (void)squareMoved:(GameDisplayItem *)square;

@optional
- (BOOL)shouldMove;

@end

@interface GameDisplaySquare : GameDisplayArrow

@property (strong, nonatomic)id<GameDisplaySquareProtocol> delegate;
@property (assign, nonatomic)BOOL isRight;
@property (assign, nonatomic)int xSpeed;
@property (assign, nonatomic)int ySpeed;
@property (assign, nonatomic)BOOL optional;

- (void)rotateArrowAnimated:(BOOL)animated;
- (void)updatePosition;
- (void)resetPosition;
- (void)restoreStateWithPosition:(NSString *)position widthDirection:(NSString *)direction;
- (void)tintArrow:(BOOL)over animated:(BOOL)animated;
- (void)showDotOverlayColor:(UIColor *)color animated:(BOOL)animated;

@end
