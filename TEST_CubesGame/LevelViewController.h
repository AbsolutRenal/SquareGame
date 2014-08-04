//
//  LevelViewController.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelNumberView.h"
#import "FUIAlertView.h"

@protocol LevelViewControllerDelegate <NSObject>

@required
- (void)launchLevel:(int)level;

@end

@interface LevelViewController : UIViewController <LevelNumberViewDelegate, FUIAlertViewDelegate>

@property (strong, nonatomic) id<LevelViewControllerDelegate> delegate;

- (instancetype)initWithCurrentLevel:(int)current withNbLevel:(int)nb withLastCompleted:(int)last;

@end