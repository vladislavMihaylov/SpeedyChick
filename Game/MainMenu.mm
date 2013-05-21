//
//  MainMenu.m
//  Game
//
//  Created by Vlad on 06.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameLayer.h"
#import "GameConfig.h"
#import "Settings.h"
#import "Chartboost.h"
#import "CCBReader.h"

#import "Appirater.h"

@implementation MainMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
    CCLOG(@"kidsMode: %i", [Settings sharedSettings].isKidsModeBuyed);
    CCLOG(@"superChick: %i", [Settings sharedSettings].isSuperChickBuyed);
    CCLOG(@"ghostChick: %i", [Settings sharedSettings].isGhostChickBuyed);
    CCLOG(@"Ads: %i", [Settings sharedSettings].isAdEnabled);
    
    //[Appirater showPrompt];
    
    [Settings sharedSettings].countOfRockets = 1;
    [[Settings sharedSettings] save];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"mainMenuTextures%@.plist", suffix]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"SelectMenuFiles%@.plist", suffix]];
    
    CCSprite *curPinguinSprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c_%i.png", [Settings sharedSettings].currentPinguin]];
    curPinguinSprite.position = curPinguin.position;
    [self addChild: curPinguinSprite];
    
    [self updateRocketsAndCoinsString];
    
    
    // if timer is run
    if(![[Settings sharedSettings].futureDate isEqualToString: @""])
    {
        [self schedule: @selector(timer) interval: 1];
        
        getCoinsBtn.isEnabled = NO;
        [getCoinsBtn setOpacity: 150];
    }
    
    nameLabel.string = [NSString stringWithFormat: @"Help %@ to win!", [Settings sharedSettings].nameOfPlayer];
    nameLabel.color = ccc3(0, 0, 255);
    
    CCMenuItemImage *rocketBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                                                target: self
                                                              selector: @selector(buyRocketOrCoin)
                                  ];
    
    rocketBtn.position = posForRocket.position;
    
    CCMenuItemImage *coinBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"coin.png"]
                                                      selectedSprite: [CCSprite spriteWithSpriteFrameName: @"coin.png"]
                                                              target: self
                                                            selector: @selector(buyRocketOrCoin)
                                ];
    
    coinBtn.position = posForCoin.position;
    
    rocketMenu = [CCMenu menuWithItems: rocketBtn, coinBtn, nil];
    rocketMenu.position = ccp(0, 0);
    [self addChild: rocketMenu];
    
    if([Settings sharedSettings].countOfRuns % 10 == 0)
    {
        if(!isInviteShowed)
        {
            isInviteShowed = YES;
            [self showInviteToShop];
        }
    }
    
    
    if(isUserPlayed)
    {
        if([Settings sharedSettings].countOfRuns == 1)
        {
            isUserPlayed = NO;
            [self showAlert: @"      Want to get Coins? \n   Click on the \"get coins\" \nbutton to collect 100 coins." type: 3];
        }
    }
    
    
    [chickSprite runAction:
            [CCRepeatForever actionWithAction:
                        [CCSequence actions:
                                    [CCMoveTo actionWithDuration: 1
                                                        position: ccp(chickSprite.position.x, chickSprite.position.y + 10)],
                                    [CCMoveTo actionWithDuration: 1
                                                        position: ccp(chickSprite.position.x, chickSprite.position.y - 10)],
                         nil]
             ]
     ];
    
    [catSprite runAction:
            [CCRepeatForever actionWithAction:
                        [CCSequence actions:
                                    [CCMoveTo actionWithDuration: 1
                                                        position: ccp(catSprite.position.x, catSprite.position.y - 10)],
                                    [CCMoveTo actionWithDuration: 1
                                                        position: ccp(catSprite.position.x, catSprite.position.y + 10)],
                         nil]
             ]
     ];
    
    

}

# pragma mark Invite to shop

