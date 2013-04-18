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

#import "RagePurchase.h"
#import <StoreKit/StoreKit.h>

@implementation ShopMenu

- (void) dealloc
{
    [consumPurchases release];
    [itemsLayer release];
    
    [_products release];
    [allItemsArray release];
    
    [super dealloc];
}

- (void) didLoadFromCCB
{
    rocketsLabel = [CCLabelBMFont labelWithString: @"Rockets: "
                                          fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    rocketsLabel.position = ccp(GameCenterX * 0.7, GameCenterY * 0.2);
    [self addChild: rocketsLabel];
    
    coinsLabel = [CCLabelBMFont labelWithString: @"Coins: "
                                          fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    coinsLabel.position = ccp(GameCenterX * 1.3, GameCenterY * 0.2);
    [self addChild: coinsLabel];
    
    [self updateLabels];
    
    curMenusPosition = ccp(0, 0);
    
    itemsLayer = [[CCNode alloc] init];
    itemsLayer.position = curMenusPosition;
    [self addChild: itemsLayer];
    
    allItemsArray = [[NSMutableArray alloc] init];
    
    consumPurchases = [[NSMutableArray alloc] initWithObjects: @"com.javier.speedy.kidsmode",
                       @"com.javier.speedy.superchick",
                       @"com.javier.speedy.ghostchick",
                       @"com.javier.speedy.noads", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:PurchaseProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name:PurchaseProductCanceledPurchaseNotification object:nil];
    
    CCLayerColor *layerColor = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 127) width: GameWidth height: GameHeight / 3];
    layerColor.position = ccp(0, GameHeight / 3);
    [self addChild: layerColor z: 111 tag: 111];
    
    CCLabelBMFont *waitingLabel = [CCLabelBMFont labelWithString: @"Waiting..."
                                                         fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    waitingLabel.position = ccp(GameCenterX, GameCenterY);
    [self addChild: waitingLabel z: 112 tag: 112];
    
    [[RagePurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
    {
        if (success)
        {
            [self removeChildByTag: 111 cleanup: YES];
            [self removeChildByTag: 112 cleanup: YES];
            
            _products = [[NSArray alloc] initWithArray: products];
            
            [self showItems];
            [self updateItems];
            
            self.isTouchEnabled = YES;
            
            
        }
    }];
    
    
}

- (void) updateLabels
{
    rocketsLabel.string = [NSString stringWithFormat: @"Rockets: %i", [Settings sharedSettings].countOfRockets];
    coinsLabel.string = [NSString stringWithFormat: @"Coins: %i", [Settings sharedSettings].countOfCoins];
}

- (void) showItems
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"shopItems%@.plist", suffix]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"gameMenu%@.plist", suffix]];
    
    CCMenuItemImage *kidsMode = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"kidsMode.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"kidsMode.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    kidsMode.position = item_1.position;
    kidsMode.tag = p_kidsMode;
    
    CCLabelBMFont *descrOfKidsMode = [CCLabelBMFont labelWithString: @"on/off cat"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfKidsMode.position = ccp(kidsMode.position.x, kidsMode.position.y + kidsMode.contentSize.height * 0.7);
    
    [itemsLayer addChild: descrOfKidsMode];
    
    CCMenuItemImage *superChick = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"superChick.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"superChick.png"]
                                                                 target: self
                                                               selector: @selector(buyfeature:)
                                   ];
    
    superChick.position = item_2.position;
    superChick.tag = p_superChick;
    
    CCLabelBMFont *descrOfSuperChick = [CCLabelBMFont labelWithString: @"higher, faster"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfSuperChick.position = ccp(superChick.position.x, superChick.position.y + superChick.contentSize.height * 0.7);
    
    [itemsLayer addChild: descrOfSuperChick];
    
    CCMenuItemImage *ghostChick = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"ghostChick.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"ghostChick.png"]
                                                                 target: self
                                                               selector: @selector(buyfeature:)
                                   ];
    
    ghostChick.position = item_3.position;
    ghostChick.tag = p_ghostChick;
    
    CCLabelBMFont *descrOfGhostChick = [CCLabelBMFont labelWithString: @"swipe to \naccelerate"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfGhostChick.position = ccp(ghostChick.position.x, ghostChick.position.y + ghostChick.contentSize.height * 0.7);
    
    [itemsLayer addChild: descrOfGhostChick];
    
    CCMenuItemImage *noAds = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"noAds.png"]
                                                    selectedSprite: [CCSprite spriteWithSpriteFrameName: @"noAds.png"]
                                                            target: self
                                                          selector: @selector(buyfeature:)
                              ];
    noAds.position = ccp(item_3.position.x + noAds.contentSize.width * 1.5, item_3.position.y);
    noAds.tag = p_noads;
    
    CCLabelBMFont *descrOfNoAds = [CCLabelBMFont labelWithString: @"Disable Ads"
                                                              fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfNoAds.position = ccp(noAds.position.x, noAds.position.y + noAds.contentSize.height * 0.7);
    
    [itemsLayer addChild: descrOfNoAds];
    
    CCMenuItemImage *rockets3 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"3rockets.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"3rockets.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    CGPoint posFor3rock = ccp(noAds.position.x + rockets3.contentSize.width * 1.5,
                              noAds.position.y + noAds.contentSize.height/2 - rockets3.contentSize.height/2);
    
    rockets3.position = posFor3rock;
    rockets3.tag = p_rockets3;
    
    CCLabelBMFont *descrOfRockets = [CCLabelBMFont labelWithString: @"Rockets"
                                                         fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfRockets.position = ccp(rockets3.position.x, rockets3.position.y + rockets3.contentSize.height * 1.1);
    
    [itemsLayer addChild: descrOfRockets];
    
    CCMenuItemImage *rockets15 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"15rockets.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"15rockets.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    CGPoint posFor15rock = ccp(noAds.position.x + rockets15.contentSize.width * 1.5,
                               noAds.position.y);
    
    rockets15.position = posFor15rock;
    rockets15.tag = p_rockets15;
    
    CCMenuItemImage *rockets50 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"50rockets.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"50rockets.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor50rock = ccp(noAds.position.x + rockets50.contentSize.width * 1.5,
                               noAds.position.y - noAds.contentSize.height/2 + rockets50.contentSize.height/2);
    
    rockets50.position = posFor50rock;
    rockets50.tag = p_rockets50;
    
    
    
    
    
    
    CCMenuItemImage *coins1000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"1000coins.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"1000coins.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    CGPoint posFor1000 = ccp(rockets3.position.x + coins1000.contentSize.width * 1.5, rockets3.position.y);
    
    coins1000.position = posFor1000;
    coins1000.tag = p_coins1000;
    
    CCLabelBMFont *descrOfCoins = [CCLabelBMFont labelWithString: @"Coins"
                                                           fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfCoins.position = ccp(coins1000.position.x, coins1000.position.y + coins1000.contentSize.height * 1.1);
    
    [itemsLayer addChild: descrOfCoins];
    
    
    CCMenuItemImage *coins5000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"5000coins.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"5000coins.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor5000 = ccp(rockets15.position.x + coins5000.contentSize.width * 1.5, rockets15.position.y);
    
    coins5000.position = posFor5000;
    coins5000.tag = p_coins5000;
    
    
    CCMenuItemImage *coins20000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"20000coins.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"20000coins.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor20000 = ccp(rockets50.position.x + coins20000.contentSize.width * 1.5, rockets50.position.y);
    
    coins20000.position = posFor20000;
    coins20000.tag = p_coins20000;
    
    CCLOG(@"coinsPos %f", coins20000.position.x);
    
    rightBorderForItems = ccp((posFor20000.x + coins20000.contentSize.width * 0.5) / 2, 0);
    
    
    CCMenuItemImage *restoreBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtn.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtnOn.png"]
                                                                 target: self
                                                               selector: @selector(restorePurchase)
                                   ];
    restoreBtn.position = ccp(GameWidth * 0.9, GameHeight * 0.1);
    
    [allItemsArray addObject: kidsMode];
    [allItemsArray addObject: superChick];
    [allItemsArray addObject: ghostChick];
    [allItemsArray addObject: noAds];
    [allItemsArray addObject: rockets3];
    [allItemsArray addObject: rockets15];
    [allItemsArray addObject: rockets50];
    [allItemsArray addObject: coins1000];
    [allItemsArray addObject: coins5000];
    [allItemsArray addObject: coins20000];
    
    CCMenu *shopMenu = [CCMenu menuWithItems: kidsMode, superChick, ghostChick, noAds, rockets3, rockets15, rockets50, coins1000, coins5000, coins20000, nil];
    shopMenu.position = ccp(0, 0);
    [itemsLayer addChild: shopMenu];
    
    CCMenu *restoreMenu = [CCMenu menuWithItems: restoreBtn, nil];
    restoreMenu.position = ccp(0, 0);
    [self addChild: restoreMenu];
}

- (void) restorePurchase
{
    [[RagePurchase sharedInstance] restoreCompletedTransactions];
}

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
    touchBegin = location;
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(touchBegin.x - location.x > 0)
    {
        float diff = touchBegin.x - location.x;
        
        itemsLayer.position = ccp(curMenusPosition.x - diff * 1.5, itemsLayer.position.y);
    }
    else
    {
        float diff = location.x - touchBegin.x;
        
        itemsLayer.position = ccp(curMenusPosition.x + diff * 1.5, itemsLayer.position.y);
    }
    
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    curMenusPosition = ccp(itemsLayer.position.x, curMenusPosition.y);
    
    CCLOG(@"Pos: %f", curMenusPosition.x);
    
    if(curMenusPosition.x > 0)
    {
        curMenusPosition = ccp(0, 0);
        
        [itemsLayer runAction: [CCMoveTo actionWithDuration: 0.2 position: curMenusPosition]];
    }
    if(curMenusPosition.x < rightBorderForItems.x * -1)
    {
        curMenusPosition = ccp(rightBorderForItems.x * -1, 0);
        
        [itemsLayer runAction: [CCMoveTo actionWithDuration: 0.2 position: curMenusPosition]];
    }
}

- (void) buyfeature: (CCMenuItem *) sender
{
    SKProduct *product = _products[sender.tag];

    [[RagePurchase sharedInstance] buyProduct: product];
}

- (void) updateItems
{
    for(CCMenuItemImage *curItem in allItemsArray)
    {
        SKProduct *product = _products[curItem.tag];
        
        if([[RagePurchase sharedInstance] productPurchased: product.productIdentifier])
        {
            for(NSString *curIdentirier in consumPurchases)
            {
                if([product.productIdentifier isEqualToString: curIdentirier])
                {
                    curItem.opacity = 127;
                    curItem.isEnabled = NO;
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

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:PurchaseProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSLog(@"Purchase completed! Very well!");
    
    [self updateItems];
    [self updateLabels];
}

- (void) purchaseCanceled: (NSNotification *) notification
{
    NSLog(@"Cancel");
}

@end
