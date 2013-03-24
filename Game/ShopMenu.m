//
//  ShopMenu.m
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ShopMenu.h"
#import "Settings.h"
#import "CCBReader.h"
#import "GameConfig.h"

@implementation ShopMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    CCMenuItemImage *kidsMode = [CCMenuItemImage itemFromNormalImage: @"kidsModeBtn.png"
                                                       selectedImage: @"kidsModeBtn.png"
                                                              target: self
                                                            selector: @selector(buyfeature:)
                                 ];
    
    kidsMode.position = item_1.position;
    kidsMode.tag = 1;
    
    CCMenuItemImage *superChick = [CCMenuItemImage itemFromNormalImage: @"superChickBtn.png"
                                                         selectedImage: @"superChickBtn.png"
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                   ];
    
    superChick.position = item_2.position;
    superChick.tag = 2;
    
    CCMenuItemImage *ghostChick = [CCMenuItemImage itemFromNormalImage: @"ghostChickBtn.png"
                                                         selectedImage: @"ghostChickBtn.png"
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                   ];
    
    ghostChick.position = item_3.position;
    ghostChick.tag = 3;
    
    CCMenu *shopMenu = [CCMenu menuWithItems: kidsMode, superChick, ghostChick, nil];
    shopMenu.position = ccp(0, 0);
    [self addChild: shopMenu];
    
    [self updateLabels];
}

- (void) updateLabels
{
    if([Settings sharedSettings].isKidsModeBuyed)
    {
        [Settings sharedSettings].isCatEnabled = NO;
        
        CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
        okLabel.position = ccp(item_1.position.x, item_1.position.y - 70);
        [self addChild: okLabel z: 1 tag: 555];
    }
    
    if([Settings sharedSettings].isSuperChickBuyed)
    {
        currentHeightOfFly = 1000;
        currentSpeedOfFly = 50;
        
        CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
        okLabel.position = ccp(item_2.position.x, item_2.position.y - 70);
        [self addChild: okLabel z: 1 tag: 556];
    }
    
    if([Settings sharedSettings].isGhostChickBuyed)
    {
        
        CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
        okLabel.position = ccp(item_3.position.x, item_3.position.y - 70);
        [self addChild: okLabel z: 1 tag: 557];
    }
}

- (void) buyfeature: (CCMenuItem *) sender
{
    if(sender.tag == 1)
    {
        [Settings sharedSettings].isKidsModeBuyed = ![Settings sharedSettings].isKidsModeBuyed;
        [[Settings sharedSettings] save];
        
        if([Settings sharedSettings].isKidsModeBuyed)
        {
            [Settings sharedSettings].isCatEnabled = NO;
            
            CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
            okLabel.position = ccp(item_1.position.x, item_1.position.y - 70);
            [self addChild: okLabel z: 1 tag: 555];
        }
        else
        {
            [Settings sharedSettings].isCatEnabled = YES;
            
            [self removeChildByTag: 555 cleanup: YES];
        }
    }
    
    if(sender.tag == 2)
    {
        [Settings sharedSettings].isSuperChickBuyed = ![Settings sharedSettings].isSuperChickBuyed;
        [[Settings sharedSettings] save];
        
        if([Settings sharedSettings].isSuperChickBuyed)
        {
            currentHeightOfFly = 1000;
            currentSpeedOfFly = 50;
            
            CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
            okLabel.position = ccp(item_2.position.x, item_2.position.y - 70);
            [self addChild: okLabel z: 1 tag: 556];
        }
        else
        {
            currentHeightOfFly = defaultHeightOfFly;
            currentSpeedOfFly = defaultSpeedOfFly;
            
            [self removeChildByTag: 556 cleanup: YES];
        }
    }
    
    if(sender.tag == 3)
    {
        [Settings sharedSettings].isGhostChickBuyed = ![Settings sharedSettings].isGhostChickBuyed;
        [[Settings sharedSettings] save];
        
        if([Settings sharedSettings].isGhostChickBuyed)
        {
            CCLabelBMFont *okLabel = [CCLabelBMFont labelWithString: @"OK" fntFile: @"timeFont.fnt"];
            okLabel.position = ccp(item_3.position.x, item_3.position.y - 70);
            [self addChild: okLabel z: 1 tag: 557];
        }
        else
        {
            [self removeChildByTag: 557 cleanup: YES];
        }
    }
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
