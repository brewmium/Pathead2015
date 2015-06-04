//
//  NSObject+brewmium.m
//
//  Created by Eric Hayes on 6/4/15.
//  Copyright (c) 2015 Brewmium, LLC. All rights reserved.
//

#import "NSObject+brewmium.h"

@implementation NSObject (brewmium)


- (void)delayedAction:(NSTimeInterval)delay closure:(void (^)(void))closure;
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
				   dispatch_get_main_queue(),
				   closure);
}

+ (void)delayedAction:(NSTimeInterval)delay closure:(void (^)(void))closure;
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
				   dispatch_get_main_queue(),
				   closure);
}

@end
