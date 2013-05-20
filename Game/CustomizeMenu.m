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

#import "RagePurchase.h"
#import <StoreKit/StoreKit.h>

@implementation CustomizeMenu

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_products release];
    
    [super dealloc];
}

- (void) didLoadFromCCB
{
    isItemsLoaded = NO;
    
    [self updateChicks];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"shopItems%@.plist", suffix]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
    
    CCLayerColor *darkLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 127) width: GameCenterX height: GameHeight];
    darkLayer.position = ccp(GameCenterX, 0);
    [self addChild: darkLayer];
    menuPosY = GameCenterY;
    [self loadMenuOfChicks];
    
    [self scheduleUpdate];
    
    [[RagePurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success)
         {
             _products = [[NSArray alloc] initWithArray: products];
             
             isItemsLoaded = YES;
             [self showShopButtons];
         }
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:PurchaseProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name:PurchaseProductCanceledPurchaseNotification object:nil];
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
    coinsLabel.color = ccc3(0, 0, 255);
    
    [self removeChild: chicksMenu cleanup: YES];
    
    chicksMenu = [CCMenuAdvanced menuWithItems: nil];
    chicksMenu.position = ccp(GameCenterX, menuPosY);
    [self addChild: chicksMenu];
    
    int costs[11] = {0, 20000, 0, 250, 1000, 2500, 4000, 6500, 10000, 15000, 20000};
    
    NSMutableString *dataChicks = [NSMutableString stringWithString: [Settings sharedSettings].buyedCustomiziedChicks];
    CCLOG(@"%@", dataChicks);
    
    for(int i = 0; i < 11; i++)
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
            item.cost = costs[i];
            [chicksMenu addChild: item];
            
            CCSprite *chick = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", item.tag]];
            chick.position = ccp(chick.contentSize.width, item.contentSize.height / 2);
            [item addChild: chick];

            CCSprite *coin = [CCSprite spriteWithFile: @"coin.png"];
            coin.position = ccp(item.contentSize.width * 0.6, item.contentSize.height / 2);
            [item addChild: coin];
        
        
            CCLabelBMFont *price = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"%i", item.cost] fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
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
    
    CCLOG(@"Cost %i", sender.cost);
    
    NSString *curChick = [dataChicks substringWithRange: NSMakeRange(sender.tag-1, 1)];
    
    NSInteger curState = [curChick integerValue];
    
    if(curState == 0)
    {
        if([Settings sharedSettings].countOfCoins >= sender.cost)
        {
            curState = 1;
            NSString *new = [NSString stringWithFormat: @"%i", curState];
            
            [dataChicks replaceCharactersInRange: NSMakeRange(sender.tag-1, 1) withString: new];
            
            CCLOG(@"New string %@", dataChicks);
            
            [Settings sharedSettings].countOfCoins -= sender.cost;
            [Settings sharedSettings].buyedCustomiziedChicks = [NSString stringWithFormat: @"%@", dataChicks];
            
            [Settings sharedSettings].currentPinguin = sender.tag;
            [[Settings sharedSettings] save];
            
            [self loadMenuOfChicks];
        }
        else
        {
            [self showAlert: @" Not enough Coins! You\nneed more Coins for this.\n  Would you like to buy\n          some now?"
                       type: 1
                     sender: sender
             ];
        }
    }
    else
    {
        [Settings sharedSettings].currentPinguin = sender.tag;
        [[Settings sharedSettings] save];
        
        [self loadMenuOfChicks];
    }
    
}

/*- (void) showAlert: (NSString *) message
{
    rootMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: message fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    alert.color = ccc3(255, 255, 255);
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
}*/

/////

# pragma mark Alert

- (void) showAlert: (NSString *) message type: (NSInteger) type sender: (CCMenuItem *) sender
{
    chicksMenu.isTouchEnabled = NO;
    rootMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: message fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    alert.color = ccc3(255, 255, 255);
    [bg addChild: alert];
    
    waitingLabel = [CCLabelBMFont labelWithString: @"Waiting..." fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    waitingLabel.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.25);
    [bg addChild: waitingLabel];
    
    alertMenu = [CCMenu menuWithItems: nil];
    
    if(type == 1)
    {
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtn.png"]]
                                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtnOn.png"]]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.25, bg.contentSize.height * 0.25);
        
        //------->
        
        coins1000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"1000coins.png"]
                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: @"1000coinsOn.png"]
                                                   target: self
                                                 selector: @selector(buyfeature:)
                     ];
        
        
        coins1000.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.4);
        coins1000.tag = p_coins1000;
        coins1000.isEnabled = NO;
        coins1000.opacity = 0;
        
        
        
        
        coins5000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"5000coins.png"]
                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: @"5000coinsOn.png"]
                                                   target: self
                                                 selector: @selector(buyfeature:)
                     ];
        
        coins5000.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.25);
        coins5000.tag = p_coins5000;
        coins5000.isEnabled = NO;
        coins5000.opacity = 0;
        
        
        coins20000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"20000coins.png"]
                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: @"20000coinsOn.png"]
                                                    target: self
                                                  selector: @selector(buyfeature:)
                      ];
        
        coins20000.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.1);
        coins20000.tag = p_coins20000;
        coins20000.isEnabled = NO;
        coins20000.opacity = 0;
        
        //------->
        
        [alertMenu addChild: cancelBtn];
        [alertMenu addChild: coins1000];
        [alertMenu addChild: coins5000];
        [alertMenu addChild: coins20000];
        
        alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.7);
        
        // -----
        
        if(isItemsLoaded)
        {
            [self showShopButtons];
        }
    }
    
    
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) hideAlert
{
    chicksMenu.isTouchEnabled = YES;
    rootMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
    alertMenu = nil;
    CCLOG(@"MENU: %@", alertMenu);
}

- (void) showShopButtons
{
    coins1000.isEnabled = YES;
    coins5000.isEnabled = YES;
    coins20000.isEnabled = YES;
    
    coins1000.opacity = 255;
    coins5000.opacity = 255;
    coins20000.opacity = 255;
    
    waitingLabel.opacity = 0;
}

- (void) buyfeature: (CCMenuItem *) sender
{
    CCLOG(@"prod %@", _products);
    [self lockMenu];
    SKProduct *product = _products[sender.tag];
    
    [[RagePurchase sharedInstance] buyProduct: product];
}

- (void)productPurchased:(NSNotification *)notification
{
    coinsLabel.string = [NSString stringWithFormat: @"Coins: %i", [Settings sharedSettings].countOfCoins];
    [self unlockMenu];
    
}

- (void) purchaseCanceled: (NSNotification *) notification
{
    [self unlockMenu];
    
}


- (void) lockMenu
{
    alertMenu.isTouchEnabled = NO;
}

- (void) unlockMenu
{
    alertMenu.isTouchEnabled = YES;
}


@end
