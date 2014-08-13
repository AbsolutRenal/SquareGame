//
//  objswitch.h
//
//  Created by Andy Lee on 4/7/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//
/**
[See here](http://www.notesfromandy.com/2013/04/07/faking-switch-with-an-object-value/) for a detailed explanation.
To use this stuff, copy these files into your project and import objswitch.h in your code.
You will then be able to do things like this:

	objswitch(someObject)
	objcase(@"one")	{
		 objswitch(@"b")							 // Nesting works.
		 objcase(@"a") printf("one/a");
		 objcase(@"b") printf("one/b");
		 endswitch
		 // Any code can go here, including break/continue/return.
	}
	objcase(@"two") printf("It's TWO."); 	// Can omit braces.
		objcase(@"three",  							// Can have multiple values in one case.
			  nil,  									// nil can be a "case" value.
			  [self self],  						// "Case" values don't have to be constants.
			  @"tres",
			  @"trois") { printf("It's a THREE."); }
	defaultcase printf("None of the values above.");  // Optional default must be at end.
	endswitch
Or:
		objswitch(someObject)
		objkind(NSNumber) { printf("It's a NUMBER."); }
		objkind(NSString) { printf("It's a STRING."); }
		objkind([NSArray class],
				  [NSDictionary class],
				  [NSSet class]) printf("It's a collection.");
		endswitch
Or:
		selswitch([anItem action])
		selcase(@selector(selectSuperclass:))					{  CODE  }
		
		selcase(@selector(selectAncestorClass:))			  	{  CODE  }
		
		selcase(@selector(selectFormalProtocolsTopic:),
				  @selector(selectInformalProtocolsTopic:),
				  @selector(selectFunctionsTopic:))				{  CODE 	}
		endswitch
*/
#import "ObjectMatcher.h"
#import "SelectorMatcher.h"

// Macros that let you do fake switch statements with objects as the switch/case
// values. See the README for details.

#define objswitch(x) \
{ \
ObjectMatcher *___my_matcher___ = [ObjectMatcher matcherWithBaseObject:(x)]; \
if (0) {

#define objcase(x, ...) \
} else if ([___my_matcher___ matchesAnyObject:x, ## __VA_ARGS__ , [ObjectMatcher objectMatcherSentinel]]) {

#define objkind(y, ...) \
} else if ([___my_matcher___ matchesAnyClass:[y class], ## __VA_ARGS__ , [ObjectMatcher objectMatcherSentinel]]) {

#define defaultcase \
} else {

#define endswitch \
} \
}


// Variation that lets you use blocks.

#define oswitch(x) { ObjectMatcher *___my_matcher___ = [ObjectMatcher matcherWithBaseObject:(x)]; if (0) { ^{}
#define ocase(x, ...) (); } else if ([___my_matcher___ matchesAnyObject:x, ## __VA_ARGS__ , [ObjectMatcher objectMatcherSentinel]]) {
#define okind(y, ...) (); } else if ([___my_matcher___ matchesAnyClass:[y class], ## __VA_ARGS__ , [ObjectMatcher objectMatcherSentinel]]) {
#define odefault (); } else {
#define oend (); } }


// Variation that lets you do similar fake switch statements with selectors.

#define selswitch(x) \
{ \
SelectorMatcher *___my_matcher___ = [SelectorMatcher matcherWithBaseSelector:(@selector(x))]; \
if (0) {

#define selcase(x, ...) \
} else if ([___my_matcher___ matchesAnySelector:x, ## __VA_ARGS__ , [SelectorMatcher selectorMatcherSentinel]]) {

