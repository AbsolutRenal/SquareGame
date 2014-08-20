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
    float _rotation;
    float _angle;
    int idx;
    BOOL _completed;
}

@property (strong, nonatomic)NSMutableArray *moves;
@property (strong, nonatomic)NSDictionary *levelDatas;
@property (strong, nonatomic)UIView *container;
@property (strong, nonatomic)NSMutableArray *gameItems;
@property (strong, nonatomic)UITapGestureRecognizer *tap;
@property (strong, nonatomic)UILabel *endText;

@end

@implementation GameViewController

- (id)init{
    self = [super init];
    
    if(self){
        self.container = [[UIView alloc] init];
        self.container.alpha = 0;
        [self.view addSubview:self.container];
        _rotation = 0;
        _angle = 0.;
        idx = 0;
//        self.container.backgroundColor = [UIColor lightGrayColor];
        
        self.moves = [[NSMutableArray alloc] init];
    }
    
    return self;
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
//    NSLog(@"---- height=%f", self.container.frame.size.height);
    
    [self emptyContainer];
    _completed = NO;
    
    if(_levelDatas[@"matrix"][@"rotate"] != nil){
        NSLog(@"-- ROTATE");
        _rotation = [_levelDatas[@"matrix"][@"rotate"] doubleValue] * .001;
        NSLog(@"--- value:%f", _rotation);
    }
    
    _nbColumns = [_levelDatas[@"matrix"][@"columns"] intValue];
    _nbRows = [_levelDatas[@"matrix"][@"rows"] intValue];
    
//    NSLog(@"ROWS: %i | COLUMNS:%i", _nbRows, _nbColumns);
    _squareSize = MIN(MIN((self.container.frame.size.width -_nbColumns + 1) / _nbColumns, (self.container.frame.size.height -_nbRows +1) / _nbRows), MAX_SQUARE_SIZE);

    double offsetX = (self.container.frame.size.width - _nbColumns * (_squareSize +1) -1) * .5;
    double offsetY = (self.container.frame.size.height - _nbRows * (_squareSize +1) -1) * .5;
    
    
    int nbItems = (int)[_levelDatas[@"matrix"][@"items"] count];
    GameDisplayItem *item;
    NSString *type;
    for(int i = 0; i < nbItems; i++){
        type = _levelDatas[@"matrix"][@"items"][i][@"type"];
        objswitch(type)
            objcase(@"square"){
                item = [[GameDisplaySquare alloc] init];
                ((GameDisplaySquare *)item).delegate = self;
                ((GameDisplaySquare *)item).optional = [_levelDatas[@"matrix"][@"items"][i][@"optional"] boolValue];
            };
        
            objcase(@"dot"){
                item = [[GameDisplayDot alloc] init];
            };
        
            objcase(@"arrow"){
                item = [[GameDisplayArrow alloc] init];
            };
        
            defaultcase{
                NSLog(@"[ERROR] WRONG ITEM TYPE : %@", type);
            };
        endswitch
        
        if(item){
            item.offsetX = offsetX;
            item.offsetY = offsetY;
            
            [item setPosition:_levelDatas[@"matrix"][@"items"][i][@"position"]];
            
            if(![type isEqualToString:@"arrow"])
                item.color = _levelDatas[@"matrix"][@"items"][i][@"color"];
            if(![type isEqualToString:@"dot"])
                ((GameDisplayArrow *)item).direction = ((GameDisplayArrow *)item).initialDirection = _levelDatas[@"matrix"][@"items"][i][@"direction"];
            item.type = type;
            item.squareSize = _squareSize;
            
            [self.gameItems addObject:item];
            [self.container addSubview:item];
            
            if(![type isEqualToString:@"square"])
                [self.container sendSubviewToBack:item];
        }
    }
    
    [self tintSquareArrowIfOverArrowAnimated:NO];
    [self tintSquareIfOverDotAnimated:NO];
    [self storePositions];
    
    
    [UIView animateWithDuration:.3 animations:^{
        self.container.alpha = 1.;
    } completion:^(BOOL finished) {
        if(_rotation != 0.){
            [self rotateContainer];
        }
    }];
    
}

- (void)rotateContainer{
    _angle += _rotation;
    
    self.container.transform = CGAffineTransformMakeRotation(_angle);
    
    [self performSelector:@selector(rotateContainer) withObject:nil afterDelay:.01];
}

- (void)storePositions{
    NSMutableArray *itemsState = [[NSMutableArray alloc] init];
    for (GameDisplaySquare *item in self.gameItems) {
        if([item isKindOfClass:[GameDisplaySquare class]]){
            [itemsState addObject:@{@"item":item, @"position":item.position, @"direction":item.direction}];
        }
    }
    
    [self.moves addObject:itemsState];
}

