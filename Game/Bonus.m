//
//  Bonus.m
//  Game
//
//  Created by Vlad on 09.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Bonus.h"
#import "GameConfig.h"

@implementation Bonus

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
        
        bonusSprite = [CCSprite spriteWithSpriteFrameName: @"rocket.png"];
        [self addChild: bonusSprite];
        
        CGSize spriteSize = [bonusSprite contentSize];
        self.contentSize = spriteSize;
        
        isActive = YES;
    }
    
    return self;
}

@end
