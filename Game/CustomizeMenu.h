//
//  CustomizeMenu.h
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMenuAdvanced.h"

@interface CustomizeMenu: CCLayer
{
    CCMenu *rootMenu;
    
    CCMenuAdvanced *chicksMenu;
    
    CCLabelBMFont *coinsLabel;
    
    float menuPosY;
    
    CCSprite *bigChick;
}

@end
