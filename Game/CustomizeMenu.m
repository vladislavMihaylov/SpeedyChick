//
//  CustomizeMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CustomizeMenu.h"

#import "CCBReader.h"

@implementation CustomizeMenu

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInL transitionWithDuration: 0.5 scene: scene]];
}

@end
