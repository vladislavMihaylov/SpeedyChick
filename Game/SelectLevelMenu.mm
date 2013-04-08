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

@implementation SelectLevelMenu

- (void) dealloc
{
    [super dealloc];
}

- (void) didLoadFromCCB
{
    levelsMenu = [CCMenu menuWithItems: nil];
    levelsMenu.position = ccp(0, 0);
    [self addChild: levelsMenu];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"SelectMenuFiles%@.plist", suffix]];
    
    [self updateItems];
}

- (void) updateItems
{
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
                                                     selector: @selector(showBuyMenu:)
                         ];
            
            CCSprite *block = [CCSprite spriteWithSpriteFrameName: @"block.png"];
            block.position = ccp(levelItem.contentSize.width / 2, levelItem.contentSize.height / 2);
            block.scale = 0.5;
            [levelItem addChild: block];
            
            //levelItem.opacity = 100;
        }
        
        
        
        levelItem.tag = i;
        levelItem.position = ccp(GameWidth / 6 + GameWidth / 6 * i, GameCenterY);
        [levelsMenu addChild: levelItem];
    }
}

- (void) showBuyMenu: (CCMenuItem *) sender
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
    
    if([Settings sharedSettings].countOfCoins < costForOpenLevel)
    {
        label = [CCLabelBMFont labelWithString: @"You need \n 100 coins!" fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
        label.position = ccp(bg.contentSize.width * 0.5, bg.contentSize.height * 0.5);
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
        label = [CCLabelBMFont labelWithString: @"Do you want \n buy a level?" fntFile: @"timeFont.fnt"];
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
}

- (void) buyLevel: (CCMenuItem *) sender
{
    [Settings sharedSettings].countOfCoins -= 100;
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
    
    [self removeBuyMenu];
    
    [self updateItems];
}

- (void) back
{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"SelectWorldMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) playLevel: (CCMenuItem *) sender
{
    currentLevel = sender.tag + 1;
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: [GameLayer scene]]];
}

@end
