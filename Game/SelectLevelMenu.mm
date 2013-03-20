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
#import "Settings.h"
#import "GameConfig.h"

@implementation SelectLevelMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
    NSString *openedLevels = [NSString stringWithFormat: @"%i", [Settings sharedSettings].openedLevels];
    
    NSString *count = [openedLevels substringWithRange: NSMakeRange(currentWorld - 1, 1)];
    
    NSInteger countOfOpenedLevels = [count integerValue];
    
    NSString *stars = [NSString stringWithFormat: @"%@", [Settings sharedSettings].starsCount];
    
    //CCLOG(@"STARS: %@ %i", stars, currentWorld);
    
    CCMenu *levelsMenu = [CCMenu menuWithItems: nil];
    levelsMenu.position = ccp(0, 0);
    [self addChild: levelsMenu];
    
    for(int i = 0; i < 5; i++)
    {
        CCMenuItemImage *levelItem = nil;
        
        if(i < countOfOpenedLevels)
        {
            levelItem = [CCMenuItemImage itemFromNormalImage: @"openBg.png"
                                               selectedImage: @"openBg.png"
                                                      target: self
                                                    selector: @selector(playLevel:)
                         ];
            
            CCLabelTTF *num = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%i", (i+1)] fontName: @"Arial" fontSize: 20];
            num.position = ccp(levelItem.position.x + levelItem.contentSize.width/2, levelItem.position.y + levelItem.contentSize.height/2);
            [levelItem addChild: num];
            
            NSString *curStars = [stars substringWithRange: NSMakeRange(i + 1 + ((currentWorld - 1) * 5), 1)];
            
            CCSprite *stars = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%@stars.png", curStars]];
            stars.position = ccp(levelItem.contentSize.width/2, stars.contentSize.height/4);
            [levelItem addChild: stars];
        }
        else
        {
            levelItem = [CCMenuItemImage itemFromNormalImage: @"closeBg.png"
                                               selectedImage: @"closeBg.png"
                         ];
        }
        
        levelItem.tag = i;
        levelItem.position = ccp(80 + 80 * i, 160);
        [levelsMenu addChild: levelItem];
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInT transitionWithDuration: 0.5 scene: scene]];
}

- (void) playLevel: (CCMenuItem *) sender
{
    currentLevel = sender.tag + 1;
    
	[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
}

@end
