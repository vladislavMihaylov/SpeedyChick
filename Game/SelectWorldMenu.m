//
//  SelectWorldMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SelectWorldMenu.h"
#import "CCBReader.h"

@implementation SelectWorldMenu

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedWorld
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectLevelMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration: 0.5 scene: scene]];
}

@end
