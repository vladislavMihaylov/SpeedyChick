//
//  MainMenu.h
//  Game
//
//  Created by Vlad on 06.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MPAdView.h"

@interface MainMenu: CCLayer <MPAdViewDelegate>
{
    CCNode *curPinguin;
    CCNode *curRockets;
    CCNode *posForRocket;
    CCSprite *posForCoin;
    
    CCMenu *rootMenu;
    CCMenu *rocketMenu;
    CCMenuItemImage *getCoinsBtn;
    
    CCLabelBMFont *timeLabel;
    CCLabelBMFont *rocketsLabel;
    CCLabelBMFont *coinsLabel;
    
    CCLabelBMFont *nameLabel;

    CCSprite *chickSprite;
    CCSprite *catSprite;
    
    MPAdView *adView;
}

@property (nonatomic, retain) MPAdView *adView;

@end
