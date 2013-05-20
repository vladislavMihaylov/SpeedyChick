//
//  GuiLayer.h
//  Game
//
//  Created by Vlad on 11.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;
@class RootViewController;

@interface GuiLayer: CCLayer
{
    GameLayer *gameLayer;
    
    CCSprite *finishLine;
    CCSprite *cat;
    CCSprite *coco;
    
    CCMenuItemImage *applyRocket;
    
    CCLabelBMFont *timeLabel;
    CCLabelBMFont *energyLabel;
    
    NSInteger time;
    NSInteger curStars;
    NSInteger energy;
    
    BOOL showNewWorld;
    
    CCMenu *gameOverMenu;
    
    CCMenu *alertMenu;
    
    NSArray *_products;
    
    BOOL isItemsLoaded;
    
    
    CCMenuItemImage *rocket3;
    CCMenuItemImage *rocket15;
    CCMenuItemImage *rocket50;
    
    CCLabelBMFont *waitingLabel;
    
    CCMenuItemImage *okBtn;
    
    RootViewController *viewController;
}

- (void) start;
- (void) finish;

- (void) increaseEnergy;
- (void) decreaseEnergy;

- (void) updateRocket;

- (void) moveCocoOffsetX: (float) offsetX andFinishPoint: (float) finishPoint;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) NSInteger energy;

@end