- (void)emptyContainer{
    while (self.container.subviews.count > 0) {
        [self.container.subviews[0] removeFromSuperview];
    }
    [self.gameItems removeAllObjects];
    [self.moves removeAllObjects];
    
    if(self.endText != nil){
        if(self.endText.superview != nil)
           [self.endText removeFromSuperview];
        self.endText = nil;
    }
    
    if(self.tap != nil){
        if([self.container.gestureRecognizers containsObject:self.tap])
           [self.container removeGestureRecognizer:self.tap];
        self.tap = nil;
    }
    
    [self deleteRotationAnimation];
    
    idx = 0;
}

- (void)deleteRotationAnimation{
    if(_rotation != 0.){
//        NSLog(@"-- CANCEL");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rotateContainer) object:nil];
        _angle = 0.;
        _rotation = 0.;
        self.container.transform = CGAffineTransformMakeRotation(0.);
    }
}


- (void)resetLevel{
    for (GameDisplaySquare *item in self.gameItems) {
        if([item isKindOfClass:[GameDisplaySquare class]]){
            [item resetPosition];
        }
    }
    
    [self tintSquareArrowIfOverArrowAnimated:NO];
    [self tintSquareIfOverDotAnimated:NO];
    [self.moves removeAllObjects];
    [self storePositions];
}

- (void)undoLastMove{
//    NSLog(@"UNDO %i", (int)self.moves.count);
    
    if(self.moves.count > 1){
        [self.moves removeLastObject];
        NSArray *lastItemsState = (NSArray *)[self.moves lastObject];
//        [lastPositions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [(GameDisplaySquare *)obj moveToPosition:(NSString *)key];
//        }];
        for(NSDictionary *state in lastItemsState){
            [((GameDisplaySquare *)state[@"item"]) restoreStateWithPosition:state[@"position"] widthDirection:state[@"direction"]];
        }
        
        [self tintSquareArrowIfOverArrowAnimated:YES];
        [self tintSquareIfOverDotAnimated:YES];
    }
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
    
    self.container.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
//    NSLog(@"WILL APPEAR: height=%f", self.container.frame.size.height);
    
    [self configureLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tintSquareArrowIfOverArrowAnimated:(BOOL)animated{
    for(GameDisplaySquare *square in _gameItems){
        if([square isKindOfClass:[GameDisplaySquare class]]){
//            NSLog(@"SQUARE over:%i", [self checkOverArrow:square]);
            [square tintArrow:[self checkOverArrow:square] animated:animated];
        }
    }
}

- (BOOL)checkOverArrow:(GameDisplaySquare *)square{
    for(GameDisplayArrow *arrow in _gameItems){
        if([arrow isKindOfClass:[GameDisplayArrow class]] && ![arrow isKindOfClass:[GameDisplaySquare class]] && [arrow.position isEqualToString:square.position]){
            //            NSLog(@"square:%@ | arrow:%@", square.position, arrow.position);
            return YES;
        }
    }
    
    return NO;
}

- (void)tintSquareIfOverDotAnimated:(BOOL)animated{
    for(GameDisplaySquare *square in _gameItems){
        if([square isKindOfClass:[GameDisplaySquare class]]){
            //            NSLog(@"SQUARE over:%i", [self checkOverArrow:square]);
            [square showDotOverlayColor:[self checkOverDot:square] animated:animated];
        }
    }
}

- (UIColor *)checkOverDot:(GameDisplaySquare *)square{
    for(GameDisplayDot *dot in _gameItems){
        if([dot isKindOfClass:[GameDisplayDot class]] && [dot.position isEqualToString:square.position]){
            //            NSLog(@"square:%@ | arrow:%@", square.position, arrow.position);
            return dot.itemColor;
        }
    }
    
    return nil;
}

- (void)squareMoved:(GameDisplayItem *)square{
//    NSLog(@"SQUARE MOVED %@", square.color);
    
    static GameDisplayItem *touchedSquare;
    if(touchedSquare == nil)
        touchedSquare = square;
    static int xSpeed;
    static int ySpeed;
    
    [self.container bringSubviewToFront:square];
    
    if(((GameDisplaySquare *)square).isRight)
        ((GameDisplaySquare *)square).isRight = NO;
    
    for (GameDisplayItem *item in self.gameItems) {
        if(item == square)
            continue;
        
        if([[item position] isEqualToString:[square position]]){
//            if([item.type isEqualToString:@"dot"] && [item.color isEqualToString:square.color]){
            if([item.type isEqualToString:@"dot"]){
                if([item.color isEqualToString:square.color])
                    ((GameDisplaySquare *)square).isRight = YES;
                
                
            }
            
            if([item.type isEqualToString:@"square"]){
                if(xSpeed == 0 && ySpeed == 0){
                    xSpeed = ((GameDisplaySquare *)square).xSpeed;
                    ySpeed = ((GameDisplaySquare *)square).ySpeed;
                }
                
                item.posX += xSpeed;
                item.posY += ySpeed;
                [((GameDisplaySquare *)item) updatePosition];
                
            } else if([item.type isEqualToString:@"arrow"]){
                ((GameDisplaySquare *)square).direction = ((GameDisplayArrow *)item).direction;
                [((GameDisplaySquare *)square) rotateArrowAnimated:YES];
            }
        }
    }
    
    
    if(touchedSquare == square){
        _completed = [self isCompleted];
        if(_completed){
            [[GameDatas getInstance] completeLevel];
            
            touchedSquare = nil;
            [self performSelector:@selector(removeSquares) withObject:nil afterDelay:.4];
        } else {
//        NSLog(@"--- RESET touchedSquare %@", square.color);
//        xSpeed = ySpeed = 0;
            touchedSquare = nil;
            
            [self tintSquareArrowIfOverArrowAnimated:YES];
//        [self tintSquareIfOverDotAnimated:YES];
            
            [self storePositions];
        }
    }
    
    [(GameDisplaySquare *)square showDotOverlayColor:[self checkOverDot:(GameDisplaySquare *)square] animated:YES];
    
//    NSLog(@"----- RESET SPEED %@", square.color);
    xSpeed = ySpeed = 0;
    
//    NSLog(@"--- END SQUARE MOVED %@", square.color);
}

- (BOOL)isCompleted{
    for (GameDisplayItem *item in self.gameItems) {
        if([item isKindOfClass:[GameDisplaySquare class]]){
            if(((GameDisplaySquare *)item).isRight)
                continue;
            else
                return NO;
        }
    }
    
    return YES;
}

- (void)removeSquares{
    for (GameDisplayItem *item in _gameItems) {
        if([item isKindOfClass:[GameDisplayDot class]] || ([item isKindOfClass:[GameDisplayArrow class]] && ![item isKindOfClass:[GameDisplaySquare class]])){
            
            item.hidden = YES;
            
        } else {
            [UIView animateWithDuration:.3 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
                item.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    item.transform = CGAffineTransformMakeScale(0., 0.);
                } completion:^(BOOL finished) {
                    item.hidden = YES;
                }];
            }];
        }
    }
    
    [self performSelector:@selector(showEndText) withObject:nil afterDelay:.7];
}

