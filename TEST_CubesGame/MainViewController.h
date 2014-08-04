//
//  MainViewController.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelViewController.h"
#import "FUIAlertView.h"

@interface MainViewController : UIViewController <LevelViewControllerDelegate, FUIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;

@end
