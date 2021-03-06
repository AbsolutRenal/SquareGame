//
//  LevelViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LevelViewController.h"
#import "LevelNumberView.h"

@interface LevelViewController (){
    int _currentLevel;
    int _nbLevels;
    int _lastLevel;
    
    int _maxRows;
    int _nbLevelByPage;
    int _startLevel;
    int _clickedLevel;
    
    CGFloat _itemWidth;
    CGFloat _itemHeight;
    int _minOffset;
    double _offset;
    double _startOffsetY;
    int _nbColumns;
    int _nbRows;
    
//    NSMutableArray *_levelButtons;
//    
//    UIView *_titleView;
}

@property (strong, nonatomic)FUIButton *nextButton;
@property (strong, nonatomic)FUIButton *prevButton;
@property (strong, nonatomic)NSMutableArray *levelButtons;
@property (strong, nonatomic)UIView *titleView;

@end

@implementation LevelViewController


#pragma mark - Instance Public Methods

- (id)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (instancetype)initWithCurrentLevel:(int)current withNbLevel:(int)nb withLastCompleted:(int)last{
    
    self = [super init];
    
//    NSLog(@"[LEVEL_VIEW_CONTROLLER] -(instancetype)initWithCurrentLevel:%i withNbLevel:%i withLastCompleted:%i", current, nb, last);
    
    if(self){
        _currentLevel = current;
        _nbLevels = nb;
        _lastLevel = last;
        _maxRows = 4;
        self.levelButtons = [[NSMutableArray alloc] init];
        _nbLevelByPage = 0;
        _itemWidth = 40.0;
        _itemHeight = 40.0;
        _minOffset = 20;
    }
    
//    NSLog(@"current:%d, nb:%d, last:%d", current, nb, last);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configureView];
    
    _startLevel = _currentLevel - (_currentLevel % _nbLevelByPage);
    [self populateFromLevel:_startLevel];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:.2 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.titleView.alpha = 1.;
        self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.titleView.frame.size.height);
    } completion:nil];
}

- (void)close{
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.titleView.alpha = 0.;
        self.titleView.frame = CGRectMake(0, -80, self.view.frame.size.width, self.titleView.frame.size.height);
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"[LevelViewController] -- !!! MEMORY WARNING !!!");
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    if(parent == nil){
        for (LevelNumberView *button in self.levelButtons) {
            if(self.view && [self.view.subviews containsObject:button]){
//                NSLog(@"-- button:%@", button);
                [button removeFromSuperview];
            }
        }
        self.levelButtons = nil;
        [self.titleView removeFromSuperview];
        self.titleView = nil;
        [self.view removeFromSuperview];
        self.delegate = nil;
    }
}


#pragma mark - Instance Private Methods

- (void)clearLevelButtons{
    LevelNumberView *button;
    while (self.levelButtons.count > 0) {
        button = (LevelNumberView *)self.levelButtons[0];
        [button removeFromSuperview];
        [self.levelButtons removeObjectAtIndex:0];
    }
}

