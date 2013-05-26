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

#import "RagePurchase.h"
#import <StoreKit/StoreKit.h>

#import "RootViewController.h"

@implementation SelectLevelMenu

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [_products release];
    [super dealloc];
}

- (void) didLoadFromCCB
{
    if([Settings sharedSettings].isAdEnabled)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"showBanner" object: nil];
    }
    
    if([Settings sharedSettings].countOfRuns > 1)
    {
        if([Settings sharedSettings].isAdEnabled)
        {
            viewController = [[RootViewController alloc] initWithNibName: nil bundle: nil];
            [viewController view];
            viewController.wantsFullScreenLayout = YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name: PurchaseProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name: PurchaseProductCanceledPurchaseNotification object:nil];
    
    isItemsLoaded = NO;
    
    levelsMenu = [CCMenu menuWithItems: nil];
    levelsMenu.position = ccp(0, 0);
    [self addChild: levelsMenu];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"SelectMenuFiles%@.plist", suffix]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"shopItems%@.plist", suffix]];
    
    [self updateItems];
    
    
}

- (void) updateItems
{
    int cost[15] = {0, 100, 200, 500, 750, 1000, 2000, 5000, 7500, 10000, 12500, 15000, 20000, 30000, 50000};
    
    [levelsMenu removeAllChildrenWithCleanup: YES];
    
    NSString *openedLevels = [NSString stringWithFormat: @"%@", [Settings sharedSettings].openedLevels];
    
    NSInteger positionForStar = (5 * (currentWorld - 1)) + 1;
    
    NSString *count = [openedLevels substringWithRange: NSMakeRange(positionForStar, 5)];
    
    //CCLOG(@"Count: %@", count);
    
    //NSInteger countOfOpenedLevels = [count integerValue];
    
    NSString *stars = [NSString stringWithFormat: @"%@", [Settings sharedSettings].starsCount];
    
    for(int i = 0; i < 5; i++)
    {
        CCMenuItemImage *levelItem = nil;
        
        NSString *curNum = [count substringWithRange: NSMakeRange(i, 1)];
        
        if([curNum integerValue] == 1)
        {
            levelItem = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"lvlItem.png"]]
                                               selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"lvlItemOn.png"]]
                                                      target: self
                                                    selector: @selector(playLevel:)
                         ];
            
            CCLabelTTF *num = [CCLabelTTF labelWithString: [NSString stringWithFormat: @"%i", (i+1)]
                                                 fontName: @"Arial"
                                                 fontSize: 20
                               ];
            
            num.position = ccp(levelItem.position.x + levelItem.contentSize.width/2,
                               levelItem.position.y + levelItem.contentSize.height/2);
            
            [levelItem addChild: num];
            
            //CCLOG(@"stars %@", stars);
            
            NSString *curStars = [stars substringWithRange: NSMakeRange(i + 1 + ((currentWorld - 1) * 5), 1)];
            
            //CCLOG(@"curStars %@", curStars);
            
            CCSprite *stars = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"%@stars.png", curStars]];
            stars.position = ccp(levelItem.contentSize.width/2, stars.contentSize.height/10);
            stars.scale = 0.5;
            [levelItem addChild: stars];
        }
        else
        {
            levelItem = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"lvlItem.png"]]
                                               selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"lvlItemOn.png"]]
                                                       target: self
                                                     selector: @selector(showNotification:)
                         ];
            
            CCSprite *block = [CCSprite spriteWithSpriteFrameName: @"block.png"];
            block.position = ccp(levelItem.contentSize.width / 2, levelItem.contentSize.height / 2);
            block.scale = 0.5;
            [levelItem addChild: block];
            
            //levelItem.opacity = 100;
        }
        
        
        
        levelItem.tag = i;
        levelItem.cost = cost[i + (5 * (currentWorld - 1))];
        levelItem.position = ccp(GameWidth / 6 + GameWidth / 6 * i, GameCenterY);
        [levelsMenu addChild: levelItem];
    }
}

- (void) showNotification: (CCMenuItem *) sender
{
    if([Settings sharedSettings].countOfCoins < sender.cost)
    {
        [self showAlert: [NSString stringWithFormat: @"Not enough Coins!\nTo unlock the level\nyou need %i Coins.\n  Would you like\n to buy some now?", sender.cost]
                   type: 2
                 sender: sender
         ];
    }
    else
    {
        [self showAlert: [NSString stringWithFormat: @"   You have unlocked \nthe level for %i Coins!", sender.cost]
                   type: 1
                 sender: sender
         ];
    }
}

