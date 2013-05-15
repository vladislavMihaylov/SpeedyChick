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

- (void) setParameters
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        suffix = @"-ipad";
        coefForCoords = 2;
        
        GameWidth = kWidthIPAD;
        GameHeight = kHeightIPAD;
        
        rectForTextField = CGRectMake(220, 475, 320, 70); //CGRectMa
        textFontSize = 50;
        
        bodyRadius = iPadRadius;
        
        currentHeightOfFly = defaultHeightOfFlyIPAD;
        currentSpeedOfFly = defaultSpeedOfFlyIPAD;
        
        minSpeedX = minVelocityXIPAD;
        minSpeedY = minVelocityYIPAD;
        
        forceY = forceYIPAD;
        
        thisisRECT = iPadShopRect;
        customizeRect = iPadCustomizeRect;
        shopTextScale = iPadShopTextScale;
        noAdsBtnMultiplier = iPadNoAdsBtnMultiplier;
        restoreBtnMultiplier = iPadRestoreBtnMultiplier;
        customItemXcoefForPos = iPadCustomItemXcoefForPos;
        customItemHeightParameter = iPadCustomItemHeightParameter;
        customItemMultiplier = iPadCustomItemMultiplier;
        customItemScale = iPadCustomItemScale;
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
        
        thisisRECT = iPhoneShopRect;
        customizeRect = iPhoneCustomizeRect;
        shopTextScale = iPhoneShopTextScale;
        noAdsBtnMultiplier = iPhoneNoAdsBtnMultiplier;
        restoreBtnMultiplier = iPhoneRestoreBtnMultiplier;
        customItemXcoefForPos = iPhoneCustomItemXcoefForPos;
        customItemHeightParameter = iPhoneCustomItemHeightParameter;
        customItemMultiplier = iPhoneCustomItemMultiplier;
        customItemScale = iPhoneCustomItemScale;
    }
    
    //[Settings sharedSettings].countOfCoins = 1111;
    //[Settings sharedSettings].buyedCustomiziedChicks = @"1000000000";
    
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

@end
