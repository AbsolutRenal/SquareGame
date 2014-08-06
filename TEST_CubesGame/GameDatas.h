//
//  GameDatas.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 06/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDatas : NSObject

@property (assign, nonatomic) int currentLevel;

- (instancetype)init;
- (int)nbLevels;
- (int)lastLevel;

@end
