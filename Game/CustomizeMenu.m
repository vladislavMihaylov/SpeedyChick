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
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
    
    CCLayerColor *darkLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 127) width: GameCenterX height: GameHeight];
    darkLayer.position = ccp(GameCenterX, 0);
    [self addChild: darkLayer];
    menuPosY = GameCenterY;
    [self loadMenuOfChicks];
    
    [self scheduleUpdate];
}

- (void) updateBigChick
{
    [self removeChild: bigChick cleanup: YES];
    
    bigChick = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", [Settings sharedSettings].currentPinguin]];
    bigChick.scale = 2;
    bigChick.position = ccp(GameCenterX / 2, GameCenterY);
    [self addChild: bigChick];
}

- (void) loadMenuOfChicks
{
    [self updateBigChick];
    
    coinsLabel.string = [NSString stringWithFormat: @"Coins: %i", [Settings sharedSettings].countOfCoins];
    
    [self removeChild: chicksMenu cleanup: YES];
    
    chicksMenu = [CCMenuAdvanced menuWithItems: nil];
    chicksMenu.position = ccp(GameCenterX, menuPosY);
    [self addChild: chicksMenu];
    
    NSMutableString *dataChicks = [NSMutableString stringWithString: [Settings sharedSettings].buyedCustomiziedChicks];
    CCLOG(@"%@", dataChicks);
    
    for(int i = 0; i < 10; i++)
    {
        NSString *curChicken = [dataChicks substringWithRange: NSMakeRange(i, 1)];
        
        NSInteger curState = [curChicken integerValue];
        
        if(curState != 1)
        {
            CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"customItem%@.png", suffix]
                                                           selectedImage: [NSString stringWithFormat: @"customItemOn%@.png", suffix]
                                                                  target: self
                                                                selector: @selector(setCurrentPinguin:)
                                     ];
            
            item.position = ccp(GameWidth - item.contentSize.width / 2 - customItemXcoefForPos, GameHeight + customItemHeightParameter - ((item.contentSize.height * customItemMultiplier - 30) * (i+1)));
            item.tag = i + 1;
            [chicksMenu addChild: item];
            
            CCSprite *chick = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", item.tag]];
            chick.position = ccp(chick.contentSize.width, item.contentSize.height / 2);
            [item addChild: chick];

            CCSprite *coin = [CCSprite spriteWithFile: @"coin.png"];
            coin.position = ccp(item.contentSize.width * 0.6, item.contentSize.height / 2);
            [item addChild: coin];
        
        
            CCLabelBMFont *price = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", 50 /*+ (10 * i)*/] fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
            price.position = ccp(item.contentSize.width * 0.7, item.contentSize.height / 2);
            
            price.anchorPoint = ccp(0, 0.5);
            [item addChild: price];
            
            item.scale = customItemScale;
        }
        else
        {
            CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"customItem%@.png", suffix]
                                                           selectedImage: [NSString stringWithFormat: @"customItemOn%@.png", suffix]
                                                                  target: self
                                                                selector: @selector(setCurrentPinguin:)
                                     ];
            
            item.position = ccp(GameWidth - item.contentSize.width / 2 - customItemXcoefForPos, GameHeight + customItemHeightParameter - ((item.contentSize.height * customItemMultiplier - 30) * (i+1)));
            item.tag = i + 1;
            [chicksMenu addChild: item];
            
            CCSprite *chick = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", item.tag]];
            chick.position = ccp(chick.contentSize.width, item.contentSize.height / 2);
            [item addChild: chick];
            
            if(i != 0)
            {
                CCLabelBMFont *price = [CCLabelBMFont labelWithString: @"Purchased!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
                price.position = ccp(item.contentSize.width * 0.45, item.contentSize.height / 2);
                price.anchorPoint = ccp(0, 0.5);
                [item addChild: price];
            }
            else
            {
                CCLabelBMFont *price = [CCLabelBMFont labelWithString: @"Ready!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
                price.position = ccp(item.contentSize.width * 0.45, item.contentSize.height / 2);
                price.anchorPoint = ccp(0, 0.5);
                [item addChild: price];
            }
            
            if(i == 0)
            {
                chicksMenu.boundaryRect = customizeRect;
                //CCLOG(@"y %f width %f", GameHeight + 152 - ((item.contentSize.height * 1.33 - 30) * 1), GameWidth);
            }
            
            item.scale = customItemScale;
        }
        
        
    }
    
}

- (void) update: (ccTime) time
{
    if(fabs(chicksMenu.position.y - menuPosY) != 0)
    {
        menuPosY = chicksMenu.position.y;
    }
}

/////////////

- (void) updateChicks
{
    
    
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
    
    NSString *curChick = [dataChicks substringWithRange: NSMakeRange(sender.tag-1, 1)];
    
    NSInteger curState = [curChick integerValue];
    
    if(curState == 0)
    {
        if([Settings sharedSettings].countOfCoins >= 50)
        {
            curState = 1;
            NSString *new = [NSString stringWithFormat: @"%i", curState];
            
            [dataChicks replaceCharactersInRange: NSMakeRange(sender.tag-1, 1) withString: new];
            
            CCLOG(@"New string %@", dataChicks);
            
            [Settings sharedSettings].countOfCoins -= 50;
            [Settings sharedSettings].buyedCustomiziedChicks = [NSString stringWithFormat: @"%@", dataChicks];
            
            [Settings sharedSettings].currentPinguin = sender.tag;
            [[Settings sharedSettings] save];
            
            [self loadMenuOfChicks];
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
        
        [self loadMenuOfChicks];
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
