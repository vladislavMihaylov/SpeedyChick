//
//  GlobalView.m
//  Game
//
//  Created by Vlad on 25.05.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GlobalView.h"


@implementation GlobalView

@synthesize globalView;

static GlobalView *globalView = nil;

+ (GlobalView *) sharedView
{
    @synchronized(self)
    {
        if(globalView == nil)
        {
            globalView = [NSAllocateObject([self class], 0, NULL) init];
        }
    }
    
    return globalView;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedView] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (void) release { }

- (id) autorelease
{
    return self;
}

@end
