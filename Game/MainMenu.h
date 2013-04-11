//
//  MainMenu.h
//  Game
//
//  Created by Vlad on 06.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenu: CCLayer
{
    CCNode *curPinguin;
    CCNode *curRockets;
    CCNode *posForRocket;
    
    CCMenu *rootMenu;
    CCMenuItemImage *getCoinsBtn;
    
    CCLabelBMFont *timeLabel;
    CCLabelBMFont *rocketsLabel;
    CCLabelBMFont *coinsLabel;
    
    CCLabelBMFont *nameLabel;

    CCSprite *chickSprite;
    CCSprite *catSprite;
}

@end
