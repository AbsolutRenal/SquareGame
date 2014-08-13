//
//  SelectorMatcher.m
//
//  Created by Andy Lee on 4/7/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import "SelectorMatcher.h"
#import <objc/runtime.h>

@interface SelectorMatcher ()
@property (nonatomic, assign) SEL baseSelector;
@end

@implementation SelectorMatcher

+ (SEL)selectorMatcherSentinel
{
    static dispatch_once_t pred;
    static SEL sentinelForVarArgs;

    dispatch_once(&pred, ^{ sentinelForVarArgs = @selector(__SelectorMatcher__Sentinel__); });
    return sentinelForVarArgs;
}

+ (id)matcherWithBaseSelector:(SEL)baseSelector
{
    return [[self alloc] initWithBaseSelector:baseSelector];
}

- (id)initWithBaseSelector:(SEL)baseSelector
{
    self = [super init];
    if (self)
    {
        _baseSelector = baseSelector;
    }

    return self;
}

- (BOOL)matchesAnySelector:(SEL)firstSelector, ...
{
    BOOL didMatch = NO;
    va_list args;
    va_start(args, firstSelector);
    for (SEL arg = firstSelector; arg != [SelectorMatcher selectorMatcherSentinel]; arg = va_arg(args, SEL))
    {
        if (_baseSelector == arg)
        {
            didMatch = YES;
        }
    }
    va_end(args);

    return didMatch;
}

@end