- (void)showNextLevels:(id)sender{
    _startLevel += _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)showPreviousLevels:(id)sender{
    _startLevel -= _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)configureView{
    self.view.backgroundColor = [UIColor colorWithWhite:1. alpha:.8];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, -80, self.view.frame.size.width, 80)];
    self.titleView.backgroundColor = [UIColor turquoiseColor];
    [self.view addSubview:self.titleView];
    self.titleView.alpha = 0;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldFlatFontOfSize:18];
    titleLabel.text = @"LEVELS";
    titleLabel.textColor = [UIColor cloudsColor];
    titleLabel.backgroundColor = [UIColor colorWithWhite:0. alpha:0.];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.titleView.frame.size.width * .5, (self.titleView.frame.size.height - 10) * .5  + 10);
    [self.titleView addSubview:titleLabel];
    
    
    self.nextButton = [[FUIButton alloc] init];
    [self.nextButton setTitle:@">" forState:UIControlStateNormal];
    [self.nextButton setTitle:@">" forState:UIControlStateHighlighted];
    self.nextButton.buttonColor = [UIColor turquoiseColor];
    self.nextButton.shadowColor = [UIColor greenSeaColor];
    self.nextButton.shadowHeight = 3.0f;
    self.nextButton.cornerRadius = 20.0f;
    self.nextButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.nextButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.nextButton sizeToFit];
    self.nextButton.frame = CGRectMake(self.view.frame.size.width - self.nextButton.frame.size.width - 50, self.view.frame.size.height - self.nextButton.frame.size.height - 20, self.nextButton.frame.size.width, self.nextButton.frame.size.height);
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(showNextLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    self.prevButton = [[FUIButton alloc] init];
    [self.prevButton setTitle:@"<" forState:UIControlStateNormal];
    [self.prevButton setTitle:@"<" forState:UIControlStateHighlighted];
    self.prevButton.buttonColor = [UIColor turquoiseColor];
    self.prevButton.shadowColor = [UIColor greenSeaColor];
    self.prevButton.shadowHeight = 3.0f;
    self.prevButton.cornerRadius = 20.0f;
    self.prevButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.prevButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.prevButton sizeToFit];
    self.prevButton.frame = CGRectMake(50, self.view.frame.size.height - self.prevButton.frame.size.height - 20, self.prevButton.frame.size.width, self.prevButton.frame.size.height);
    [self.view addSubview:self.prevButton];
    [self.prevButton addTarget:self action:@selector(showPreviousLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    _nbColumns = floor(self.view.bounds.size.width / ((_itemWidth + _minOffset) + _minOffset));
    _offset = (self.view.bounds.size.width - (_itemWidth * _nbColumns)) / (_nbColumns +1);
    
    _nbRows = floor(self.view.bounds.size.height / ((_itemHeight + _offset) + _offset));
    _startOffsetY = (self.view.bounds.size.height - (_nbRows * (_itemHeight + _offset) - _offset)) * .5;
    
    _nbLevelByPage = _nbRows * _nbColumns;
}

- (void)populateFromLevel:(int)startLevel{
    _startLevel = startLevel;
    if(startLevel == 0)
        self.prevButton.hidden = YES;
    else
        self.prevButton.hidden = NO;
    
    self.nextButton.hidden = YES;
    
    int currentRow;
    LevelNumberView *level;
    
    for (int i = startLevel; i < _nbLevels; i++) {
        currentRow = floor((i - startLevel) / _nbColumns);
        
        if(currentRow >= _nbRows){
            self.nextButton.hidden = NO;
            break;
        }
        
        if((i - startLevel) < self.levelButtons.count){
            level = self.levelButtons[i-startLevel];
            level.hidden = NO;
        } else {
            level = [LevelNumberView presentInViewController:self];
            [self.levelButtons addObject:level];
            level.frame = CGRectMake(_offset + ((i - startLevel) % _nbColumns) * (_itemWidth + _offset), _startOffsetY + (currentRow * (_itemHeight + _offset)), _itemWidth, _itemHeight);
//            NSLog(@"LEVEL_FRAME: %@", NSStringFromCGRect(level.frame));
        }
        
        
        if(i <= _lastLevel){
            level.label.enabled = YES;
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateHighlighted];
            
            [level shouldSelect:i == _currentLevel ];
        } else {
            level.label.enabled = NO;
            [level.label setTitle:@"." forState:UIControlStateNormal];
            [level.label setTitle:@"." forState:UIControlStateHighlighted];
        }
    }
    
    if((_nbLevels - startLevel) < self.levelButtons.count){
        for(int j = _nbLevels - startLevel; j < _nbLevelByPage; j++){
            ((LevelNumberView *)self.levelButtons[j]).hidden = YES;
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
    
    int currentRow;
    for (int i = _startLevel; i < _nbLevels; i++) {
        currentRow = floor((i - _startLevel) / _nbColumns);
        
        if(currentRow >= _nbRows){
            self.nextButton.hidden = NO;
            break;
        }
        
        ((LevelNumberView *)self.levelButtons[i-_startLevel]).frame = CGRectMake(_offset + ((i - _startLevel) % _nbColumns) * (_itemWidth + _offset), _startOffsetY + (currentRow * (_itemHeight + _offset)), _itemWidth, _itemHeight);
    }
    
    [super viewDidLayoutSubviews];
}


#pragma mark - Delegate Methods

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != alertView.cancelButtonIndex){
        _currentLevel = _clickedLevel;
        
        [self.delegate launchLevel:_clickedLevel];
    }
}

- (void)selectLevel:(int)nb{
    //    NSLog(@"SELECT LEVEL %d / CURRENT:%d", nb, _currentLevel);
    _clickedLevel = nb;
    
    if(nb != _currentLevel){
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                              message:@"You are about to reset the level you were playing"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Confirm", nil];
        alertView.titleLabel.textColor = [UIColor cloudsColor];
        alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        alertView.messageLabel.textColor = [UIColor cloudsColor];
        alertView.messageLabel.font = [UIFont flatFontOfSize:14];
        alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        alertView.defaultButtonColor = [UIColor cloudsColor];
        alertView.defaultButtonShadowColor = [UIColor asbestosColor];
        alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        alertView.defaultButtonTitleColor = [UIColor asbestosColor];
        [alertView show];
    } else {
        [self.delegate launchLevel:_clickedLevel];
    }
}



@end
