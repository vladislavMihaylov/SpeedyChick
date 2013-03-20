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
    
    for(int i = 0; i < 3; i++)
    {
        CCMenuItemImage *worldItem = nil;
        
        if(i < [Settings sharedSettings].openedWorlds)
        {
            worldItem = [CCMenuItemImage itemFromNormalImage: @"openBg.png"
                                                                selectedImage: @"openBg.png"
                                                                       target: self
                                                                     selector: @selector(pressedWorld:)
                                          ];
            
            CCLabelTTF *num = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%i", (i+1)] fontName: @"Arial" fontSize: 20];
            num.position = ccp(worldItem.position.x + worldItem.contentSize.width/2, worldItem.position.y + worldItem.contentSize.height/2);
            [worldItem addChild: num];
        }
        else
        {
            worldItem = [CCMenuItemImage itemFromNormalImage: @"closeBg.png"
                                               selectedImage: @"closeBg.png"
                         ];
        }
        
        worldItem.tag = i;
        worldItem.position = ccp(120 + 120 * i, 160);
        [worldsMenu addChild: worldItem];
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedWorld: (CCMenuItem *) sender
{
    currentWorld = sender.tag + 1;
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectLevelMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInB transitionWithDuration: 0.5 scene: scene]];
}

@end
