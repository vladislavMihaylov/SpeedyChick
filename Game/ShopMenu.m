//
//  ShopMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ShopMenu.h"

#import "CCBReader.h"

@implementation ShopMenu

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration: 0.5 scene: scene]];
}

@end
