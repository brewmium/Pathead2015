//
//  NSObject+brewmium.m
//
//  Created by Eric Hayes on 6/4/15.
//  Copyright (c) 2015 Brewmium, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (brewmium)

- (void)delayedAction:(NSTimeInterval)delay closure:(void (^)(void))closure;
+ (void)delayedAction:(NSTimeInterval)delay closure:(void (^)(void))closure;

@end