- (void)showEndText{
//    NSLog(@"SHOW END TEXT");
    
    [self deleteRotationAnimation];
    
    if(idx == ((NSArray *)self.levelDatas[@"end"]).count){
        idx = 0;
        
        if(self.tap != nil){
            if([self.container.gestureRecognizers containsObject:self.tap])
                [self.container removeGestureRecognizer:self.tap];
            self.tap = nil;
        }
        
        if(self.endText != nil){
            if(self.endText.superview != nil)
                [self.endText removeFromSuperview];
            self.endText = nil;
        }
        
        [self switchToNextLevel];
    } else {
        if(idx == 0){
            self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEndText)];
            [self.container addGestureRecognizer:self.tap];
        }
        
        if(self.endText == nil){
            self.endText = [[UILabel alloc] init];
            self.endText.font = [UIFont boldFlatFontOfSize:20];
            self.endText.lineBreakMode = NSLineBreakByWordWrapping;
            self.endText.numberOfLines = 0;
            self.endText.textColor = [UIColor grayColor];
            self.endText.textAlignment = NSTextAlignmentCenter;
            self.endText.frame = CGRectMake(20, 20, self.container.bounds.size.width - 40, self.container.bounds.size.height - 40);
//            txt.transform = CGAffineTransformMakeRotation(-M_PI * .5);
            [self.container addSubview:self.endText];
        }
        
        self.endText.text = self.levelDatas[@"end"][idx];
        
        idx++;
    }
}

- (BOOL)shouldMove{
//    NSLog(@"SHOULD MOVE");
    return !_completed;
}

- (void)switchToNextLevel{
//    NSLog(@"SWITCH TO NEXT LEVEL");
    [self.delegate completeLevel];
}

- (void)congratulate{
//    NSLog(@"----- CONGRATULATION !!");
    [self emptyContainer];
    
    self.endText = [[UILabel alloc] init];
    self.endText.font = [UIFont boldFlatFontOfSize:30];
    self.endText.lineBreakMode = NSLineBreakByWordWrapping;
    self.endText.numberOfLines = 0;
    self.endText.textColor = [UIColor grayColor];
    self.endText.textAlignment = NSTextAlignmentCenter;
    self.endText.frame = CGRectMake(20, 20, self.container.bounds.size.width - 40, self.container.bounds.size.height - 40);
    [self.container addSubview:self.endText];
    
    self.endText.text = @"CONGRATULATION !!\nYou finished it :)";
}

@end
