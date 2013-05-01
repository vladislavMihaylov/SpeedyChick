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


@implementation MainMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    
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
    
    nameLabel.string = [NSString stringWithFormat: @"Hello, %@", [Settings sharedSettings].nameOfPlayer];
    
    CCMenuItemImage *rocketBtn = [CCMenuItemImage itemFromNormalSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                                        selectedSprite: [CCSprite spriteWithSpriteFrameName: @"rocket.png"]
                                                                target: self
                                                              selector: @selector(buyRocket)];
    
    rocketBtn.position = posForRocket.position;
    
    CCMenu *rocketMenu = [CCMenu menuWithItems: rocketBtn, nil];
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

- (void) showAlert
{
    rootMenu.isTouchEnabled = NO;
    
    CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"buyLevelBg.png"];
    bg.position = ccp(GameCenterX, GameCenterY);
    bg.scale = 0;
    [self addChild: bg z: 2 tag: 31];
    
    CCLabelBMFont *alert = [CCLabelBMFont labelWithString: @"You need \n 10 coins!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
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

# pragma mark update

- (void) updateRocketsAndCoinsString
{
    rocketsLabel.string = [NSString stringWithFormat: @"%i rockets", [Settings sharedSettings].countOfRockets];
    coinsLabel.string = [NSString stringWithFormat: @"%i coins", [Settings sharedSettings].countOfCoins];
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

- (void) buyRocket
{
    if([Settings sharedSettings].countOfCoins >= 10)
    {
        [Settings sharedSettings].countOfCoins -= 10;
        [Settings sharedSettings].countOfRockets++;
        
        [[Settings sharedSettings] save];
        
        [self updateRocketsAndCoinsString];
    }
    else
    {
        [self showAlert];
    }
}

# pragma mark Methods of press

- (void) pressedPlay
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectWorldMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}


- (void) pressedGetCoins
{
    getCoinsBtn.isEnabled = NO;
    [getCoinsBtn setOpacity: 150];
    
    timeLabel.string = @"01:59:59";
    
    [Settings sharedSettings].countOfCoins += 15;
    
    [self updateRocketsAndCoinsString];
    
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval: 7200];
    
    NSString *newDateString = [NSString stringWithFormat: @"%@", newDate];
    
    [Settings sharedSettings].futureDate = newDateString;
    
    [[Settings sharedSettings] save];
    
    [self schedule: @selector(timer) interval: 1];
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
