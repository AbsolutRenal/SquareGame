//
//  GameDatas.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 06/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDatas.h"

@interface GameDatas(){
    NSDictionary *_levelsDataFile;
    NSString *_levelsFile;
    NSArray *_levelsDescription;
    NSDictionary *_colors;
    int _nbLevels;
    int _lastLevel;
}

@end

@implementation GameDatas

+ (UIColor *)colorWithName:(NSString *)colorStr{

    return [UIColor colorFromHexCode:[[GameDatas getInstance] colorStrNamed:colorStr]];
}

+ (instancetype)getInstance{
    static GameDatas *instance;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
//        NSLog(@"CREATE INSTANCE");
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init{
    self = [super init];
    
    if(self){
        _lastLevel = -1;
        _levelsDataFile = [NSDictionary dictionaryWithContentsOfFile:[self levelsFile]];
        _levelsDescription = _levelsDataFile[@"levels"];
        _colors = _levelsDataFile[@"colors"];
        _currentLevel = [self lastLevel];
        
        _nbLevels = 0;
    }
    
    return self;
}

- (NSString *)colorStrNamed:(NSString *)name{
    return _colors[name];
}

- (int)currentLevel{
    return _currentLevel;
}

- (NSString *)levelsFile{
    if(!_levelsFile){
        _levelsFile = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    }
    return _levelsFile;
}

- (int)lastLevel{
    if(_lastLevel != -1)
        return _lastLevel;
    
    int nb = (int)_levelsDescription.count;
    int i;
    BOOL completed;
    
    for (i = 0; i < nb; i++) {
//        NSLog(@"i:%d, COMPLETED:%@", i, _levelsDescription[i][@"completed"]);
//        completed = [_levelsDescription[i][@"completed"]  isEqual:@1];
        completed = [_levelsDescription[i][@"completed"]  boolValue];
        if(!completed){
            _lastLevel = i;
            return i;
        }
    }
    _lastLevel = i;
    return i;
}

- (int)nbLevels{
    if (_nbLevels == 0)
        _nbLevels = (int)_levelsDescription.count;
    
    return _nbLevels;
}

- (NSDictionary *)levelDatasForLevel:(int)level{
    return _levelsDescription[level];
}

- (void)completeLevel{
    if(_currentLevel < (_nbLevels -1)){
        if(_lastLevel == _currentLevel){
            _lastLevel ++;
        }
        _currentLevel ++;
    }
    
    [_levelsDataFile[@"levels"][_currentLevel] setValue:@YES forKey:@"completed"];
}

+ (BOOL)save{
    return [[GameDatas getInstance] saveData];
}

- (BOOL)saveData{
    return [_levelsDataFile writeToFile:[self levelsFile] atomically:YES];
}

@end
