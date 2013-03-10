//
//  MainMenu.m
//  Game
//
//  Created by Vlad on 06.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "Settings.h"

#import "CCBReader.h"

@implementation MainMenu

- (void) didLoadFromCCB
{
    CCSprite *curPinguinSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"pinguin_%i.png", [Settings sharedSettings].currentPinguin]];
    curPinguinSprite.position = curPinguin.position;
    [self addChild: curPinguinSprite];
    
    
    CCSprite *curRocketSprite = [CCSprite spriteWithFile: @"rocket.png"];
    curRocketSprite.position = curRockets.position;
    [self addChild: curRocketSprite];
    
    rocketsLabel.string = [NSString stringWithFormat: @"%i rockets", [Settings sharedSettings].countOfRockets];
}

- (void) updateRocketsString
{
    rocketsLabel.string = [NSString stringWithFormat: @"%i rockets", [Settings sharedSettings].countOfRockets];
}

- (void) dealloc
{
    [super dealloc];
}

- (void) pressedPlay
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectWorldMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedGetCoins
{
    [Settings sharedSettings].countOfRockets ++;
    [[Settings sharedSettings] save];
    
    [self updateRocketsString];
}

- (void) pressedCustomise
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"CustomizeMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedShop
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"ShopMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInL transitionWithDuration: 0.5 scene: scene]];
}

@end