- (void) showInviteToShop
{
    rootMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: @"Come to the store!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    [bg addChild: alert];
    
    CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]] selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                                            target: self selector: @selector(pressedShop)];
    okBtn.position = ccp(bg.contentSize.width * 0.3, bg.contentSize.height * 0.2);
    
    CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtn.png"]]
                             selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"cancelBtnOn.png"]]
                                     target: self
                                   selector: @selector(hideAlert)
       ];
    
    cancelBtn.position = ccp(bg.contentSize.width * 0.7, bg.contentSize.height * 0.2);
    
    CCMenu *alertMenu = [CCMenu menuWithItems: okBtn, cancelBtn, nil];
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

# pragma mark Alert 

- (void) showAlert: (NSString *) message type: (NSInteger) type
{
    rootMenu.isTouchEnabled = NO;
    rocketMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: message fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
    alert.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
    alert.color = ccc3(255, 255, 255);
    [bg addChild: alert];
    
    CCMenu *alertMenu = [CCMenu menuWithItems: nil];
    
    if(type == 1) // Single okBtn
    {
        CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtn.png"]]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"OkBtnOn.png"]]
                                                                target: self
                                                              selector: @selector(hideAlert)
                                  ];
        okBtn.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.2);
        
        [alertMenu addChild: okBtn];
    }
    
    if(type == 2) // okBtn & cancelBtn
    {
        CCMenuItemImage *okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"yesBtn%@.png", suffix]
                                                        selectedImage: [NSString stringWithFormat: @"yesBtnOn%@.png", suffix]
                                                               target: self
                                                             selector: @selector(pressedShop)
                                  ];
        
        okBtn.position = ccp(bg.contentSize.width * 0.27, bg.contentSize.height * 0.15);
        
        CCMenuItemImage *cancelBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"noBtn%@.png", suffix]
                                                            selectedImage: [NSString stringWithFormat: @"noBtnOn%@.png", suffix]
                                                                target: self
                                                              selector: @selector(hideAlert)
                                  ];
        
        cancelBtn.position = ccp(bg.contentSize.width * 0.73, bg.contentSize.height * 0.15);
        
        [alertMenu addChild: okBtn];
        [alertMenu addChild: cancelBtn];
    }
    if(type == 3)
    {
        CCMenuItemImage *getThemNowBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"collectThemNowBtn%@.png", suffix]
                                                                selectedImage: [NSString stringWithFormat: @"collectThemNowBtnOn%@.png", suffix]
                                                                       target: self
                                                                     selector: @selector(pressedGetCoins)
                                  ];
        getThemNowBtn.position = ccp(bg.contentSize.width/2, bg.contentSize.height * 0.2);
        
        [alertMenu addChild: getThemNowBtn];
    }
        
   
    alertMenu.position = ccp(0, 0);
    [bg addChild: alertMenu];
    
    [bg runAction: [CCEaseBackOut actionWithAction: [CCScaleTo actionWithDuration: 0.5 scale: 1]]];
}

- (void) hideAlert
{
    rootMenu.isTouchEnabled = YES;
    rocketMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
    CCLOG(@"OK");
}

# pragma mark update

- (void) updateRocketsAndCoinsString
{
    rocketsLabel.string = [NSString stringWithFormat: @"x %i", [Settings sharedSettings].countOfRockets];
    coinsLabel.string = [NSString stringWithFormat: @"x %i", [Settings sharedSettings].countOfCoins];
    
    rocketsLabel.color = ccc3(0, 0, 255);
    coinsLabel.color = ccc3(0, 0, 255);
}

