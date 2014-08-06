//
//  GameDatas.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 06/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDatas.h"

@interface GameDatas(){
    NSString *_levelsFile;
    NSArray *_levelsDescription;
    NSDictionary *_colors;
    int _nbLevels;
}

@end

@implementation GameDatas

- (instancetype)init{
    self = [super init];
    
    if(self){
        NSDictionary *tmpDict = [NSDictionary dictionaryWithContentsOfFile:[self levelsFile]];
        _levelsDescription = tmpDict[@"levels"];
        _colors = tmpDict[@"colors"];
        _currentLevel = [self lastLevel];
        
        _nbLevels = 0;
    }
    
    return self;
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

- (int)nbLevels{
    if (_nbLevels == 0)
        _nbLevels = (int)_levelsDescription.count;
    
    return _nbLevels;
}

@end
