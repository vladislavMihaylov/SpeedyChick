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
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [consumPurchases release];
    //[itemsLayer release];
    
    [_products release];
    [allItemsArray release];
    
    [super dealloc];
}

- (void) didLoadFromCCB
{
    curMenusPosition = ccp(0, 0);
    
    //itemsLayer = [[CCNode alloc] init];
    //itemsLayer.position = curMenusPosition;
    //[self addChild: itemsLayer];
    
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
    waitingLabel.color = ccc3(0, 0, 255);
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
            
            isCanMoveMenuToRight = YES;
            
            //self.isTouchEnabled = YES;
            [self scheduleUpdate];
        }
    }];
    
    
}

- (void) updateLabels
{
    rocketsLabel.string = [NSString stringWithFormat: @"%i", [Settings sharedSettings].countOfRockets];
    coinsLabel.string = [NSString stringWithFormat: @"%i", [Settings sharedSettings].countOfCoins];
}

- (void) showItems
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"shopItems%@.plist", suffix]];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"gameMenu%@.plist", suffix]];
    
    // <------------------->
    
    CCMenuItemImage *kidsMode = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                 ];
    kidsMode.position = ccp(30 + kidsMode.contentSize.width / 2, GameCenterY);
    
    CCLabelBMFont *nameOfItem = [CCLabelBMFont labelWithString: @"Kids mode" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfItem.position = ccp(kidsMode.contentSize.width / 2, kidsMode.contentSize.height * 0.9);
    nameOfItem.color = ccc3(0, 0, 255);
    [kidsMode addChild: nameOfItem];
    
    CCLabelBMFont *descrOfKidsMode = [CCLabelBMFont labelWithString: @"Flying becomes easier.\n No Cat behing you"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    descrOfKidsMode.position = ccp(kidsMode.contentSize.width / 2, kidsMode.contentSize.height * 0.3);
    descrOfKidsMode.scale = shopTextScale;
    descrOfKidsMode.color = ccc3(0, 0, 255);
    [kidsMode addChild: descrOfKidsMode];
    
    CCSprite *picOfKidsMode = [CCSprite spriteWithSpriteFrameName: @"kidsMode.png"];
    picOfKidsMode.position = ccp(kidsMode.contentSize.width / 2, kidsMode.contentSize.height * 0.6);
    [kidsMode addChild: picOfKidsMode];
    
    CCMenuItemImage *kidsUnlockBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtn.png"]
                                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtnOn.png"]
                                                                    target: self
                                                                  selector: @selector(buyfeature:)
                                      ];
    kidsUnlockBtn.position = ccp(kidsMode.position.x, kidsMode.position.y - kidsMode.contentSize.height * 0.35);
    kidsUnlockBtn.tag = p_kidsMode;
    
    // <------------------->
    
    CCMenuItemImage *superChick = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                   ];
    superChick.position = ccp(25 + kidsMode.position.x + superChick.contentSize.width, GameCenterY);
    
    CCLabelBMFont *nameOfSuperItem = [CCLabelBMFont labelWithString: @"Super chick" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfSuperItem.position = ccp(superChick.contentSize.width / 2, superChick.contentSize.height * 0.9);
    nameOfSuperItem.color = ccc3(0, 0, 255);
    [superChick addChild: nameOfSuperItem];
    
    CCLabelBMFont *descrOfSuperChick = [CCLabelBMFont labelWithString: @"Go higher. Go faster.\n Have more control"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfSuperChick.position = ccp(superChick.contentSize.width / 2, superChick.contentSize.height * 0.3);
    descrOfSuperChick.scale = shopTextScale;
    descrOfSuperChick.color = ccc3(0, 0, 255);
    [superChick addChild: descrOfSuperChick];
    
    CCSprite *picOfSuperChick = [CCSprite spriteWithSpriteFrameName: @"superChick.png"];
    picOfSuperChick.position = ccp(superChick.contentSize.width / 2, superChick.contentSize.height * 0.6);
    [superChick addChild: picOfSuperChick];
    
    CCMenuItemImage *superUnlockBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtn.png"]
                                                             selectedSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtnOn.png"]
                                                                     target: self
                                                                   selector: @selector(buyfeature:)
                                       ];
    superUnlockBtn.position = ccp(superChick.position.x, superChick.position.y - superChick.contentSize.height * 0.35);
    superUnlockBtn.tag = p_superChick;
    
    // <------------------->
    
    CCMenuItemImage *ghostChick = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                   ];
    ghostChick.position = ccp(25 + superChick.position.x + ghostChick.contentSize.width, GameCenterY);
    
    CCLabelBMFont *nameOfGhostItem = [CCLabelBMFont labelWithString: @"Ghost chick" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfGhostItem.position = ccp(ghostChick.contentSize.width / 2, ghostChick.contentSize.height * 0.9);
    nameOfGhostItem.color = ccc3(0, 0, 255);
    [ghostChick addChild: nameOfGhostItem];
    
    CCLabelBMFont *descrOfGhostChick = [CCLabelBMFont labelWithString: @"Get a magic boost for \nevery perfect slide"
                                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfGhostChick.position = ccp(ghostChick.contentSize.width / 2, ghostChick.contentSize.height * 0.3);
    descrOfGhostChick.scale = shopTextScale;
    descrOfGhostChick.color = ccc3(0, 0, 255);
    [ghostChick addChild: descrOfGhostChick];
    
    CCSprite *picOfGhostChick = [CCSprite spriteWithSpriteFrameName: @"ghostChick.png"];
    picOfGhostChick.position = ccp(ghostChick.contentSize.width / 2, ghostChick.contentSize.height * 0.6);
    [ghostChick addChild: picOfGhostChick];
    
    CCMenuItemImage *ghostUnlockBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtn.png"]
                                                             selectedSprite: [CCSprite spriteWithSpriteFrameName: @"unlockBtnOn.png"]
                                                                     target: self
                                                                   selector: @selector(buyfeature:)
                                       ];
    ghostUnlockBtn.position = ccp(ghostChick.position.x, ghostChick.position.y - ghostChick.contentSize.height * 0.35);
    ghostUnlockBtn.tag = p_ghostChick;
    //[ghostChick addChild: ghostUnlockBtn];
    
    // <------------------->
    
    CCMenuItemImage *rockets = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                   ];
    
    rockets.position = ccp(25 + ghostChick.position.x + ghostChick.contentSize.width, GameCenterY);
    
    
    CCLabelBMFont *nameOfRocketsItem = [CCLabelBMFont labelWithString: @"Rockets" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfRocketsItem.position = ccp(rockets.contentSize.width / 2, rockets.contentSize.height * 0.9);
    nameOfRocketsItem.color = ccc3(0, 0, 255);
    [rockets addChild: nameOfRocketsItem];
    
    CCSprite *picOfRockets = [CCSprite spriteWithSpriteFrameName: @"rocket.png"];
    picOfRockets.position = ccp(rockets.contentSize.width / 2 - picOfRockets.contentSize.width / 2, rockets.contentSize.height * 0.7);
    [rockets addChild: picOfRockets];
    
    rocketsLabel = [CCLabelBMFont labelWithString: @"" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    rocketsLabel.color = ccc3(0, 0, 255);
    rocketsLabel.position = ccp(rockets.contentSize.width / 2 + picOfRockets.contentSize.width / 2, rockets.contentSize.height * 0.7);
    [rockets addChild: rocketsLabel];
    
    CCMenuItemImage *rockets3 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"3rockets.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"3rocketsOn.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    CGPoint posFor3rock = ccp(25 + ghostChick.position.x + rockets.contentSize.width,
                              rockets.position.y - rockets.contentSize.height * 0.05);
    
    rockets3.position = posFor3rock;
    rockets3.tag = p_rockets3;
    
    CCMenuItemImage *rockets15 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"15rockets.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"15rocketsOn.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor15rock = ccp(25 + ghostChick.position.x + rockets.contentSize.width,
                               rockets.position.y - rockets.contentSize.height * 0.20);
    
    rockets15.position = posFor15rock;
    rockets15.tag = p_rockets15;
    
    CCMenuItemImage *rockets50 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"50rockets.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"50rocketsOn.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor50rock = ccp(25 + ghostChick.position.x + rockets.contentSize.width,
                               rockets.position.y - rockets.contentSize.height * 0.35);
    
    rockets50.position = posFor50rock;
    rockets50.tag = p_rockets50;
        
    // <------------------->
    
    CCMenuItemImage *coins = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                ];
    
    coins.position = ccp(25 + rockets.position.x + coins.contentSize.width, GameCenterY);
 
    
    CCLabelBMFont *nameOfCoinsItem = [CCLabelBMFont labelWithString: @"Coins" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfCoinsItem.position = ccp(coins.contentSize.width / 2, coins.contentSize.height * 0.9);
    nameOfCoinsItem.color = ccc3(0, 0, 255);
    [coins addChild: nameOfCoinsItem];
    
    CCSprite *picOfCoins = [CCSprite spriteWithSpriteFrameName: @"coin.png"];
    picOfCoins.position = ccp(coins.contentSize.width / 2 - picOfCoins.contentSize.width, coins.contentSize.height * 0.7);
    [coins addChild: picOfCoins];
    
    coinsLabel = [CCLabelBMFont labelWithString: @""
                                        fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    coinsLabel.color = ccc3(0, 0, 255);
    coinsLabel.position = ccp(coins.contentSize.width / 2 + picOfCoins.contentSize.width / 2, coins.contentSize.height * 0.7);
    [coins addChild: coinsLabel];
    
    CCMenuItemImage *coins1000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"1000coins.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"1000coinsOn.png"]
                                                               target: self
                                                             selector: @selector(buyfeature:)
                                 ];
    
    
    
    CGPoint posFor1000 = ccp(25 + rockets.position.x + coins.contentSize.width,
                             coins.position.y - coins.contentSize.height * 0.05);
    
    coins1000.position = posFor1000;
    coins1000.tag = p_coins1000;
    
    
    
    
    CCMenuItemImage *coins5000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"5000coins.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"5000coinsOn.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor5000 = ccp(25 + rockets.position.x + coins.contentSize.width,
                             coins.position.y - coins.contentSize.height * 0.2);
    
    coins5000.position = posFor5000;
    coins5000.tag = p_coins5000;
    
    
    CCMenuItemImage *coins20000 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"20000coins.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"20000coinsOn.png"]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
    
    CGPoint posFor20000 = ccp(25 + rockets.position.x + coins.contentSize.width,
                              coins.position.y - coins.contentSize.height * 0.35);
    
    coins20000.position = posFor20000;
    coins20000.tag = p_coins20000;
    
    CCLOG(@"coinsPos %f", coins20000.position.x);
    
    // <------------------->
    
    CCMenuItemImage *noAds = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                                                    selectedSprite: [CCSprite spriteWithSpriteFrameName: @"shopMenuItem.png"]
                              ];
    noAds.position = ccp(25 + coins.position.x + rockets.contentSize.width, GameCenterY);
    
    CCLabelBMFont *nameOfNoAdsItem = [CCLabelBMFont labelWithString: @"No Ads" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfNoAdsItem.position = ccp(noAds.contentSize.width / 2, noAds.contentSize.height * 0.9);
    nameOfNoAdsItem.color = ccc3(0, 0, 255);
    [noAds addChild: nameOfNoAdsItem];
    
    CCLabelBMFont *descrOfNoAds = [CCLabelBMFont labelWithString: @"Buy anything and \nget this for free"
                                                         fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    
    descrOfNoAds.position = ccp(noAds.contentSize.width / 2, noAds.contentSize.height * 0.55);
    descrOfNoAds.scale = shopTextScale;
    descrOfNoAds.color = ccc3(0, 0, 255);
    [noAds addChild: descrOfNoAds];
    
    CCLabelBMFont *nameOfRestoreItem = [CCLabelBMFont labelWithString: @"Restore in-app" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    nameOfRestoreItem.position = ccp(noAds.contentSize.width / 2, noAds.contentSize.height * 0.4);
    nameOfRestoreItem.color = ccc3(0, 0, 255);
    [noAds addChild: nameOfRestoreItem];
    
    CCMenuItemImage *noAdsUnlockBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"noAds.png"]
                                                             selectedSprite: [CCSprite spriteWithSpriteFrameName: @"noAdsOn.png"]
                                                                     target: self
                                                                   selector: @selector(buyfeature:)
                                       ];
    noAdsUnlockBtn.scale = 0.5;
    noAdsUnlockBtn.position = ccp(noAds.position.x, noAds.contentSize.height * noAdsBtnMultiplier);
    noAdsUnlockBtn.tag = p_noads;
    
    CCMenuItemImage *restoreBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtn.png"]
                                                         selectedSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtnOn.png"]
                                                                 target: self
                                                               selector: @selector(restorePurchase)
                                   ];
    restoreBtn.position = ccp(noAds.position.x, noAds.contentSize.height * restoreBtnMultiplier);
    
    rightBorderForItems = ccp((coins.position.x + coins.contentSize.width * 2) / 2, 0);
    
    
    [allItemsArray addObject: kidsUnlockBtn];
    [allItemsArray addObject: superUnlockBtn];
    [allItemsArray addObject: ghostUnlockBtn];
    [allItemsArray addObject: noAdsUnlockBtn];
    [allItemsArray addObject: rockets3];
    [allItemsArray addObject: rockets15];
    [allItemsArray addObject: rockets50];
    [allItemsArray addObject: coins1000];
    [allItemsArray addObject: coins5000];
    [allItemsArray addObject: coins20000];
    

    shopMenu = [CCMenuAdvanced menuWithItems: kidsMode, superChick, ghostChick, noAds, rockets, coins,  nil];
    
    shopMenu.position = ccp(GameCenterX, GameCenterY);
    shopMenu.boundaryRect = thisisRECT;
    
    //[itemsLayer addChild: shopMenu];
    [self addChild: shopMenu];
    
    buttonsMenu = [CCMenuAdvanced menuWithItems: rockets3, rockets15, rockets50, coins1000, coins5000, coins20000, kidsUnlockBtn, superUnlockBtn, ghostUnlockBtn, noAdsUnlockBtn, restoreBtn, nil];
    
    buttonsMenu.position = ccp(GameCenterX, GameCenterY);
    buttonsMenu.boundaryRect = thisisRECT;
    [self addChild: buttonsMenu];
    
    curPositionOfButtons = buttonsMenu.position.x;
    curPositionOfShopMenu = shopMenu.position.x;
    
    //restoreMenu = [CCMenu menuWithItems: restoreBtn, nil];
    //restoreMenu.position = ccp(0, 0);
    //[self addChild: restoreMenu];
    
    [self updateLabels];
}

