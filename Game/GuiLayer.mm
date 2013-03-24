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

@implementation GuiLayer

@synthesize gameLayer;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        showNewWorld = NO;
        
        applyRocket = [CCMenuItemImage itemFromNormalImage: @"rocket.png" selectedImage: @"rocket.png" target: self selector: @selector(applyRocket)];
        applyRocket.position = ccp(380, 270);
        
        CCMenuItemImage *reset = [CCMenuItemImage itemFromNormalImage: @"pauseBtn.png" selectedImage: @"pauseBtn.png" target: self selector: @selector(doPause)];
        reset.position = ccp(450, 290);
        
        CCMenu *ROCKET = [CCMenu menuWithItems: applyRocket, reset, nil];
        ROCKET.position = ccp(0, 0);
        [self addChild: ROCKET z: 10 tag: 111];
        
        [self updateRocket];
        
        timeLabel = [CCLabelTTF labelWithString: @"00:00:00" fontName: @"Arial" fontSize: 20];
        timeLabel.position = ccp(240, 300);
        timeLabel.color = ccc3(0, 0, 0);
        [self addChild: timeLabel];
        
        time = 0;
        
        if([Settings sharedSettings].isCatEnabled)
        {
            [self loadCat];
        }
        
        ChickOnTheStart = YES;
        
    }
    
    return self;
}

#pragma mark Cat

- (void) loadCat
{
    cat = [CCSprite spriteWithFile: @"cat.png"];
    [cat setPosition: catStartPosition];
    [self addChild: cat];
    
    coco = [CCSprite spriteWithFile: @"coco.png"];
    [coco setPosition: cocoStartPosition];
    [self addChild: coco z: 10];
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
    if([Settings sharedSettings].isCatEnabled)
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
    }
}

#pragma mark GameState

- (void) doPause
{
    if(isGameActive)
    {
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithFile: @"menuBg.png"];
        menuBg.position = ccp(240, 480);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" selectedImage: @"exitBtn.png" target: self selector: @selector(exitToMainMenu)];
        exit.position = ccp(menuBg.contentSize.width/4, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage: @"restartBtn.png" selectedImage: @"restartBtn.png" target: self selector:@selector(resetLevel)];
        restart.position = ccp(menuBg.contentSize.width/2, menuBg.contentSize.height / 2);
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage: @"continueBtn.png" selectedImage: @"continueBtn.png" target: self selector:@selector(unPause)];
        play.position = ccp(menuBg.contentSize.width/2 + menuBg.contentSize.width/4, menuBg.contentSize.height / 2);
        
        
        CCMenu *pauseMenu = [CCMenu menuWithItems: exit, restart, play, nil];
        pauseMenu.position = ccp(0, 0);
        
        
        [menuBg addChild: pauseMenu z:1 tag: 45];
        
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(240, 160)]];
        
        isGameActive = NO;
        
        
    }
}

- (void) doGameOver
{
    if(isGameActive)
    {
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithFile: @"menuBg.png"];
        menuBg.position = ccp(240, 480);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" selectedImage: @"exitBtn.png" target: self selector: @selector(exitToMainMenu)];
        exit.position = ccp(menuBg.contentSize.width * 0.35, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage: @"restartBtn.png" selectedImage: @"restartBtn.png" target: self selector:@selector(resetLevel)];
        restart.position = ccp(menuBg.contentSize.width * 0.65, menuBg.contentSize.height / 2);
        
        
        CCMenu *gameOverMenu = [CCMenu menuWithItems: exit, restart, nil];
        gameOverMenu.position = ccp(0, 0);
        [menuBg addChild: gameOverMenu];
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(240, 160)]];
        
        isGameActive = NO;
    }
}

- (void) playNextLevel
{
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
    
    
    
    [gameLayer nextLevel];
}

- (void) sendToFB
{
    SHKItem *facebookItem = [SHKItem text: [NSString stringWithFormat: @"I am finished with time %@", timeLabel.string]];
    [SHKFacebook shareItem: facebookItem];
}

- (void) unPause
{
    if(!isGameActive)
    {
        [self removeChildByTag: menuBgTag cleanup: YES];
        
        isGameActive = YES;
        
        [self resumeSchedulerAndActions];
        [cat resumeSchedulerAndActions];
    }
}

