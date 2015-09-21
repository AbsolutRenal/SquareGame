//
//  GameDatas.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 06/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDatas.h"

@interface GameDatas(){
    NSMutableDictionary *_levelsDataFile;
    NSString *_levelsFile;
    NSString *_levelsStoreFile;
    NSArray *_levelsDescription;
    NSDictionary *_colors;
    int _nbLevels;
    int _lastLevel;
}

@end

@implementation GameDatas


#pragma mark - Class Methods

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

+ (BOOL)save{
    //    NSLog(@"[GAME_DATAS] +(BOOL)save");
    return [[GameDatas getInstance] saveData];
}


#pragma mark - Instance Public Methods

- (instancetype)init{
    self = [super init];
    
    if(self){
        _lastLevel = -1;
        _levelsDataFile = [self levelsData];
        _levelsDescription = _levelsDataFile[@"levels"];
        _colors = _levelsDataFile[@"colors"];
        _currentLevel = [self lastLevel];
        
        _nbLevels = 0;
    }
    
    return self;
}

- (int)lastLevel{
    if(_lastLevel != -1)
        return _lastLevel;
    
    int nb = (int)_levelsDescription.count;
    int i;
    BOOL completed;
    
    for (i = 0; i < nb; i++) {
        //        NSLog(@"i:%i", i);
        //        NSLog(@"i:%d, COMPLETED:%@", i, _levelsDescription[i][@"completed"]);
        
        completed = [_levelsDescription[i][@"completed"]  boolValue];
        if(!completed){
            _lastLevel = i;
            return i;
        }
    }
    _lastLevel = i-1;
    return _lastLevel;
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
    //    NSLog(@"[GAME_DATAS] -(void)completeLevel");
    
    [_levelsDataFile[@"levels"][_currentLevel] setValue:@YES forKey:@"completed"];
    //    NSLog(@"DATAS %@", _levelsDataFile[@"levels"][_currentLevel][@"completed"]);
}


- (BOOL)switchToNExtLevel{
    _lastLevel ++;
    if(_currentLevel < ([self nbLevels] -1)){
        //        NSLog(@"SWITCH TO NEXT LEVEL: YES");
        _currentLevel ++;
        return YES;
        
    } else {
        //        NSLog(@"SWITCH TO NEXT LEVEL: NO");
        _currentLevel = -1;
        return NO;
    }
}



#pragma mark - Instance Private Methods

- (NSString*) version {
    return [NSString stringWithFormat:@"%@ build %@", [self versionNumber], [self buildNumber]];
}

- (NSString *)buildNumber{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)versionNumber{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)colorStrNamed:(NSString *)name{
    return _colors[name];
}

- (int)currentLevel{
    return _currentLevel;
}

- (NSString *)levelsStoreFile{
    if(!_levelsStoreFile){
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _levelsStoreFile = [directory stringByAppendingPathComponent:@"levels.plist"];
    }
    
    return _levelsStoreFile;
}

- (NSMutableDictionary *)levelsData{
    NSMutableDictionary *datas;
    
    if(!_levelsFile){
        _levelsFile = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if(![fileManager fileExistsAtPath:[self levelsStoreFile]]){
//        NSLog(@"$$$ FILE DOESN'T EXIST $$$");
        
        NSError *error;
        [fileManager copyItemAtPath:_levelsFile toPath:_levelsStoreFile error:&error];
        
        datas = [NSMutableDictionary dictionaryWithContentsOfFile:_levelsStoreFile];
        [datas addEntriesFromDictionary:@{@"version":[self versionNumber], @"build":[self buildNumber]}];
        
    } else {
        datas = [NSMutableDictionary dictionaryWithContentsOfFile:_levelsStoreFile];
        NSLog(@"$$$ FILE EXISTS IN VERSION:%@ BUILD:%@", [datas valueForKey:@"version"], [datas valueForKey:@"build"]);
        NSLog(@"CURRENT RUNNING VERSION:%@", [self version]);
        
        if([[datas objectForKey:@"version"] doubleValue] < [[self versionNumber] doubleValue] || ([[datas objectForKey:@"version"] doubleValue] == [[self versionNumber] doubleValue] && [[datas objectForKey:@"build"] intValue] < [[self buildNumber] intValue])){
            NSLog(@"$$$ FILE NEEDS UPDATE $$$");
            
            NSMutableDictionary *newDatas = [NSMutableDictionary dictionaryWithContentsOfFile:_levelsFile];
            int nb = (int)((NSArray *)datas[@"levels"]).count;
            for (int i = 0; i < nb; i++) {
                if([datas[@"levels"][i][@"completed"] boolValue]){
                    [newDatas[@"levels"][i] setValue:@YES forKey:@"completed"];
                } else {
                    break;
                }
            }
            
            [newDatas setValue:[self versionNumber] forKey:@"version"];
            [newDatas setValue:[self buildNumber] forKey:@"build"];
            return newDatas;
            
//            NSLog(@"%@", datas);
//            [datas addEntriesFromDictionary:@{@"version":[self versionNumber], @"build":[self buildNumber]}];
            
//        } else {
            NSLog(@"$$$ FILE IS UP TO DATE $$$");
            // FILE IS UP TO DATE
        }
    }
    
    
    return datas;
}

- (BOOL)saveData{
//    NSLog(@"[GAME_DATAS] -(BOOL)saveData");
    return [_levelsDataFile writeToFile:_levelsStoreFile atomically:YES];
}

@end
