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
}

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
    }
    
//    NSLog(@"current:%d, nb:%d, last:%d", current, nb, last);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSLog(@"LEVELS NAMES:%@", self.levelNames);
    
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    int minOffset = 40;
    double offset = 0.0;
    double startOffsetY = 0.0;
    LevelNumberView *level;
    int nbColumns = 0;
    int nbRows;
    
    for (int i = 0; i < _nbLevels; i++) {
//        level = [[LevelNumberView alloc] init];
        level = [LevelNumberView presentInViewController:self];
        
        if(w == 0.0){
            w = level.bounds.size.width;
            NSLog(@"w:%f", w);
            h = level.bounds.size.height;
            nbColumns = self.view.bounds.size.width / ((w + minOffset) + minOffset);
            offset = (self.view.bounds.size.width - (w * nbColumns)) / (nbColumns +1);
            
            nbRows = self.view.bounds.size.height / ((h + offset) + offset);
            startOffsetY = (self.view.bounds.size.height - (nbRows * (h + offset) - offset)) * .5;
            
            NSLog(@"NB COLUMNS:%d, NB ROWS:%d, OFFSET:%f", nbColumns, nbRows, offset);
        }
        
        level.frame = CGRectMake(offset + (i % nbColumns) * (w + offset), startOffsetY + ((int)(i / nbColumns) * (h + offset)), w, h);
        level.backgroundColor = [UIColor grayColor];
        
        if(i <= _lastLevel){
            [level.label setTitle:self.levelNames[i] forState:UIControlStateNormal];
            [level.label setTitle:self.levelNames[i] forState:UIControlStateHighlighted];
            
            if(i == _currentLevel){
                [level.label setTintColor:[UIColor redColor]];
            }
        } else {
            [level.label setTitle:@"." forState:UIControlStateNormal];
            [level.label setTitle:@"." forState:UIControlStateHighlighted];
        }
        
//        [self.view addSubview:level];
//        NSLog(@"label:%@", level.label);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectLevel:(int)nb{
    NSLog(@"SELECT LEVEL %d", nb);
    
    [self.delegate launchLevel:nb];
}

@end
