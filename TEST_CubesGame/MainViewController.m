//
//  MainViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "MainViewController.h"
#import "LevelViewController.h"
#import "GameViewController.h"
#import "GameDatas.h"

@interface MainViewController (){
    BOOL _ready;
    BOOL _isPlaying;
    
//    UIView *_buttonContainer;
//    UIView *_container;
    
    FUIButton *_levelsButton;
    FUIButton *_resetButton;
    FUIButton *_undoButton;
    
//    GameViewController *_gameVC;
//    LevelViewController *_levelVC;
    
    GameDatas *datas;
}
@property (strong, nonatomic)LevelViewController *levelVC;
@property (strong, nonatomic)GameViewController *gameVC;
@property (strong, nonatomic)UIView *container;
@property (strong, nonatomic)UIView *buttonContainer;
@end

@implementation MainViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

#pragma mark - Instance Public Methods

- (id)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    datas = [[GameDatas alloc] init];
    datas = [GameDatas getInstance];
    
    [self layoutDefaultView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self openGameVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"[MainViewController] -- !!! MEMORY WARNING !!!");
}


#pragma mark - Instance Private Methods

- (void)layoutDefaultView{
    self.container = [[UIView alloc] init];
    [self.view addSubview:self.container];
    
    [self configureButtonContainer];
    
//    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(self.container, self.buttonContainer);
    NSDictionary *viewsDict = @{@"container":self.container, @"buttonContainer":self.buttonContainer};
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.container.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view removeConstraints:self.view.constraints];
//    [self.container removeConstraints:self.container.constraints];
//    [self.buttonContainer removeConstraints:self.buttonContainer.constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonContainer]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container][buttonContainer(55)]|" options:0 metrics:nil views:viewsDict]];
}

- (void)configureButtonContainer{
    self.buttonContainer = [[UIView alloc] init];
    [self.view addSubview:self.buttonContainer];
    self.buttonContainer.backgroundColor = [UIColor turquoiseColor];
    
    self.buttonContainer.layer.borderColor = [UIColor greenSeaColor].CGColor;
    self.buttonContainer.layer.borderWidth = 1.0;
//    self.buttonContainer.layer.cornerRadius = 6.0f;
    
    _undoButton = [self configureButtonWithTitle:@"UNDO"];
    [self.buttonContainer addSubview:_undoButton];
    [_undoButton addTarget:self action:@selector(undoAction) forControlEvents:UIControlEventTouchUpInside];
    
    _resetButton = [self configureButtonWithTitle:@"RESET"];
    [self.buttonContainer addSubview:_resetButton];
    [_resetButton addTarget:self action:@selector(resetLevel) forControlEvents:UIControlEventTouchUpInside];

    _levelsButton = [self configureButtonWithTitle:@"LEVELS"];
    [self.buttonContainer addSubview:_levelsButton];
    [_levelsButton addTarget:self action:@selector(openLevelsVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _undoButton.translatesAutoresizingMaskIntoConstraints = NO;
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    _levelsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *_constrainedView = NSDictionaryOfVariableBindings(_undoButton, _resetButton, _levelsButton);
    [self.buttonContainer removeConstraints:self.buttonContainer.constraints];
    [self.buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:_undoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [self.buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:_undoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.buttonContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_undoButton]-[_resetButton(_undoButton)]-[_levelsButton(_resetButton)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:_constrainedView]];
    
}

- (void)resetLevel{
    [self.gameVC resetLevel];
}

- (void)undoAction{
//    NSLog(@"UNDO ready:%d / levelsVC:%@", _ready, self.levelVC);
    
    if(!_ready)
        return;
    
    if(self.levelVC != nil)
       [self removeLevelsVC];
    else
        [self.gameVC undoLastMove];
}

- (FUIButton *)configureButtonWithTitle:(NSString *)title{
    FUIButton *btn = [[FUIButton alloc] init];
    btn.buttonColor = [UIColor greenSeaColor];
    btn.shadowColor = [UIColor midnightBlueColor];
    btn.shadowHeight = 3.0f;
    btn.cornerRadius = 6.0f;
    btn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateDisabled];
    btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [btn sizeToFit];
    
    return btn;
}

- (void)openGameVC{
    self.gameVC = [[GameViewController alloc] initWithCurrentLevel:datas.currentLevel withDatas:[datas levelDatasForLevel:datas.currentLevel]];
    self.gameVC.delegate = self;
    [self showViewController:self.gameVC];
}

- (void)openLevelsVC{
    if(!_ready)
        return;
    
    _ready = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        self.gameVC.view.alpha = 0;
    }];
    
    [_undoButton setTitle:@"BACK" forState:UIControlStateNormal];
    [_undoButton setTitle:@"BACK" forState:UIControlStateHighlighted];
    
    _resetButton.hidden = YES;
    _levelsButton.hidden = YES;
    
    self.levelVC = [[LevelViewController alloc] initWithCurrentLevel:datas.currentLevel withNbLevel:(int)[datas nbLevels] withLastCompleted:[datas lastLevel]];
    self.levelVC.delegate = self;
    
    self.levelVC.view.alpha = 0.;
    self.levelVC.view.frame = CGRectMake(self.container.frame.origin.x + self.container.frame.size.width, self.container.frame.origin.y, self.container.frame.size.width, self.container.frame.size.height);
    