- (void) update: (ccTime) time
{
    
    float newPosBtns = buttonsMenu.position.x;
    float newPosMenu = shopMenu.position.x;
    
    if(fabsf(curPositionOfButtons - newPosBtns) != 0)
    {
        shopMenu.position = buttonsMenu.position;
        curPositionOfButtons = buttonsMenu.position.x;
        curPositionOfShopMenu = shopMenu.position.x;
    }
    
    if(fabs(curPositionOfShopMenu - newPosMenu) != 0)
    {
        buttonsMenu.position = shopMenu.position;
        curPositionOfButtons = buttonsMenu.position.x;
        curPositionOfShopMenu = shopMenu.position.x;
    }
}

- (void) restorePurchase
{
    [self lockMenu];
    [[RagePurchase sharedInstance] restoreCompletedTransactions];
}

/*- (void) registerWithTouchDispatcher
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
}*/

- (void) buyfeature: (CCMenuItem *) sender
{
    SKProduct *product = _products[sender.tag];
    [self lockMenu];
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
    [self unlockMenu];
}

- (void) purchaseCanceled: (NSNotification *) notification
{
    NSLog(@"Cancel");
    [self unlockMenu];
}

- (void) lockMenu
{
    CCLayerColor *blockLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 127)];
    [self addChild: blockLayer z: 100 tag: 100];
    
    CCLabelBMFont *waiting = [CCLabelBMFont labelWithString: @"Waiting..." fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    waiting.position = ccp(GameCenterX, GameCenterY);
    waiting.color = ccc3(0, 0, 255);
    [blockLayer addChild: waiting];
    
    rootMenu.isTouchEnabled = NO;
    shopMenu.isTouchEnabled = NO;
    buttonsMenu.isTouchEnabled = NO;
    restoreMenu.isTouchEnabled = NO;
    self.isTouchEnabled = NO;
}

- (void) unlockMenu
{
    [self removeChildByTag: 100 cleanup: YES];
    
    rootMenu.isTouchEnabled = YES;
    shopMenu.isTouchEnabled = YES;
    restoreMenu.isTouchEnabled = YES;
    buttonsMenu.isTouchEnabled = YES;
    self.isTouchEnabled = YES;
}

@end
