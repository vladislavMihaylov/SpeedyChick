//
//  Coin.m
//  Game
//
//  Created by Vlad on 30.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Coin.h"
#import "GameConfig.h"

@implementation Coin

@synthesize isActive;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"mainMenuTextures%@.plist", suffix]];
        
        coinSprite = [CCSprite spriteWithSpriteFrameName: @"coin.png"];
        [self addChild: coinSprite];
        
        CGSize spriteSize = [coinSprite contentSize];
        self.contentSize = spriteSize;
        
        isActive = YES;
    }
    
    return self;
}

@end
