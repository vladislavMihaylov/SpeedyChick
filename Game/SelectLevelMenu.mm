//
//  SelectLevelMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SelectLevelMenu.h"

#import "GameLayer.h"

#import "CCBReader.h"

#import "GameConfig.h"

@implementation SelectLevelMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration: 0.5 scene: scene]];
}

- (void) playLevel: (CCMenuItem *) sender
{
    currentLevel = sender.tag;
    
	[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

@end
