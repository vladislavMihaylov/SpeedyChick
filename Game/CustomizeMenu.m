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

- (void) didLoadFromCCB
{
    [self updateChicks];
}

- (void) updateChicks
{
    CCArray *allItems = [self children];
    
    for (CCNode *curItem in allItems)
    {
        CCLOG(@"Item: %@", curItem);
        
        if(curItem.tag == 999)
        {
            CCArray *menuItems = [curItem children];
            
            for(CCNode *curChick in menuItems)
            {
                if(curChick.tag == [Settings sharedSettings].currentPinguin)
                {
                    [curChick runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration:0.1 scale: 1.3]]];
                }
                else
                {
                    [curChick runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration:0.1 scale: 1]]];
                }
            }
        }
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"MainMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) setCurrentPinguin: (CCMenuItem *) sender
{
    [Settings sharedSettings].currentPinguin = sender.tag;
    [[Settings sharedSettings] save];
    
    [self updateChicks];
    
    CCLOG(@"OK");
}

@end
