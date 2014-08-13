//
//  ObjectMatcher.m
//
//  Created by Andy Lee on 4/7/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import "ObjectMatcher.h"

@interface ObjectMatcher ()
@property (nonatomic, strong) id baseObject;
@end

@implementation ObjectMatcher

+ (id)objectMatcherSentinel
{
    static dispatch_once_t pred;
    static ObjectMatcher *sentinel = nil;

    dispatch_once(&pred, ^{ sentinel = [[self alloc] init]; });
    return sentinel;
}

+ (id)matcherWithBaseObject:(id)baseObject
{
    return [[self alloc] initWithBaseObject:baseObject];
}

- (id)initWithBaseObject:(id)baseObject
{
    self = [super init];
    if (self)
    {
        _baseObject = baseObject;
    }

    return self;
}

- (BOOL)matchesAnyObject:(id)firstObject, ...
{
    BOOL didMatch = NO;
    va_list args;
    va_start(args, firstObject);
    for (NSString *arg = firstObject; arg != [ObjectMatcher objectMatcherSentinel]; arg = va_arg(args, id))
    {
        if ([_baseObject isEqual:arg])
        {
            didMatch = YES;
        }
    }
    va_end(args);

    return didMatch;
}

- (BOOL)matchesAnyClass:(id)firstClass, ...
{
    BOOL didMatch = NO;
    va_list args;
    va_start(args, firstClass);
    for (Class arg = firstClass; arg != [ObjectMatcher objectMatcherSentinel]; arg = va_arg(args, Class))
    {
        if ([_baseObject isKindOfClass:arg])
        {
            didMatch = YES;
        }
    }
    va_end(args);

    return didMatch;
}

@end
