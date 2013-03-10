//
//  CustomizeMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomizeMenu.h"
#import "Settings.h"
#import "CCBReader.h"

#import "GameConfig.h"

@implementation CustomizeMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInL transitionWithDuration: 0.5 scene: scene]];
}

- (void) setCurrentPinguin: (CCMenuItem *) sender
{
    [Settings sharedSettings].currentPinguin = sender.tag;
    [[Settings sharedSettings] save];
    CCLOG(@"OK");
}

@end
