//
//  ObjectMatcher.h
//
//  Created by Andy Lee on 4/7/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectMatcher : NSObject

+ (id)objectMatcherSentinel;

+ (id)matcherWithBaseObject:(id)baseObject;

/*! For internal use. Expects [ObjectMatcher sentinel] as the last arg. */
- (BOOL)matchesAnyObject:(id)firstObject, ...;

/*! For internal use. Expects [ObjectMatcher sentinel] as the last arg. */
- (BOOL)matchesAnyClass:(Class)firstClass, ...;

@end