/*- (void) showBuyMenu: (CCMenuItem *) sender
{
    levelsMenu.isTouchEnabled = NO;
    selectLevelMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCMenuItemImage *okBtn;
    CCMenuItemImage *cancelBtn;
    
    CCMenu *buyMenu;
    
    CCLabelBMFont *label;
    
    if([Settings sharedSettings].countOfCoins < sender.cost)
    {
        label = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"You need\n %i coins!", sender.cost] fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        label.position = ccp(bg.contentSize.width * 0.5, bg.contentSize.height * 0.5);
        label.color = ccc3(255, 255, 255);
        [bg addChild: label];
        
        okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]]
                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                               target: self
                                             selector: @selector(removeBuyMenu)
                 ];
        
        
        
        okBtn.position = ccp(bg.contentSize.width * 0.5, bg.contentSize.height * 0.15);
        
        buyMenu = [CCMenu menuWithItems: okBtn, nil];
        buyMenu.position = ccp(0, 0);
        [bg addChild: buyMenu];
    }
    else
    {
        label = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"  Do you want \n buy the level?\n (%i coins)", sender.cost] fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        label.color = ccc3(255, 255, 255);
        label.position = ccp(bg.contentSize.width * 0.5, bg.contentSize.height * 0.5);
        [bg addChild: label];
        
        okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]]
                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                               target: self
                                             selector: @selector(buyLevel:)
                 ];
        
        okBtn.tag = sender.tag;
        okBtn.position = ccp(bg.contentSize.width * 0.3, bg.contentSize.height * 0.15);
        
        
        cancelBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtn.png"]]
                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtnOn.png"]]
                                                   target: self
                                                 selector: @selector(removeBuyMenu)
                     ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.15);
        
        buyMenu = [CCMenu menuWithItems: okBtn, cancelBtn, nil];
        buyMenu.position = ccp(0, 0);
        [bg addChild: buyMenu];
    }
        
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) removeBuyMenu
{
    levelsMenu.isTouchEnabled = YES;
    selectLevelMenu.isTouchEnabled = YES;
    
    [self removeChildByTag: 31 cleanup: YES];
}*/

# pragma mark Alert

- (void) showAlert: (NSString *) message type: (NSInteger) type sender: (CCMenuItem *) sender
{
    levelsMenu.isTouchEnabled = NO;
    selectLevelMenu.isTouchEnabled = NO;
    
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
    
    
    if(type == 1) // okBtn & cancelBtn
    {
        CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                                                target: self
                                                              selector: @selector(buyLevel:)
                                  ];
        
        okBtn.tag = sender.tag;
        okBtn.position = ccp(bg.contentSize.width * 0.3, bg.contentSize.height * 0.15);
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtn.png"]]
                                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtnOn.png"]]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
        waitingLabel.opacity = 0;
    }
    if(type == 2)
    {
        
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                   target: self
                                                                 selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.25);
        
        //------->
        
        coins1000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"1000coins.png"]
                                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: @"1000coinsOn.png"]
                                                                    target: self
                                                                  selector: @selector(buyfeature:)
                                      ];
        
        
        coins1000.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.4);
        coins1000.tag = p_coins1000;
        coins1000.isEnabled = NO;
        coins1000.opacity = 0;
        
        
        
        
        coins5000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"5000coins.png"]
                                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: @"5000coinsOn.png"]
                                                                    target: self
                                                                  selector: @selector(buyfeature:)
                                      ];
        
        coins5000.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.25);
        coins5000.tag = p_coins5000;
        coins5000.isEnabled = NO;
        coins5000.opacity = 0;
        
        
        coins20000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"20000coins.png"]
                                                             selectedSprite: [CCSprite spriteWithSpriteFrameName: @"20000coinsOn.png"]
                                                                     target: self
                                                                   selector: @selector(buyfeature:)
                                       ];
        
        coins20000.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.1);
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
    
    [[RagePurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success)
         {
             _products = [[NSArray alloc] initWithArray: products];
             
             isItemsLoaded = YES;
             [self showShopButtons];
         }
     }];
        
    }
    
    
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) hideAlert
{
    levelsMenu.isTouchEnabled = YES;
    selectLevelMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
    _products = nil;
    alertMenu = nil;
    CCLOG(@"OK");
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
    
    SKProduct *product = _products[sender.tag];
    [self lockMenu];
    [[RagePurchase sharedInstance] buyProduct: product];
}

- (void)productPurchased:(NSNotification *)notification
{
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

- (void) buyLevel: (CCMenuItem *) sender
{
    [Settings sharedSettings].countOfCoins -= sender.cost;
    [[Settings sharedSettings] save];
    
    NSInteger curLevel = sender.tag + 1;
    
    //CCLOG(@"Item tag: %i", sender.tag);
    
    NSInteger positionForStar = (5 * (currentWorld - 1)) + curLevel;
    
    NSMutableString *openedLevels = [NSMutableString stringWithFormat: @"%@", [Settings sharedSettings].openedLevels];
    
    //CCLOG(@"String: %@ position %i", openedLevels, positionForStar);
    
    [openedLevels replaceCharactersInRange: NSMakeRange(positionForStar, 1) withString: @"1"];
    
    NSString *newString = [NSString stringWithFormat: @"%@", openedLevels];
    
    [Settings sharedSettings].openedLevels = newString;
    [[Settings sharedSettings] save];
    
    [self hideAlert];
    
    [self updateItems];
}

- (void) back
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"hideBanner" object: nil];
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectWorldMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) playLevel: (CCMenuItem *) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"hideBanner" object: nil];
    
    currentLevel = sender.tag + 1;
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [GameLayer scene]]];
}

@end
