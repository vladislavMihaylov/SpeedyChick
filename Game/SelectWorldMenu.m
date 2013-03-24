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
    //CCLOG(@"curStars %@", [Settings sharedSettings].starsCount);
    //CCLOG(@"curLevels %@", [Settings sharedSettings].openedLevels);
    
    CCMenu *worldsMenu = [CCMenu menuWithItems: nil];
    worldsMenu.position = ccp(0, 0);
    [self addChild: worldsMenu];
    
    for(int i = 0; i < 3; i++)
    {
        CCMenuItemImage *worldItem = nil;
        
        if(i < [Settings sharedSettings].openedWorlds)
        {
            worldItem = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"w_%i.png", i+1]
                                               selectedImage: [NSString stringWithFormat: @"w_%iOn.png", i+1]
                                                      target: self
                                                    selector: @selector(pressedWorld:)
                                          ];
        }
        else
        {
            worldItem = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"w_%i.png", i+1]
                                               selectedImage: [NSString stringWithFormat: @"w_%i.png", i+1]
                         ];
             //worldItem.opacity = 200;
            
            CCSprite *block = [CCSprite spriteWithFile: @"block.png"];
            block.position = ccp(worldItem.contentSize.width / 2, worldItem.contentSize.height / 2);
            [worldItem addChild: block];
            
        }
        
        worldItem.tag = i;
       
        worldItem.position = ccp(100 + 140 * i, 160);
        [worldsMenu addChild: worldItem];
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedWorld: (CCMenuItem *) sender
{
    currentWorld = sender.tag + 1;
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectLevelMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
