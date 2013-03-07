//
//  MainMenu.m
//  Game
//
//  Created by Vlad on 06.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameLayer.h"

#import "CCBReader.h"

@implementation MainMenu

- (void) pressedPlay
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectWorldMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedGetCoins
{
    CCLOG(@"PressedGetCoins");
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
