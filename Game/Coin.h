//
//  Coin.h
//  Game
//
//  Created by Vlad on 30.04.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Coin : CCNode
{
    CCSprite *coinSprite;
    
    BOOL isActive;
}

@property (nonatomic, assign) BOOL isActive;

@end
