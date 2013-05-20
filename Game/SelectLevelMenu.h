//
//  SelectLevelMenu.h
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class RootViewController;

@interface SelectLevelMenu: CCLayer
{
    CCMenu *selectLevelMenu;
    
    CCMenu *levelsMenu;
    
    CCMenu *alertMenu;
    
    NSArray *_products;
    
    BOOL isItemsLoaded;
    
    CCMenuItemImage *coins1000;
    CCMenuItemImage *coins5000;
    CCMenuItemImage *coins20000;
    
    CCLabelBMFont *waitingLabel;
    
    RootViewController *viewController;
}

@end
