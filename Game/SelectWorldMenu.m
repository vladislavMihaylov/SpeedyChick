//
//  SelectWorldMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SelectWorldMenu.h"
#import "CCBReader.h"
#import "Settings.h"
#import "GameConfig.h"

@implementation SelectWorldMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
    
    CCMenu *worldsMenu = [CCMenu menuWithItems: nil];
    worldsMenu.position = ccp(0, 0);
    [self addChild: worldsMenu];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"SelectMenuFiles%@.plist", suffix]];
    
    for(int i = 0; i < 3; i++)
    {
        CCMenuItemImage *worldItem = nil;
        
        if(i < [Settings sharedSettings].openedWorlds)
        {
            
            worldItem = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"w_%i.png", i+1]]
                                               selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"w_%iOn.png", i+1]]
                                                       target: self
                                                     selector: @selector(pressedWorld:)];
        }
        else
        {
            worldItem = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"w_%i.png", i+1]]
                                               selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"w_%i.png", i+1]]];
            
            CCSprite *block = [CCSprite spriteWithSpriteFrameName: @"block.png"];
            block.position = ccp(worldItem.contentSize.width / 2, worldItem.contentSize.height / 2);
            [worldItem addChild: block];
        }
        
        worldItem.tag = i;
        
        worldItem.position = ccp((GameWidth / 4.8) + (GameWidth / 3.42857) * i, GameCenterY);
        
        [worldsMenu addChild: worldItem z: 10];
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"MainMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedWorld: (CCMenuItem *) sender
{
    currentWorld = sender.tag + 1;
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectLevelMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
