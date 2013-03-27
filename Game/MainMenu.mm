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

#import "CCBReader.h"

@implementation MainMenu

- (void) didLoadFromCCB
{
    CCSprite *curPinguinSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"pinguin_%i.png", [Settings sharedSettings].currentPinguin]];
    curPinguinSprite.scale = 1.5;
    curPinguinSprite.position = curPinguin.position;
    [self addChild: curPinguinSprite];
    
    
    //CCSprite *curRocketSprite = [CCSprite spriteWithFile: @"rocket.png"];
    //curRocketSprite.position = curRockets.position;
    //[self addChild: curRocketSprite];
    
    [self updateRocketsAndCoinsString];
    
        
    if(![[Settings sharedSettings].futureDate isEqualToString: @""])
    {
        [self schedule: @selector(timer) interval: 1];
        
        getCoinsBtn.isEnabled = NO;
        [getCoinsBtn setOpacity: 150];
    }
    
    nameLabel.string = [NSString stringWithFormat: @"Hello, %@", [Settings sharedSettings].nameOfPlayer];
    
    //NSString *date = [NSString stringWithFormat: @"%@", strDate];
    
    //timeLabel.string = date;
}

- (void) updateRocketsAndCoinsString
{
    rocketsLabel.string = [NSString stringWithFormat: @"%i rockets", [Settings sharedSettings].countOfRockets];
    coinsLabel.string = [NSString stringWithFormat: @"%i coins", [Settings sharedSettings].countOfCoins];
}

- (void) dealloc
{
    [super dealloc];
}

- (void) pressedPlay
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SelectWorldMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
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

- (void) pressedGetCoins
{
    getCoinsBtn.isEnabled = NO;
    [getCoinsBtn setOpacity: 150];
    
    timeLabel.string = @"01:59:59";
    
    [Settings sharedSettings].countOfRockets++;
    [Settings sharedSettings].countOfCoins++;
    
    [self updateRocketsAndCoinsString];
    
    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval: 7200];
    
    
    
    NSString *newDateString = [NSString stringWithFormat: @"%@", newDate];
    
    [Settings sharedSettings].futureDate = newDateString;
    
    [[Settings sharedSettings] save];
    
    CCLOG(@"DATE %@",[Settings sharedSettings].futureDate);

    //CCLOG(@"difference %f", [[Settings sharedSettings].futureDate timeIntervalSinceNow]);
    
    [self schedule: @selector(timer) interval: 1];
}


- (void) pressedCustomise
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"CustomizeMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) pressedShop
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"ShopMenu.ccb"];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
