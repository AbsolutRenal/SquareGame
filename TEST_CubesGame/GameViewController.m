//
//  GameViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameViewController.h"
#import "GameDatas.h"

const int MAX_SQUARE_SIZE = 80;


@interface GameViewController (){
    int _level;
    int _squareSize;
    int _nbColumns;
    int _nbRows;
}

@property (strong, nonatomic)NSMutableArray *moves;
@property (strong, nonatomic)NSDictionary *levelDatas;
@property (strong, nonatomic)UIView *container;
@property (strong, nonatomic)NSMutableArray *gameItems;

@end

@implementation GameViewController

- (id)init{
    self = [super init];
    
    if(self){
        self.container = [[UIView alloc] init];
        self.container.alpha = 0;
        [self.view addSubview:self.container];
        
        self.moves = [[NSMutableArray alloc] init];
        
        // TEST PASSAGE D'UN NIVEAU AU SUIVANT
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(complete)];
//        [self.view addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)complete{
//    NSLog(@"COMPLETE");
    [self.delegate completeLevel];
}

- (instancetype)initWithCurrentLevel:(int)level withDatas:(NSDictionary *)levelDatas{
    self = [self init];
    
//    NSLog(@"COLOR RED: %@", [GameDatas colorWithName:@"dark"]);
//    NSLog(@"STATIC %d", [GameDatas getInstance].currentLevel);
    
    if(self){
        _level = level;
        _levelDatas = levelDatas;
    }
    
    return self;
}

- (void)startLevel:(int)level withDatas:(NSDictionary *)levelDatas{
//    NSLog(@"CURRENT LEVEL:%d | REQUESTED LEVEL:%d", _level, level);
    if(level != _level){
//        NSLog(@"START");
        _level = level;
        self.levelDatas = levelDatas;
        
        [UIView animateWithDuration:.3 animations:^{
            self.container.alpha = 0.;
        } completion:^(BOOL finished) {
            [self configureLevel];
        }];
//    } else {
//        NSLog(@"DON'T RESTART SAME LEVEL");
        // DO NOTHING => SAME LEVEL AS CURRENT PLAYING
    }
}

- (void)configureLevel{
//    NSLog(@"HEIGHT CONFIGURE: %f", self.view.frame.size.height);
    
    [self emptyContainer];
    
    _nbColumns = [_levelDatas[@"matrix"][@"columns"] intValue];
    _nbRows = [_levelDatas[@"matrix"][@"rows"] intValue];
    
//    NSLog(@"ROWS: %i | COLUMNS:%i", _nbRows, _nbColumns);
    _squareSize = MIN(MIN(self.view.frame.size.width / _nbRows, self.view.frame.size.height / _nbColumns), MAX_SQUARE_SIZE);
    
    
    self.container.frame = CGRectMake(0, 0, _nbColumns * _squareSize, _nbRows * _squareSize);
    self.container.center = self.view.center;
//    self.container.backgroundColor = [UIColor lightGrayColor];
    
    
    int nbItems = (int)[_levelDatas[@"matrix"][@"items"] count];
    GameDisplayItem *item;
    NSString *type;
    for(int i = 0; i < nbItems; i++){
        type = _levelDatas[@"matrix"][@"items"][i][@"type"];
        objswitch(type)
            objcase(@"square"){
                item = [[GameDisplaySquare alloc] init];
                ((GameDisplaySquare *)item).direction = _levelDatas[@"matrix"][@"items"][i][@"direction"];
                ((GameDisplaySquare *)item).delegate = self;
            };
        
            objcase(@"dot"){
                item = [[GameDisplayDot alloc] init];
            };
        
            objcase(@"arrow"){
                item = [[GameDisplayArrow alloc] init];
                ((GameDisplayArrow *)item).direction = _levelDatas[@"matrix"][@"items"][i][@"direction"];
            };
        
            defaultcase{
                NSLog(@"[ERROR] WRONG ITEM TYPE : %@", type);
            };
        endswitch
        
        if(item){
            [item setPosition:_levelDatas[@"matrix"][@"items"][i][@"position"]];
            item.color = _levelDatas[@"matrix"][@"items"][i][@"color"];
            item.type = type;
            item.squareSize = _squareSize;
            [self.gameItems addObject:item];
            [self.container addSubview:item];
        }
    }
    
    
    [UIView animateWithDuration:.3 animations:^{
        self.container.alpha = 1.;
    }];
    
}

- (void)emptyContainer{
    while (self.container.subviews.count > 0) {
        [self.container.subviews[0] removeFromSuperview];
    }
    [self.gameItems removeAllObjects];
}


- (void)resetLevel{
    for (GameDisplaySquare *item in self.gameItems) {
        if([item isKindOfClass:[GameDisplaySquare class]]){
            [item resetPosition];
        }
    }
    
    [self.moves removeAllObjects];
}

- (void)undoLastMove{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}

- (NSMutableArray *)gameItems{
    if(!_gameItems){
        _gameItems = [[NSMutableArray alloc] init];
    }
    return _gameItems;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configureLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)squareMoved:(GameDisplayItem *)square{
//    NSLog(@"SQUARE MOVED");
    [self.container bringSubviewToFront:square];
    
    if(((GameDisplaySquare *)square).isRight)
        ((GameDisplaySquare *)square).isRight = NO;
    
    for (GameDisplayItem *item in self.gameItems) {
        if(item == square)
            continue;
        
        if([[item position] isEqualToString:[square position]]){
            if([item.type isEqualToString:@"dot"] && [item.color isEqualToString:square.color]){
                ((GameDisplaySquare *)square).isRight = YES;
            }
            
            
            if([item.type isEqualToString:@"square"]){
                item.posX += ((GameDisplaySquare *)square).xSpeed;
                item.posY += ((GameDisplaySquare *)square).ySpeed;
                [((GameDisplaySquare *)item) updatePosition];
                
            } else if([item.type isEqualToString:@"arrow"]){
                ((GameDisplaySquare *)square).direction = ((GameDisplayArrow *)item).direction;
                [((GameDisplaySquare *)square) rotateArrowAnimated:YES];
            }
        }
    }
    
    if([self isCompleted]){
        [self performSelector:@selector(showEndText) withObject:nil afterDelay:.4];
    }
}

- (BOOL)isCompleted{
    for (GameDisplayItem *item in self.gameItems) {
//        NSLog(@"--- isKindOfClass:%i", [item isKindOfClass:[GameDisplaySquare class]]);
        
        if([item isKindOfClass:[GameDisplaySquare class]]){
//            NSLog(@"----- isRight:%i", ((GameDisplaySquare *)item).isRight);

            
            if(((GameDisplaySquare *)item).isRight)
                continue;
            else
                return NO;
        }
    }
    
    return YES;
}

- (void)showEndText{
    
    
    [self.delegate completeLevel];
}

@end
