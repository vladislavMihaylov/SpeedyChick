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
#import "SimpleAudioEngine.h"

@implementation SelectWorldMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
    
    worldsMenu = [CCMenu menuWithItems: nil];
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
        
        if(worldItem.tag == 1)
        {
            worldItem.cost = 1000;
        }
        else if(worldItem.tag == 2)
        {
            worldItem.cost = 12500;
        }
        
        worldItem.position = ccp((GameWidth / 4.8) + (GameWidth / 3.42857) * i, GameCenterY);
        
        [worldsMenu addChild: worldItem z: 10];
    }
}

- (void) back
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"MainMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) buyWorld: (CCMenuItem *) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    CCLOG(@"COST: %i", sender.cost);
    if([Settings sharedSettings].countOfCoins < sender.cost)
    {
        [self showAlert: [NSString stringWithFormat: @"You need\n %i coins!", sender.cost]];
    }
    else
    {
        [self showBuyingAlert: sender];
    }
}

- (void) pressedWorld: (CCMenuItem *) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    currentWorld = sender.tag + 1;
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectLevelMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) showAlert: (NSString *) message
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    worldsMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: message fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    [bg addChild: alert];
    
    CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]] selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                                            target: self selector: @selector(hideAlert)];
    okBtn.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.2);
    
    CCMenu *alertMenu = [CCMenu menuWithItems: okBtn, nil];
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) showBuyingAlert: (CCMenuItem *) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    worldsMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: @"Do you want\n buy the world?" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    [bg addChild: alert];
    
    CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]]
                                                    selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                                            target: self
                                                          selector: @selector(pressedBuy:)];
    okBtn.position = ccp(bg.contentSize.width * 0.3, bg.contentSize.height * 0.2);
    
    CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtn.png"]]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtnOn.png"]]
                                                                target: self selector: @selector(hideAlert)];
    
    cancelBtn.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.2);
    
    CCMenu *alertMenu = [CCMenu menuWithItems: okBtn, cancelBtn, nil];
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) hideAlert
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ButtonTap.wav"];
    
    worldsMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
}

- (void) pressedBuy: (CCMenuItem *) sender
{
    
}

@end
