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
    //[Settings sharedSettings].isGhostChickBuyed = YES;
    
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
    
    [[Settings sharedSettings] save];
}

- (void) setParameters
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        suffix = @"-ipad";
        coefForCoords = 2;
        
        GameWidth = kWidthIPAD;
        GameHeight = kHeightIPAD;
        
        rectForTextField = CGRectMake(150, 475, 320, 70);
        textFontSize = 50;
        
        bodyRadius = iPadRadius;
        
        currentHeightOfFly = defaultHeightOfFlyIPAD;
        currentSpeedOfFly = defaultSpeedOfFlyIPAD;
        
        minSpeedX = minVelocityXIPAD;
        minSpeedY = minVelocityYIPAD;
        
        forceY = forceYIPAD;
    }
    else
    {
        suffix = @"";
        coefForCoords = 1;
        
        GameWidth = kWidthIPHONE;
        GameHeight = kHeightIPHONE;
        
        rectForTextField = CGRectMake(10, 220, 240, 40);
        textFontSize = 30;
        
        bodyRadius = iPhoneRadius;
        
        currentHeightOfFly = defaultHeightOfFly;
        currentSpeedOfFly = defaultSpeedOfFly;
        
        minSpeedX = minVelocityXIPHONE;
        minSpeedY = minVelocityYIPHONE;
        
        forceY = forceYIPHONE;
    }
    
    GameCenterX = GameWidth / 2;
    GameCenterY = GameHeight / 2;
    
    catStartPosition = CGPointMake(40, 40);
    cocoStartPosition = CGPointMake(GameCenterX, 40);
    finishPointForCoco = CGPointMake(GameWidth - 40, 40);
    
    // Bonuses and purchase
    
    if([Settings sharedSettings].isSuperChickBuyed)
    {
        currentHeightOfFly *= 2;
        currentSpeedOfFly *= 2;
        
        minSpeedX *= 1.5;
    }
}

@end
