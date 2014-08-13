//
//  SelectorMatcher.h
//
//  Created by Andy Lee on 4/7/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectorMatcher : NSObject

+ (SEL)selectorMatcherSentinel;

+ (id)matcherWithBaseSelector:(SEL)baseSelector;

- (BOOL)matchesAnySelector:(SEL)firstSelector, ...;

@end
