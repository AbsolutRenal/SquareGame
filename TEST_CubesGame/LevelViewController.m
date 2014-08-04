//
//  LevelViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LevelViewController.h"
#import "LevelNumberView.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

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
    
    NSMutableArray *_levelButtons;
}

@property (strong, nonatomic)FUIButton *nextButton;
@property (strong, nonatomic)FUIButton *prevButton;

@end

@implementation LevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCurrentLevel:(int)current withNbLevel:(int)nb withLastCompleted:(int)last{
    
    self = [super init];
    
    if(self){
        _currentLevel = current;
        _nbLevels = nb;
        _lastLevel = last;
        _maxRows = 4;
        _levelButtons = [[NSMutableArray alloc] init];
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
    
//    NSLog(@"LEVELS NAMES:%@", self.levelNames);
    
    
}

- (void)clearLevelButtons{
    for (LevelNumberView *button in _levelButtons) {
        [button removeFromSuperview];
    }
    
    _levelButtons = [[NSMutableArray alloc] init];
}

- (void)showNextLevels:(id)sender{
//    NSLog(@"NEXT");
    _startLevel += _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)showPreviousLevels:(id)sender{
//    NSLog(@"PREVIOUS");
    _startLevel -= _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)configureView{
    self.nextButton = [[FUIButton alloc] init];
    [self.nextButton setTitle:@"NEXT >" forState:UIControlStateNormal];
    [self.nextButton setTitle:@"NEXT >" forState:UIControlStateHighlighted];
    self.nextButton.buttonColor = [UIColor turquoiseColor];
    self.nextButton.shadowColor = [UIColor greenSeaColor];
    self.nextButton.shadowHeight = 3.0f;
    self.nextButton.cornerRadius = 6.0f;
    self.nextButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.nextButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.nextButton sizeToFit];
    self.nextButton.frame = CGRectMake(self.view.frame.size.width - self.nextButton.frame.size.width - 20, self.view.frame.size.height - self.nextButton.frame.size.height - 20, self.nextButton.frame.size.width, self.nextButton.frame.size.height);
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(showNextLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    self.prevButton = [[FUIButton alloc] init];
    [self.prevButton setTitle:@"< PREVIOUS" forState:UIControlStateNormal];
    [self.prevButton setTitle:@"< PREVIOUS" forState:UIControlStateHighlighted];
    self.prevButton.buttonColor = [UIColor turquoiseColor];
    self.prevButton.shadowColor = [UIColor greenSeaColor];
    self.prevButton.shadowHeight = 3.0f;
    self.prevButton.cornerRadius = 6.0f;
    self.prevButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.prevButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.prevButton sizeToFit];
    self.prevButton.frame = CGRectMake(20, self.view.frame.size.height - self.prevButton.frame.size.height - 20, self.prevButton.frame.size.width, self.prevButton.frame.size.height);
    [self.view addSubview:self.prevButton];
    [self.prevButton addTarget:self action:@selector(showPreviousLevels:) forControlEvents:UIControlEventTouchUpInside];
    
    _nbColumns = floor(self.view.bounds.size.width / ((_itemWidth + _minOffset) + _minOffset));
    _offset = (self.view.bounds.size.width - (_itemWidth * _nbColumns)) / (_nbColumns +1);
    
    _nbRows = floor(self.view.bounds.size.height / ((_itemHeight + _offset) + _offset));
    _startOffsetY = (self.view.bounds.size.height - (_nbRows * (_itemHeight + _offset) - _offset)) * .5;
    
    _nbLevelByPage = _nbRows * _nbColumns;
//    NSLog(@"HEIGHT:%f / OFFSET_Y:%f", self.view.bounds.size.height, _startOffsetY);
//    NSLog(@"NB COLUMNS:%d, NB ROWS:%d, OFFSET:%f", _nbColumns, _nbRows, _offset);
}

- (void)populateFromLevel:(int)startLevel{
    [self clearLevelButtons];
    
    _startLevel = startLevel;
    if(startLevel == 0)
        self.prevButton.hidden = YES;
    else
        self.prevButton.hidden = NO;
    
    self.nextButton.hidden = YES;
    
//    CGFloat w = 40.0;
//    CGFloat h = 40.0;
//    int minOffset = 20;
//    double offset = 0.0;
//    double startOffsetY = 0.0;
//    int nbColumns = 0;
//    int nbRows = 0;
    int currentRow;
    LevelNumberView *level;
    
    for (int i = startLevel; i < _nbLevels; i++) {
//        if(i == startLevel){
//            nbColumns = floor(self.view.bounds.size.width / ((w + minOffset) + minOffset));
//            offset = (self.view.bounds.size.width - (w * nbColumns)) / (nbColumns +1);
//            
//            nbRows = floor(self.view.bounds.size.height / ((h + offset) + offset));
//            startOffsetY = (self.view.bounds.size.height - (nbRows * (h + offset) - offset)) * .5;
////            NSLog(@"HEIGHT:%f / OFFSET_Y:%f", self.view.bounds.size.height, startOffsetY);
////            NSLog(@"NB COLUMNS:%d, NB ROWS:%d, OFFSET:%f", nbColumns, nbRows, offset);
//        }
        
        currentRow = floor((i - startLevel) / _nbColumns);
        
        if(currentRow >= _nbRows){
            self.nextButton.hidden = NO;
            return;
        }
        
        level = [LevelNumberView presentInViewController:self];
        [_levelButtons addObject:level];
        level.frame = CGRectMake(_offset + ((i - startLevel) % _nbColumns) * (_itemWidth + _offset), _startOffsetY + (currentRow * (_itemHeight + _offset)), _itemWidth, _itemHeight);
        
        if(i <= _lastLevel){
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateHighlighted];
            
            if(i == _currentLevel){
                [level.label setTitleColor:[UIColor sunflowerColor] forState:UIControlStateNormal];
                [level.label setTitleColor:[UIColor sunflowerColor] forState:UIControlStateHighlighted];
            }
        } else {
            level.label.enabled = NO;
            [level.label setTitle:@"." forState:UIControlStateNormal];
            [level.label setTitle:@"." forState:UIControlStateHighlighted];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configureView];
    
    _startLevel = _currentLevel - (_currentLevel % _nbLevelByPage);
    [self populateFromLevel:_startLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectLevel:(int)nb{
    NSLog(@"SELECT LEVEL %d / CURRENT:%d", nb, _currentLevel);
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

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != alertView.cancelButtonIndex){
        _currentLevel = _clickedLevel;
        
        [self.delegate launchLevel:_clickedLevel];
    }
}

@end
