//
//  GuiLayer.m
//  Game
//
//  Created by Vlad on 11.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GuiLayer.h"
#import "Settings.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "CCBReader.h"

#import "SHKItem.h"
#import "SHKFacebook.h"

#import "WorldsDatabase.h"
#import "WorldsInfo.h"

#import "Common.h"

#import "Appirater.h"

#import "RagePurchase.h"
#import <StoreKit/StoreKit.h>

#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"
#import "RootViewController.h"

@implementation GuiLayer

@synthesize gameLayer;
@synthesize energy;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [_products release];
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:PurchaseProductPurchasedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name:PurchaseProductCanceledPurchaseNotification object:nil];
        
        isItemsLoaded = NO;
        showNewWorld = NO;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"shopItems%@.plist", suffix]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"catAnim%@.plist", suffix]];
        
        [Common loadAnimationWithPlist: @"catAnimation"
                               andName: @"cat_"
         ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"gameMenu%@.plist", suffix]];
        
        applyRocket = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                             selectedSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                                     target: self
                                                   selector: @selector(applyRocket)
                       ];
        
        applyRocket.position = ccp(GameWidth * 0.83, GameHeight * 0.88);
        
        CCMenuItemImage *pause = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"pauseBtn.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"pauseBtn.png"]
                                                               target: self
                                                             selector: @selector(doPause)
                                  ];
        
        pause.position = ccp(GameWidth * 0.952, GameHeight * 0.9375);
        
        CCMenu *ROCKET = [CCMenu menuWithItems: applyRocket, pause, nil];
        ROCKET.position = ccp(0, 0);
        [self addChild: ROCKET z: 10 tag: 111];
        
        [self updateRocket];
        
        timeLabel = [CCLabelBMFont labelWithString: @"00:00:00" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        timeLabel.position = ccp(GameCenterX, GameHeight * 0.9375);
        timeLabel.color = ccc3(255, 0, 0);
        [self addChild: timeLabel];
        
        time = 0;
        
        if(![Settings sharedSettings].isKidsModeBuyed)
        {
            [self loadCat];
        }
        
        if([Settings sharedSettings].isGhostChickBuyed)
        {
            [self loadEnergy];
            energy = 0;
        }
        
        ChickOnTheStart = YES;
        
        [self resetLevel];
        
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
    
    return self;
}

#pragma mark Energy

- (void) loadEnergy
{
    if(energyLabel == nil)
    {
        energyLabel = [CCLabelBMFont labelWithString: @"Energy: "
                                             fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]
                       ];
        
        energyLabel.position = ccp(GameWidth * 0.02, GameHeight * 0.9375);
        energyLabel.anchorPoint = ccp(0, 0.5);
        energyLabel.scale = 0.7;
        [self addChild: energyLabel];
        
        [self updateEnergyLabel];
    }
}

- (void) increaseEnergy
{
    energy++;
    
    if(energy > 5)
    {
        energy = 5;
    }
    
    [self updateEnergyLabel];
}

- (void) decreaseEnergy
{
    energy -= 2;
    [self updateEnergyLabel];
}

- (void) updateEnergyLabel
{
    energyLabel.string = [NSString stringWithFormat: @"Energy: %i", energy];
}

#pragma mark Cat

- (void) loadCat
{
    if(cat == nil)
    {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
    
    finishLine = [CCSprite spriteWithFile: @"finishLine.png"];
    finishLine.position = finishPointForCoco;
    [self addChild: finishLine];
    
    coco = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", [Settings sharedSettings].currentPinguin]];
    coco.scale = 0.25;
    [coco setPosition: cocoStartPosition];
    [self addChild: coco];
    
    cat = [CCSprite spriteWithFile: @"cat.png"];
    [cat setPosition: catStartPosition];
    [self addChild: cat];
    
    }
}

- (void) moveCat
{
    [cat setPosition: catStartPosition];
    
    NSString *number =[NSString stringWithFormat: @"%i%i", currentWorld, currentLevel];
    
    NSInteger num = [number integerValue];
    
    NSArray *worldsInfo = [[WorldsDatabase database] worldsInfosWithID: num];
    
    NSString *times;
    
    for(WorldsInfo *info in worldsInfo)
    {
        times = info.times;
    }
    
    NSArray *timesArray = [times componentsSeparatedByString: @","];
    
    //CCLOG(@"Times Array %@", timesArray);
    
    float timeForCat = [[timesArray lastObject] floatValue];
    
    //CCLOG(@"TIMEFORCAT %f", timeForCat);
    
    [cat runAction: [CCMoveTo actionWithDuration: timeForCat / 60 position: finishPointForCoco]];
}

