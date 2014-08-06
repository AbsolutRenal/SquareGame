//
//  GameViewController.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameViewControllerDelegate <NSObject>



@end

@interface GameViewController : UIViewController

- (instancetype)initWithCurrentLevel:(int)level;
- (void)startLevel:(int)level;
@property (strong, nonatomic) id<GameViewControllerDelegate> delegate;

@end