//    [self.levelVC willMoveToParentViewController:self];
    [self.container addSubview:self.levelVC.view];
    [self addChildViewController:self.levelVC];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.levelVC.view.alpha = 1.;
        weakSelf.levelVC.view.frame = self.container.frame;
    } completion:^(BOOL finished){
        _ready = YES;
    }];
    
    [self.levelVC didMoveToParentViewController:self];
}

- (void)removeLevelsVC{
    _ready = NO;
    
    [self.levelVC close];
    [UIView animateWithDuration:.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.levelVC.view.alpha = 0.;
        self.levelVC.view.frame = CGRectMake(self.container.frame.origin.x + self.container.frame.size.width, self.container.frame.origin.y, self.container.frame.size.width, self.container.frame.size.height);
    } completion:^(BOOL finished) {
        [self.levelVC willMoveToParentViewController:nil];
        
//        NSLog(@"VIEW:%@ | SUPERVIEW:%@", self.levelVC.view, self.levelVC.view.superview);
//        [self.levelVC.view removeFromSuperview];
        [self.levelVC removeFromParentViewController];
        [self.levelVC didMoveToParentViewController:nil];
        self.levelVC = nil;
        
        [_undoButton setTitle:@"UNDO" forState:UIControlStateNormal];
        [_undoButton setTitle:@"UNDO" forState:UIControlStateHighlighted];
        
        _resetButton.hidden = NO;
        _levelsButton.hidden = NO;
        
        _ready = YES;
        
        [UIView animateWithDuration:.2 animations:^{
            self.gameVC.view.alpha = 1;
        }];
    }];
    
}

- (void)showViewController:(UIViewController *)child{
//    [child willMoveToParentViewController:self];
    
    child.view.frame = self.container.frame;
//    NSLog(@"CONTAINER FRAME:%f", self.container.frame.size.height);
    child.view.alpha = 0;
    [self.container addSubview:child.view];
    [self addChildViewController:child];
    
    [UIView animateWithDuration:.6 animations:^{
        child.view.alpha = 1;
    } completion:^(BOOL finished) {
        _ready = YES;
    }];
    
    [child didMoveToParentViewController:self];
}


#pragma mark - Delegate Methods

- (void)launchLevel:(int)level{
    datas.currentLevel = level;
    //    NSLog(@"[MAIN_VIEW_CONTROLLER] -(void)launchLevel:%i", level);
    
    [self removeLevelsVC];
    [self.gameVC startLevel:level withDatas:[datas levelDatasForLevel:level]];
}

- (void)completeLevel{
    //    NSLog(@"COMPLETE LEVEL");
    
    if([datas switchToNExtLevel]){
        //        NSLog(@"-- LAUNCH NEXT");
        [self launchLevel:datas.currentLevel];
    } else {
        //        NSLog(@"-- CONGRATULATE")
        [self.gameVC congratulate];
    }
}

@end
