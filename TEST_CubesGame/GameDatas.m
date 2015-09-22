//
//  GameDatas.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 06/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "GameDatas.h"

@interface GameDatas(){
    int _nbLevels;
    int _lastLevel;
}

@property (strong, nonatomic)NSMutableDictionary *levelsDataFile;
@property (strong, nonatomic)NSString *levelsFile;
@property (strong, nonatomic)NSString *levelsStoreFile;
@property (strong, nonatomic)NSArray *levelsDescription;
@property (strong, nonatomic)NSDictionary *colors;

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
        self.levelsDataFile = [self levelsData];
        self.levelsDescription = self.levelsDataFile[@"levels"];
        self.colors = self.levelsDataFile[@"colors"];
        _currentLevel = [self lastLevel];
        
        _nbLevels = 0;
    }
    
    return self;
}

- (int)lastLevel{
    if(_lastLevel != -1)
        return _lastLevel;
    
    int nb = (int)self.levelsDescription.count;
    int i;
    BOOL completed;
    
    for (i = 0; i < nb; i++) {
        //        NSLog(@"i:%i", i);
        //        NSLog(@"i:%d, COMPLETED:%@", i, self.levelsDescription[i][@"completed"]);
        
        completed = [self.levelsDescription[i][@"completed"]  boolValue];
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
        _nbLevels = (int)self.levelsDescription.count;
    
    return _nbLevels;
}

- (NSDictionary *)levelDatasForLevel:(int)level{
    return self.levelsDescription[level];
}

- (void)completeLevel{
//    NSLog(@"[GAME_DATAS] -(void)completeLevel");
    
    [self.levelsDataFile[@"levels"][_currentLevel] setValue:@YES forKey:@"completed"];
//    NSLog(@"DATAS %@", self.levelsDataFile[@"levels"][_currentLevel][@"completed"]);
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
    return self.colors[name];
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
    
    if(!self.levelsFile){
        self.levelsFile = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if(![fileManager fileExistsAtPath:self.levelsStoreFile]){
//        NSLog(@"$$$ FILE DOESN'T EXIST $$$");
        
        NSError *error;
        [fileManager copyItemAtPath:self.levelsFile toPath:self.levelsStoreFile error:&error];
        
        datas = [NSMutableDictionary dictionaryWithContentsOfFile:self.levelsStoreFile];
        [datas addEntriesFromDictionary:@{@"version":[self versionNumber], @"build":[self buildNumber]}];
        
    } else {
        datas = [NSMutableDictionary dictionaryWithContentsOfFile:self.levelsStoreFile];
        NSLog(@"$$$ FILE EXISTS IN VERSION:%@ BUILD:%@", [datas valueForKey:@"version"], [datas valueForKey:@"build"]);
        NSLog(@"CURRENT RUNNING VERSION:%@", [self version]);
        
        if([[datas objectForKey:@"version"] doubleValue] < [[self versionNumber] doubleValue] || ([[datas objectForKey:@"version"] doubleValue] == [[self versionNumber] doubleValue] && [[datas objectForKey:@"build"] intValue] < [[self buildNumber] intValue])){
            NSLog(@"$$$ FILE NEEDS UPDATE $$$");
            
            NSMutableDictionary *newDatas = [NSMutableDictionary dictionaryWithContentsOfFile:self.levelsFile];
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
    return [self.levelsDataFile writeToFile:self.levelsStoreFile atomically:YES];
}

@end