- (void) moveCocoOffsetX: (float) offsetX andFinishPoint: (float) finishPoint
{
    if(![Settings sharedSettings].isKidsModeBuyed)
    {
        if(isGameActive)
        {
            if(offsetX != 0)
            {
                [coco setPosition: ccp(cocoStartPosition.x + (finishPointForCoco.x - cocoStartPosition.x) * (offsetX / finishPoint), cocoStartPosition.y)];
                
                if(cat.position.x >= coco.position.x)
                {
                    [self doGameOver];
                }
            }
        }
    }
}

#pragma mark RocketBonus

- (void) applyRocket
{
    if([Settings sharedSettings].countOfRockets > 0)
    {
        [gameLayer applyRocket];
        [Settings sharedSettings].countOfRockets--;
        [[Settings sharedSettings] save];
        
        [self updateRocket];
    }
}

- (void) updateRocket
{
    if([Settings sharedSettings].countOfRockets <= 0)
    {
        applyRocket.isEnabled = NO;
        applyRocket.visible = NO;
        
        if(!isAlertAboutOutOfRocketsShowed)
        {
            isAlertAboutOutOfRocketsShowed = YES;
            [self doPause];
            [self showAlert: @"Need more Rockets?\n Get more!" type: 5];
        }
    }
    else
    {
        applyRocket.isEnabled = YES;
        applyRocket.visible = YES;
    }
}

#pragma mark GameState

- (void) doPause
{
    if(isGameActive)
    {
        if([Settings sharedSettings].countOfRuns > 0)
        {
            if([Settings sharedSettings].isAdEnabled)
            {
                if([Settings sharedSettings].countOfRuns % 2 != 0)
                {
                    [[Chartboost sharedChartboost] showInterstitial];
                }
                else
                {
                    [RevMobAds startSessionWithAppID: @"51776808e7076acc0a00001c"];
                    [[RevMobAds session] showFullscreen];
                }
            }
        }
        
        applyRocket.isEnabled = NO;
        
        isGameActive = NO;
        isPauseOfGame = YES;
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithSpriteFrameName: @"menuBg.png"];
        menuBg.position = ccp(GameCenterX, GameHeight * 1.5);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtn.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtnOn.png"]
                                                              target: self
                                                            selector: @selector(exitToMainMenu)
                                 ];
        
        exit.position = ccp(menuBg.contentSize.width/4, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtn.png"]
                                                          selectedSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtnOn.png"]
                                                                 target: self
                                                               selector:@selector(resetLevel)
                                    ];
        
        restart.position = ccp(menuBg.contentSize.width/2, menuBg.contentSize.height / 2);
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"continueBtn.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"continueBtnOn.png"]
                                                              target: self
                                                            selector:@selector(unPause)
                                 ];
        
        play.position = ccp(menuBg.contentSize.width/2 + menuBg.contentSize.width/4, menuBg.contentSize.height / 2);
        
        
        CCMenu *pauseMenu = [CCMenu menuWithItems: exit, restart, play, nil];
        pauseMenu.position = ccp(0, 0);
        
        
        [menuBg addChild: pauseMenu z:1 tag: 45];
        
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.25 position: ccp(GameCenterX, GameCenterY)]];
        
        CCLabelBMFont *pauseLabel = [CCLabelBMFont labelWithString: @"PAUSE" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        
        pauseLabel.position = ccp(menuBg.contentSize.width / 2, menuBg.contentSize.height * 1.2);
        [menuBg addChild: pauseLabel];
        
        
        
    }
}

