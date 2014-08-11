//
//  GameViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameViewController.h"
#import "GameDatas.h"

const int MIN_GRID_WIDTH = 4;
const int MIN_GRID_HEIGHT = 6;

@interface GameViewController (){
    int _level;
}

@property (strong, nonatomic)NSDictionary *levelDatas;

@end

@implementation GameViewController

- (id)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

- (instancetype)initWithCurrentLevel:(int)level withDatas:(NSDictionary *)levelDatas{
    self = [super init];
    
//    NSLog(@"COLOR RED: %@", [GameDatas colorWithName:@"dark"]);
//    NSLog(@"STATIC %d", [GameDatas getInstance].currentLevel);
    
    if(self){
        self.levelDatas = levelDatas;
        [self startLevel:level withDatas:levelDatas];
    }
    
    return self;
}

- (void)startLevel:(int)level withDatas:(NSDictionary *)levelDatas{
    NSLog(@"CURRENT LEVEL:%d | REQUESTED LEVEL:%d", _level, level);
    if(level != _level){
        NSLog(@"START");
        _level = level;
        
    } else {
        NSLog(@"DON'T RESTART SAME LEVEL");
        // DO NOTHING => SAME LEVEL AS CURRENT PLAYING
    }
}


- (void)resetLevel{
    
}

- (void)undoLastMove{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
