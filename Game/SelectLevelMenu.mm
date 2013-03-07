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

@implementation SelectLevelMenu

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration: 0.5 scene: scene]];
}

- (void) playLevel
{
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration: 0.5 scene: [GameLayer scene]]];
}

@end
