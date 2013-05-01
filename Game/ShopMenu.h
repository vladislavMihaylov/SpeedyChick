//
//  ShopMenu.h
//  Game
//
//  Created by Vlad on 07.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopMenu: CCLayer
{
    CCNode *item_1;
    CCNode *item_2;
    CCNode *item_3;
    
    CCNode *itemsLayer;
    
    NSArray *_products;
    
    NSMutableArray *allItemsArray;
    NSMutableArray *consumPurchases;
    
    CGPoint touchBegin;
    CGPoint curMenusPosition;
    CGPoint rightBorderForItems;
    
    CCLabelBMFont *rocketsLabel;
    CCLabelBMFont *coinsLabel;
    
    CCMenu *shopMenu;
    CCMenu *restoreMenu;
    CCMenu *rootMenu;
    
    BOOL isCanMoveMenuToRight;
}

@end