- (void) timer
{
    NSString *date = [Settings sharedSettings].futureDate;
    
    NSDateFormatter *dateFormatterStr = [[NSDateFormatter new] autorelease];
    
    [dateFormatterStr setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    
    NSDate *dateFromStr = [dateFormatterStr dateFromString: date];
    
    NSInteger diff = [dateFromStr timeIntervalSinceNow];
    
    NSInteger hours;
    NSInteger minutes;
    NSInteger seconds;
    
    hours = diff / 3600;
    minutes = (diff - hours * 3600) / 60;
    seconds = (diff - hours * 3600 - minutes * 60);
    
    
    NSString *h = [NSString stringWithFormat: @"0%i", hours];
    NSString *m;
    NSString *s;
    
    if(minutes < 10)
    {
        m = [NSString stringWithFormat: @"0%i", minutes];
    }
    else
    {
        m = [NSString stringWithFormat: @"%i", minutes];
    }
    
    if(seconds < 10)
    {
        s = [NSString stringWithFormat: @"0%i", seconds];
    }
    else
    {
        s = [NSString stringWithFormat: @"%i", seconds];
    }
    
    NSString *timeStr = [NSString stringWithFormat: @"%@:%@:%@", h, m, s];
    
    timeLabel.string = timeStr;
    timeLabel.color = ccc3(0, 0, 255);
    
    if(diff <= 0)
    {
        timeLabel.string = @"";
        
        [Settings sharedSettings].futureDate = @"";
        [[Settings sharedSettings] save];
        
        [self unschedule: @selector(timer)];
        
        getCoinsBtn.isEnabled = YES;
        [getCoinsBtn setOpacity: 255];
    }
}

# pragma mark Buy

- (void) buyRocketOrCoin
{
    [self showAlert: @"Want to get more \nCoins or Rockets?" type: 2];
}

# pragma mark Methods of press

- (void) pressedPlay
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectWorldMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}


- (void) pressedGetCoins
{
    //rootMenu.isTouchEnabled = YES;
    //rocketMenu.isTouchEnabled = YES;
    [self removeChildByTag: 31 cleanup: YES];
    
    getCoinsBtn.isEnabled = NO;
    [getCoinsBtn setOpacity: 150];
    
    timeLabel.string = @"01:59:59";
    timeLabel.color = ccc3(0, 0, 255);
    
    [self showAlert: @"        Bonus collected\n  You have just collected\n        100 free coins! \nCome back later for more!" type: 1];
    
    [Settings sharedSettings].countOfCoins += 100;
    
    [self updateRocketsAndCoinsString];
    
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval: 7200];
    
    NSString *newDateString = [NSString stringWithFormat: @"%@", newDate];
    
    [Settings sharedSettings].futureDate = newDateString;
    
    [[Settings sharedSettings] save];
    
    [self addNotificationAboutCoins];
    
    [self schedule: @selector(timer) interval: 1];
}

- (void) addNotificationAboutCoins
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    notif.timeZone = [NSTimeZone defaultTimeZone]; //часовой пояс, я обычно пользуюсь в программах дефолтным по Гринвичу, но можно использовать systemTimeZone, это будет время в устройстве.
    
    notif.fireDate = [[NSDate date] dateByAddingTimeInterval: 7200.0f]; //время, когда наступит время нотификатора, у нас это текущая дата + 20 секунд. Можно прибегнуть к помощи NSDateComponents для установок своей даты.
    
    notif.alertAction = @"Get them!"; //Текст кнопочки, вызывающей вашу программу из фонового режима
    
    notif.alertBody = @"100 Coins are awaiting for you now. Come and get them!"; //Тело сообщения над кнопочкой
    
    notif.soundName = UILocalNotificationDefaultSoundName; //дефолтный звук сообщения. Можно задать свой в папке проекта.
    
    //notif.applicationIconBadgeNumber = 1; //число "бейджа" на иконке приложения при наступлении уведомления
    
    notif.repeatInterval = NSDayCalendarUnit; //если необходимо, используем повтор (не пытайтесь установить свое время повтора, это невозможно. Используйте только NSCalendarCalendarUnit.
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif]; //Размещаем наше локальное уведомление!
    
    [notif release];
}

- (void) pressedCustomise
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"CustomizeMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedShop
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"ShopMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
