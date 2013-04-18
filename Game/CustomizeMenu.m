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
    coinsLabel.string = [NSString stringWithFormat: @"Coins: %i", [Settings sharedSettings].countOfCoins];
    
    CCArray *allItems = [self children];
    
    for (CCNode *curItem in allItems)
    {
        if(curItem.tag == 999)
        {
            CCArray *menuItems = [curItem children];
            
            NSMutableString *dataChicks = [NSMutableString stringWithString: [Settings sharedSettings].buyedCustomiziedChicks];
            
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
                
                if(curChick.tag > 0)
                {
                    NSString *curChicken = [dataChicks substringWithRange: NSMakeRange(curChick.tag - 1, 1)];
                    
                    NSInteger curState = [curChicken integerValue];
                    
                    if(curState == 0)
                    {
                        [curChick runAction: [CCFadeTo actionWithDuration: 0  opacity: 128]];
                    }
                    else
                    {
                        [curChick runAction: [CCFadeTo actionWithDuration: 0  opacity: 255]];
                    }
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
    NSMutableString *dataChicks = [NSMutableString stringWithString: [Settings sharedSettings].buyedCustomiziedChicks];
    
    CCLOG(@"String %@", dataChicks);
    
    NSString *curChick = [dataChicks substringWithRange: NSMakeRange(sender.tag - 1, 1)];
    
    NSInteger curState = [curChick integerValue];
    
    if(curState == 0)
    {
        if([Settings sharedSettings].countOfCoins >= 50)
        {
            curState = 1;
            NSString *new = [NSString stringWithFormat: @"%i", curState];
            
            [dataChicks replaceCharactersInRange: NSMakeRange(sender.tag - 1, 1) withString: new];
            
            CCLOG(@"New string %@", dataChicks);
            
            [Settings sharedSettings].countOfCoins -= 50;
            [Settings sharedSettings].buyedCustomiziedChicks = [NSString stringWithFormat: @"%@", dataChicks];
            
            [Settings sharedSettings].currentPinguin = sender.tag;
            [[Settings sharedSettings] save];
            
            [self updateChicks];
        }
        else
        {
            [self showAlert];
        }
    }
    else
    {
        [Settings sharedSettings].currentPinguin = sender.tag;
        [[Settings sharedSettings] save];
        
        [self updateChicks];
    }
    
    
}

- (void) showAlert
{
    rootMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: @"You need \n 50 coins!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
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

- (void) hideAlert
{
    rootMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
}

@end
