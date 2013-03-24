//
//  Configuration.m
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Configuration.h"
#import "Settings.h"
#import "GameConfig.h"


@implementation Configuration


Configuration *sharedConfiguration = nil;

+ (Configuration *) sharedConfiguration
{
    if(!sharedConfiguration)
    {
        sharedConfiguration = [[Configuration alloc] init];
    }
    
    return sharedConfiguration;
}

- (void) dealloc
{
    
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        
    }
    
    return self;
}

- (void) setConfig
{
    //[Settings sharedSettings].starsCount = @"4000000000000000";
    //[Settings sharedSettings].openedWorlds = 1;
    //[Settings sharedSettings].openedLevels = @"4100000000000000";
    //[Settings sharedSettings].countOfCoins = 110;
    //[Settings sharedSettings].isAdEnabled = YES;
    //[Settings sharedSettings].isFirstRun = YES;
    //[Settings sharedSettings].isKidsModeBuyed = NO;
    //[Settings sharedSettings].isSuperChickBuyed = NO;
    //[Settings sharedSettings].isGhostChickBuyed = NO;
    
    //[Settings sharedSettings].futureDate = @"";
    
    //CCLOG(@"DATE %@",[Settings sharedSettings].futureDate);
    
    //CCLOG(@"difference %f", [[Settings sharedSettings].futureDate timeIntervalSinceNow]);
        
    if([Settings sharedSettings].isKidsModeBuyed)
    {
        [Settings sharedSettings].isCatEnabled = NO;
        [[Settings sharedSettings] save];
    }
    else
    {
        [Settings sharedSettings].isCatEnabled = YES;
        [[Settings sharedSettings] save];
    }
    
    if([Settings sharedSettings].isSuperChickBuyed)
    {
        currentHeightOfFly = 1000;
        currentSpeedOfFly = 50;
    }
    else
    {
        currentHeightOfFly = defaultHeightOfFly;
        currentSpeedOfFly = defaultSpeedOfFly;
    }
    
    [[Settings sharedSettings] save];
}

@end