- (void) finish
{
    CCLOG(@"W %i H %i", currentWorld, currentLevel);
    
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
    
    CCLOG(@"Stars : %i", curStars);
    
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
        NSString *nextLevel = [openedLevels substringWithRange: NSMakeRange(position + 1, 1)];
        NSInteger intNextLevel = [nextLevel integerValue];
         CCLOG(@"nextLevel %i", intNextLevel);
        [openedLevels replaceCharactersInRange: NSMakeRange(position + 1, 1) withString: @"1"];
        NSString *newLevelsData = [NSString stringWithFormat: @"%@", openedLevels];
        
        [Settings sharedSettings].openedLevels = newLevelsData;
    }
    
    [[Settings sharedSettings] save];

    
    if(currentLevel % 5 == 0)
    {
        CCLOG(@"IT WAS 5 LEVEL");
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
        
        
        isGameActive = NO;
        
        [self pauseSchedulerAndActions];
        [cat pauseSchedulerAndActions];
        
        CCSprite *menuBg = [CCSprite spriteWithFile: @"menuBg.png"];
        menuBg.position = ccp(240, 480);
        [self addChild: menuBg z: 10 tag: menuBgTag];
        
        CCMenuItemImage *exit = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" selectedImage: @"exitBtn.png" target: self selector: @selector(exitToMainMenu)];
        exit.position = ccp(menuBg.contentSize.width * 0.25, menuBg.contentSize.height / 2);
        exit.tag = exitBtnTag;
        
        CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage: @"restartBtn.png" selectedImage: @"restartBtn.png" target: self selector:@selector(resetLevel)];
        restart.position = ccp(menuBg.contentSize.width * 0.5, menuBg.contentSize.height / 2);
        
        CCMenuItemImage *shareToFBBtn = [CCMenuItemImage itemFromNormalImage: @"facebookBtn.jpg" selectedImage: @"facebookBtnOn.jpg" target: self selector:@selector(sendToFB)];
        shareToFBBtn.position = ccp(menuBg.contentSize.width * 0.5, 0);
        
        CCMenuItemImage *next;
        
        if(!showNewWorld)
        {
            next = [CCMenuItemImage itemFromNormalImage: @"nextLevel.png" selectedImage: @"nextLevel.png" target: self selector:@selector(playNextLevel)];
        }
        else
        {
            next = [CCMenuItemImage itemFromNormalImage: @"nextLevel.png" selectedImage: @"nextLevel.png" target: self selector:@selector(showWorldsMenu)];
        }
        next.position = ccp(menuBg.contentSize.width * 0.75, menuBg.contentSize.height / 2);
        
        CCMenu *gameOverMenu = [CCMenu menuWithItems: exit, restart, shareToFBBtn, next, nil];
        gameOverMenu.position = ccp(0, 0);
        [menuBg addChild: gameOverMenu];
        
        [menuBg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(240, 160)]];
        
        CCSprite *stars = [CCSprite spriteWithFile: [NSString stringWithFormat: @"%istars.png", curStars]];
        stars.position = ccp(menuBg.contentSize.width / 2, menuBg.contentSize.height);
        [menuBg addChild: stars];
    }
}

- (void) showWorldsMenu
{
    CCScene * scene = [CCBReader sceneWithNodeGraphFromFile: @"SelectWorldMenu.ccb"];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) start
{
    ChickOnTheStart = NO;
    
    [self schedule: @selector(timer) interval: 0.01];
    
    if([Settings sharedSettings].isCatEnabled)
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
}

- (void) resetLevel
{
    [self unPause];
    
    [cat stopAllActions];
    
    [self unschedule: @selector(timer)];
    
    ChickOnTheStart = YES;
    
    [cat setPosition: catStartPosition];
    
    [coco setPosition: cocoStartPosition];
    
    timeLabel.string = @"00:00:00";
    
    [gameLayer reset];
    
    time = 0;
}


- (void) exitToMainMenu
{
    [self unPause];
    
    [gameLayer exitToMainMenu];
    
}



@end
