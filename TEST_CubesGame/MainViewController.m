//
//  MainViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "MainViewController.h"
#import "LevelViewController.h"

@interface MainViewController (){
    BOOL _ready;
    NSString *_levelsFile;
    NSArray *_levelsDescription;
    NSDictionary *_colors;
    int _currentLevel;
    int _clickedLevel;
    BOOL _isPlaying;
    
    UIView *_buttonContainer;
    UIView *_container;
    
    FUIButton *_levelsButton;
    FUIButton *_resetButton;
    FUIButton *_undoButton;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *tmpDict = [NSDictionary dictionaryWithContentsOfFile:[self levelsFile]];
    _levelsDescription = tmpDict[@"levels"];
    _colors = tmpDict[@"colors"];
    _currentLevel = [self lastLevel];
    
    [self layoutDefaultView];
}

- (void)layoutDefaultView{
    _container = [[UIView alloc] init];
    [self.view addSubview:_container];
    
    [self configureButtonContainer];
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_container, _buttonContainer);
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    _container.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view removeConstraints:self.view.constraints];
//    [_container removeConstraints:_container.constraints];
//    [_buttonContainer removeConstraints:_buttonContainer.constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_container]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonContainer]|" options:0 metrics:nil views:viewsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_container][_buttonContainer(55)]|" options:0 metrics:nil views:viewsDict]];
}

- (void)configureButtonContainer{
    _buttonContainer = [[UIView alloc] init];
    [self.view addSubview:_buttonContainer];
    _buttonContainer.backgroundColor = [UIColor turquoiseColor];
    
    _buttonContainer.layer.borderColor = [UIColor greenSeaColor].CGColor;
    _buttonContainer.layer.borderWidth = 1.0;
//    _buttonContainer.layer.cornerRadius = 6.0f;
    
    _undoButton = [self configureButtonWithTitle:@"UNDO"];
    [_buttonContainer addSubview:_undoButton];
    
    _resetButton = [self configureButtonWithTitle:@"RESET"];
    [_buttonContainer addSubview:_resetButton];

    _levelsButton = [self configureButtonWithTitle:@"LEVELS"];
    [_buttonContainer addSubview:_levelsButton];
    
    
    _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _undoButton.translatesAutoresizingMaskIntoConstraints = NO;
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    _levelsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *_constrainedView = NSDictionaryOfVariableBindings(_undoButton, _resetButton, _levelsButton);
    [_buttonContainer removeConstraints:_buttonContainer.constraints];
    [_buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:_undoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_buttonContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [_buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:_undoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_buttonContainer attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [_buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_undoButton]-[_resetButton(_undoButton)]-[_levelsButton(_resetButton)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:_constrainedView]];
    
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

- (void)openLevelsVC{
    LevelViewController *levelsVC = [[LevelViewController alloc] initWithCurrentLevel:_currentLevel withNbLevel:(int)_levelsDescription.count withLastCompleted:_currentLevel];
    levelsVC.delegate = self;
    [self showViewController:levelsVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showViewController:(UIViewController *)child{
//    [child willMoveToParentViewController:self];
    
    child.view.frame = _container.frame;
//    NSLog(@"CONTAINER FRAME:%f", self.container.frame.size.height);
    child.view.alpha = 0;
    [_container addSubview:child.view];
    [self addChildViewController:child];
    
    [UIView animateWithDuration:.6 animations:^{
        child.view.alpha = 1;
    } completion:^(BOOL finished) {
        _ready = YES;
    }];
    
    [child didMoveToParentViewController:self];
}

- (NSString *)levelsFile{
    if(!_levelsFile){
        _levelsFile = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    }
    return _levelsFile;
}

- (int)lastLevel{
    int nb = (int)_levelsDescription.count;
    int i;
    BOOL completed;
    
    for (i = 0; i < nb; i++) {
        //        NSLog(@"i:%d, COMPLETED:%@", i, _levelsDescription[i][@"completed"]);
        completed = [_levelsDescription[i][@"completed"]  isEqual:@1];
        if(!completed){
            return i;
        }
    }
    return i;
}

- (void)launchLevel:(int)level{
    _currentLevel = level;
    
    NSLog(@"LAUNCH LEVEL %d", level);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self openLevelsVC];
}

@end
