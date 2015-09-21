//
//  GameViewController.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDisplaySquare.h"
#import "GameDisplayDot.h"
#import "GameDisplayArrow.h"

@protocol GameViewControllerDelegate <NSObject>

- (void)completeLevel;

@end

@interface GameViewController : UIViewController<GameDisplaySquareProtocol>

- (instancetype)initWithCurrentLevel:(int)level withDatas:(NSDictionary *)levelDatas;
- (void)startLevel:(int)level withDatas:(NSDictionary *)levelDatas;
- (void)resetLevel;
- (void)undoLastMove;
- (void)congratulate;

@property (strong, nonatomic) id<GameViewControllerDelegate> delegate;

@end
