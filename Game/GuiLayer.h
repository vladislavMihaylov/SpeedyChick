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

@interface GuiLayer: CCLayer
{
    GameLayer *gameLayer;
    
    CCSprite *cat;
    CCSprite *coco;
    
    CCMenuItemImage *applyRocket;
    
    CCLabelTTF *timeLabel;
    CCLabelBMFont *energyLabel;
    
    NSInteger time;
    NSInteger curStars;
    NSInteger energy;
    
    BOOL showNewWorld;
}

- (void) start;
- (void) finish;

- (void) increaseEnergy;
- (void) decreaseEnergy;

- (void) moveCocoOffsetX: (float) offsetX andFinishPoint: (float) finishPoint;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) NSInteger energy;

@end
