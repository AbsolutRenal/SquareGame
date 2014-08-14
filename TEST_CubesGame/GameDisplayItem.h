//
//  GameDisplayItem.h
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 11/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameDisplayItem : UIView

//@property (strong, nonatomic)NSString *position;
- (NSString *)position;
- (void)setPosition:(NSString *)position;
@property (strong, nonatomic)NSString *color;
@property (strong, nonatomic)NSString *type;
@property (assign, nonatomic)int squareSize;
@property (assign, nonatomic)int posX;
@property (assign, nonatomic)int posY;
@property (strong, nonatomic)UIColor *itemColor;

@end
