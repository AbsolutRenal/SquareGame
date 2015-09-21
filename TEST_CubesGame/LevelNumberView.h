//
//  LevelNumberView.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LevelNumberView;

@interface LevelNumberViewOwner : NSObject
@property (weak, nonatomic) IBOutlet LevelNumberView *levelNumberView;
@end

@protocol LevelNumberViewDelegate <NSObject>
@required
- (void)selectLevel:(int)nb;
@end

@interface LevelNumberView : UIView
@property (weak, nonatomic)IBOutlet FUIButton *label;
+ (instancetype)presentInViewController:(UIViewController <LevelNumberViewDelegate>*)controller;
- (IBAction)selectLevel:(UIButton *)sender;
- (void)shouldSelect:(BOOL)should;
@end