- (void) doGameOver
{
    if(isGameActive)
    {
        if([Settings sharedSettings].countOfRuns > 0)
        {
            if([Settings sharedSettings].isAdEnabled)
            {
                if([Settings sharedSettings].countOfRuns % 2 != 0)
                {
                    [[Chartboost sharedChartboost] showInterstitial];
                }
                else
                {
                    [RevMobAds startSessionWithAppID: @"51776808e7076acc0a00001c"];
                    [[RevMobAds session] showFullscreen];
                }
            }
        }
        
        applyRocket.isEnabled = NO;
        
        [gameLayer setVisibleOfChick: NO];
        
        isPauseOfGame = YES;
        isGameActive = NO;
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithSpriteFrameName: @"menuBg.png"];
        menuBg.position = ccp(GameCenterX, GameHeight * 1.5);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtn.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtnOn.png"]
                                                              target: self
                                                            selector: @selector(exitToMainMenu)
                                 ];
        
        exit.position = ccp(menuBg.contentSize.width * 0.35, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtn.png"]
                                                          selectedSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtnOn.png"]
                                                                 target: self
                                                               selector:@selector(resetLevel)
                                    ];
        
        restart.position = ccp(menuBg.contentSize.width * 0.65, menuBg.contentSize.height / 2);
        
        
        gameOverMenu = [CCMenu menuWithItems: exit, restart, nil];
        gameOverMenu.position = ccp(0, 0);
        [menuBg addChild: gameOverMenu];
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.2 position: ccp(GameCenterX, GameCenterY)]];
        
        CCLabelBMFont *pauseLabel = [CCLabelBMFont labelWithString: @"Game over" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        
        pauseLabel.position = ccp(menuBg.contentSize.width / 2, menuBg.contentSize.height * 1.2);
        [menuBg addChild: pauseLabel];
        
        CCSprite *catAnim = [CCSprite spriteWithFile: @"cat_1.png"];
        catAnim.position = ccp(GameCenterX * 1.1, 0  );
        [menuBg addChild: catAnim];
        
        [catAnim runAction:
                [CCRepeatForever actionWithAction:
                    [CCAnimate actionWithAnimation:
                        [[CCAnimationCache sharedAnimationCache] animationByName: @"cat_"]
                     ]
                 ]
         ];
        
        countOfLoses++;
        if(countOfLoses == 3)
        {
            countOfLoses = 0;
            
            
            
            NSInteger numOfAlert = arc4random() % 3 + 1;
             
            
            if(numOfAlert == 1)
            {
                [self showAlert: @"Want to get rid of the cat?\n    Get the Kids Mode! " type: numOfAlert];
            }
            if(numOfAlert == 2)
            {
                [self showAlert: @"    Want to run faster\n       and fly higher?\n   Get the Super Chick! " type: numOfAlert];
            }
            if(numOfAlert == 3)
            {
                [self showAlert: @"      Tired of losing?\nPurchase the Ghost Chick\nand get a magic boost for\n   every perfect slide!" type: numOfAlert];
            }
            
        }
    }
}

# pragma mark Alert

- (void) showAlert: (NSString *) message type: (NSInteger) type 
{
    
    //gameOverMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 20 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: message fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    alert.color = ccc3(255, 255, 255);
    [bg addChild: alert];
    
    waitingLabel = [CCLabelBMFont labelWithString: @"Waiting..." fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    waitingLabel.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.15);
    [bg addChild: waitingLabel];
    
    alertMenu = [CCMenu menuWithItems: nil];
    
    
    if(type == 1) // okBtn & cancelBtn
    {
        okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"buyIt%@.png", suffix]
                                       selectedImage: [NSString stringWithFormat: @"buyItOn%@.png", suffix]
                                                                target: self
                                                              selector: @selector(buyfeature:)
                                  ];
        
        okBtn.tag = p_kidsMode;
        okBtn.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.15);
        
        okBtn.isEnabled = NO;
        okBtn.opacity = 0;
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
        
        if(isItemsLoaded)
        {
            [self showShopButtons];
        }
    }
    if(type == 2)
    {
        okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"buyIt%@.png", suffix]
                                       selectedImage: [NSString stringWithFormat: @"buyItOn%@.png", suffix]
                                               target: self
                                             selector: @selector(buyfeature:)
                                  ];
        
        okBtn.tag = p_superChick;
        okBtn.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.15);
        okBtn.isEnabled = NO;
        okBtn.opacity = 0;
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
        
        // -----
        
        if(isItemsLoaded)
        {
            [self showShopButtons];
        }
    }
    if(type == 3)
    {
        okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"buyIt%@.png", suffix]
                                       selectedImage: [NSString stringWithFormat: @"buyItOn%@.png", suffix]
                                               target: self
                                             selector: @selector(buyfeature:)
                 ];
        
        okBtn.tag = p_ghostChick;
        okBtn.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.15);
        okBtn.isEnabled = NO;
        okBtn.opacity = 0;
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
        
        // -----
        
        if(isItemsLoaded)
        {
            [self showShopButtons];
        }
    }
    if(type == 4)
    {
        waitingLabel.opacity = 0;
        
        alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.4);
        
        NSInteger num = arc4random() % 11 + 1;
        
        CCSprite *chick = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", num]];
        chick.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.7);
        [bg addChild: chick];
        
        okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"wantToGetBtn%@.png", suffix]
                                       selectedImage: [NSString stringWithFormat: @"wantToGetBtnOn%@.png", suffix]
                                               target: self
                                             selector: @selector(exitToCustomizationMenu)
                 ];
        
        okBtn.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.15);
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
    }
    if(type == 5)
    {
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                    target: self
                                                                  selector: @selector(hideAlert)
                                      ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.25);
        
        //------->
        
        rocket3 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"3rockets.png"]
                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: @"3rocketsOn.png"]
                                                   target: self
                                                 selector: @selector(buyfeature:)
                     ];
        
        
        rocket3.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.4);
        rocket3.tag = p_rockets3;
        rocket3.isEnabled = NO;
        rocket3.opacity = 0;
        
        
        
        
        rocket15 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"15rockets.png"]
                                           selectedSprite: [CCSprite spriteWithSpriteFrameName: @"15rocketsOn.png"]
                                                   target: self
                                                 selector: @selector(buyfeature:)
                     ];
        
        rocket15.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.25);
        rocket15.tag = p_rockets15;
        rocket15.isEnabled = NO;
        rocket15.opacity = 0;
        
        
        rocket50 = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"50rockets.png"]
                                            selectedSprite: [CCSprite spriteWithSpriteFrameName: @"50rocketsOn.png"]
                                                    target: self
                                                  selector: @selector(buyfeature:)
                      ];
        
        rocket50.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.1);
        rocket50.tag = p_rockets50;
        rocket50.isEnabled = NO;
        rocket50.opacity = 0;
        
        //------->
        
        [alertMenu addChild: cancelBtn];
        [alertMenu addChild: rocket3];
        [alertMenu addChild: rocket15];
        [alertMenu addChild: rocket50];
        
        alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.7);
        waitingLabel.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.25);
        
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
    //gameOverMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
    CCLOG(@"OK");
    
    if(rocket3)
    {
        rocket3 = nil;
        rocket15 = nil;
        rocket50 = nil;
    }
}

