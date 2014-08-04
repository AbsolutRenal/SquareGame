//
//  LevelNumberView.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LevelNumberView.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

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
    
    owner.levelNumberView.label.buttonColor = [UIColor turquoiseColor];
    owner.levelNumberView.label.shadowColor = [UIColor greenSeaColor];
    owner.levelNumberView.label.shadowHeight = 3.0f;
    owner.levelNumberView.label.cornerRadius = 6.0f;
    owner.levelNumberView.label.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    owner.levelNumberView.label.titleLabel.text = @"";
    [owner.levelNumberView.label setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [owner.levelNumberView.label setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
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
