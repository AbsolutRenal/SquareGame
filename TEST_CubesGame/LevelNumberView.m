//
//  LevelNumberView.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LevelNumberView.h"

@implementation LevelNumberViewOwner
@end

@interface LevelNumberView ()
@property (strong, nonatomic) UIViewController <LevelNumberViewDelegate> *delegateViewController;
@end

@implementation LevelNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)presentInViewController:(UIViewController <LevelNumberViewDelegate>*)controller{
    // Instantiating encapsulated here.
    LevelNumberViewOwner *owner = [LevelNumberViewOwner new];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:owner options:nil];
    
    // Pass in a reference of the viewController.
    owner.levelNumberView.delegateViewController = controller;
    
    // Add (thus retain).
    [controller.view addSubview:owner.levelNumberView];
    
    return owner.levelNumberView;
}

- (IBAction)selectLevel:(UIButton *)sender{
    NSLog(@"-- SELECT : %@", self.label.titleLabel.text);
    
    if(![self.label.titleLabel.text isEqualToString:@"."])
        [self.delegateViewController selectLevel:[self.label.titleLabel.text intValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