- (void) showShopButtons
{
    okBtn.isEnabled = YES;
    
    if(rocket3 != nil)
    {
        rocket3.isEnabled = YES;
        rocket15.isEnabled = YES;
        rocket50.isEnabled = YES;
        
        rocket3.opacity = 255;
        rocket15.opacity = 255;
        rocket50.opacity = 255;
    }
    
    okBtn.opacity = 255;
    
    waitingLabel.opacity = 0;
}

- (void) buyfeature: (CCMenuItem *) sender
{
    SKProduct *product = _products[sender.tag];
    [self lockMenu];
    [[RagePurchase sharedInstance] buyProduct: product];
}

- (void)productPurchased:(NSNotification *)notification
{
    [self unlockMenu];
    [self updateRocket];
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


- (void) playNextLevel
{
    applyRocket.isEnabled = YES;
    
    isFinish = NO;
    gameLayer.isTouchEnabled = YES;
    
    
    currentLevel++;
    if(currentLevel > 5)
    {
        currentLevel = 5;
    }
    
    [self unPause];
    
    [cat stopAllActions];
    
    [self unschedule: @selector(timer)];
    
    ChickOnTheStart = YES;
    
    [cat setPosition: catStartPosition];
    
    [coco setPosition: cocoStartPosition];
    
    timeLabel.string = @"00:00:00";
    
    time = 0;
    
    //_products = nil;
    
    [gameLayer nextLevel];
}

- (void) sendToFB
{
    SHKItem *facebookItem = [SHKItem text: [NSString stringWithFormat: @"I have finished with time %@", timeLabel.string]];
    [SHKFacebook shareItem: facebookItem];
}

- (void) unPause
{
    if(!isGameActive)
    {
        applyRocket.isEnabled = YES;
        
        isPauseOfGame = NO;
        [self removeChildByTag: menuBgTag cleanup: YES];
        
        isGameActive = YES;
        
        [self resumeSchedulerAndActions];
        [cat resumeSchedulerAndActions];
    }
}

- (void) finish
{
    //CCLOG(@"W %i H %i", currentWorld, currentLevel);
    
    NSString *number =[NSString stringWithFormat: @"%i%i", currentWorld, currentLevel];
    
    NSInteger num = [number integerValue];
    
    NSArray *worldsInfo = [[WorldsDatabase database] worldsInfosWithID: num];
    
    NSString *times;
    
    for(WorldsInfo *info in worldsInfo)
    {
        times = info.times;
    }
    
    NSArray *timesArray = [times componentsSeparatedByString: @","];
    
    //CCLOG(@"Times Array %@", timesArray);
    
    //CCLOG(@"Times Array %@", timesArray);
    
    
    NSInteger stars = 4;
    
    for(int i = 0; i < 3; i++)
    {
        stars--;
        
        if(time <= [[timesArray objectAtIndex: i] integerValue])
        {
            curStars = stars;
            break;
        }
    }
    
    if(curStars == 3)
    {
        [Appirater showPrompt];
    }
    //CCLOG(@"Stars : %i", curStars);
    
    if([Settings sharedSettings].isKidsModeBuyed)
    {
        if(curStars == 0)
        {
            curStars = 1;
        }
    }
    
    //CCLOG(@"STARS %i curWorld %i curLevel %i STARSCOUNT %@", curStars, currentWorld, currentLevel, [Settings sharedSettings].starsCount);
    
    NSMutableString *newStarsString = [NSMutableString stringWithFormat: @"%@", [Settings sharedSettings].starsCount];
    
    NSInteger positionForStar;
    
    positionForStar = (5 * (currentWorld - 1)) + currentLevel;
    
    NSString *currentStars = [newStarsString substringWithRange: NSMakeRange(positionForStar, 1)];
    
    if([currentStars integerValue] < curStars)
    {
        [newStarsString replaceCharactersInRange: NSMakeRange(positionForStar, 1) withString: [NSString stringWithFormat: @"%i", curStars]];
        [Settings sharedSettings].starsCount = [NSString stringWithFormat: @"%@", newStarsString];
    }
    
    ////
    
    NSMutableString *openedLevels = [NSMutableString stringWithFormat: @"%@", [Settings sharedSettings].openedLevels];
    
    NSInteger position = (5 * (currentWorld - 1)) + currentLevel;
    
    
    
    if(position < 15)
    {
        //NSString *nextLevel = [openedLevels substringWithRange: NSMakeRange(position + 1, 1)];
        //NSInteger intNextLevel = [nextLevel integerValue];
         //CCLOG(@"nextLevel %i", intNextLevel);
        [openedLevels replaceCharactersInRange: NSMakeRange(position + 1, 1) withString: @"1"];
        NSString *newLevelsData = [NSString stringWithFormat: @"%@", openedLevels];
        
        [Settings sharedSettings].openedLevels = newLevelsData;
    }
    
    [[Settings sharedSettings] save];

    
    if(currentLevel % 5 == 0)
    {
        //CCLOG(@"IT WAS 5 LEVEL");
        showNewWorld = YES;
        
        if([Settings sharedSettings].openedWorlds < 3)
        {
            [Settings sharedSettings].openedWorlds++;
        }
        [[Settings sharedSettings] save];
    }
    
    
    [self showFinishMenu];
}

- (void) showFinishMenu
{
    if(isGameActive)
    {
        if([Settings sharedSettings].isAdEnabled)
        {
            viewController = [[RootViewController alloc] initWithNibName: nil bundle: nil];
            [viewController view];
            viewController.wantsFullScreenLayout = YES;
        }
        
        countOfPlays ++;
        if((countOfPlays % 4 == 0) && countOfPlays != 0)
        {
            [self showAlert: @"Would like to get this chick\n     or other cool ones?" type: 4];
        }
        
        applyRocket.isEnabled = NO;
        
        isFinish = YES;
        isGameActive = NO;
        
        gameLayer.isTouchEnabled = NO;
        
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithSpriteFrameName: @"menuBg.png"];
        menuBg.position = ccp(GameCenterX, GameHeight * 1.5);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtn.png"]
                                                       selectedSprite: [CCSprite spriteWithSpriteFrameName: @"exitBtnOn.png"]
                                                               target: self
                                                             selector: @selector(exitToMainMenu)
                                 ];
        
        exit.position = ccp(menuBg.contentSize.width * 0.25, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtn.png"]
                                                          selectedSprite: [CCSprite spriteWithSpriteFrameName: @"restartBtnOn.png"]
                                                                  target: self
                                                                selector: @selector(resetLevel)
                                    ];
        
        restart.position = ccp(menuBg.contentSize.width * 0.5, menuBg.contentSize.height / 2);
        
        CCMenuItemImage *shareToFBBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"facebookBtn.png"]
                                                               selectedSprite: [CCSprite spriteWithSpriteFrameName: @"facebookBtnOn.png"]
                                                                      target: self
                                                                    selector:@selector(sendToFB)
                                         ];
        
        shareToFBBtn.position = ccp(menuBg.contentSize.width * 0.5, 0);
        
        CCMenuItemImage *next;
        
        if(!showNewWorld)
        {
            next = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"nextLevel.png"]
                                          selectedSprite: [CCSprite spriteWithSpriteFrameName: @"nextLevelOn.png"]
                                                 target: self
                                               selector:@selector(playNextLevel)
                    ];
        }
        else
        {
            next = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"nextLevel.png"]
                                          selectedSprite: [CCSprite spriteWithSpriteFrameName: @"nextLevelOn.png"]
                                                 target: self
                                               selector:@selector(showWorldsMenu)
                    ];
        }
        next.position = ccp(menuBg.contentSize.width * 0.75, menuBg.contentSize.height / 2);
        
        gameOverMenu = [CCMenu menuWithItems: exit, restart, shareToFBBtn, next, nil];
        gameOverMenu.position = ccp(0, 0);
        [menuBg addChild: gameOverMenu];
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.25 position: ccp(GameCenterX, GameCenterY)]];
        
        CCSprite *stars = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"%istars.png", curStars]];
        stars.position = ccp(menuBg.contentSize.width / 2, menuBg.contentSize.height * 0.95);
        [menuBg addChild: stars];
        
        CCLabelBMFont *pauseLabel = [CCLabelBMFont labelWithString: @"You finished!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        
        pauseLabel.position = ccp(menuBg.contentSize.width / 2, menuBg.contentSize.height * 1.2);
        [menuBg addChild: pauseLabel];
    }
}

- (void) showWorldsMenu
{
    //[self resetLevel];
    
    CCScene * scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectWorldMenu%@.ccb", suffix]];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) start
{
    ChickOnTheStart = NO;
    
    [self schedule: @selector(timer) interval: 0.01];
    
    if(![Settings sharedSettings].isKidsModeBuyed)
    {
        [self moveCat];
    }
}



- (void) timer
{
    time += 1;
    
    NSInteger milliseconds;
    NSInteger seconds;
    NSInteger minutes;
    
    minutes = time / 3600;
    seconds = time / 60 - minutes * 60;
    milliseconds = time % 60;
    
    NSString *Milliseconds;
    NSString *Seconds;
    NSString *Minutes;
    
    if(milliseconds < 10)
    {
        Milliseconds = [NSString stringWithFormat: @"0%i", milliseconds];
    }
    else
    {
        Milliseconds = [NSString stringWithFormat: @"%i", milliseconds];
    }
    
    if(seconds < 10)
    {
        Seconds = [NSString stringWithFormat: @"0%i", seconds];
    }
    else
    {
        Seconds = [NSString stringWithFormat: @"%i", seconds];
    }
    
    if(minutes < 10)
    {
        Minutes = [NSString stringWithFormat: @"0%i", minutes];
    }
    else
    {
        Minutes = [NSString stringWithFormat: @"%i", minutes];
    }
    
    timeLabel.string = [NSString stringWithFormat: @"%@:%@:%@---%i", Minutes, Seconds, Milliseconds, time];
    //timeLabel.string = [NSString stringWithFormat: @"%@:%@:%@", Minutes, Seconds, Milliseconds];
}

- (void) resetLevel
{
    applyRocket.isEnabled = YES;
    
    [gameLayer setVisibleOfChick: YES];
    
    isFinish = NO;
    gameLayer.isTouchEnabled = YES;
    isPauseOfGame = NO;
    energy = 0;
    [self updateEnergyLabel];
    
    [self unPause];
    
    [cat stopAllActions];
    
    [self unschedule: @selector(timer)];
    
    ChickOnTheStart = YES;
    
    [cat setPosition: catStartPosition];
    
    [coco setPosition: cocoStartPosition];
    
    timeLabel.string = @"00:00:00";
    
    [gameLayer reset];
    
    time = 0;
    
    //_products = nil;
    
    if(![Settings sharedSettings].isKidsModeBuyed)
    {
        [self loadCat];
    }
    else
    {
        finishLine.opacity = 0;
        coco.opacity = 0;
        cat.opacity = 0;
    }
    
    if([Settings sharedSettings].isGhostChickBuyed)
    {
        [self loadEnergy];
        energy = 0;
    }
}


- (void) exitToMainMenu
{
    [gameLayer exitToMainMenu];
}

- (void) exitToCustomizationMenu
{
    [gameLayer exitToCustomization];
}

@end
