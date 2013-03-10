//
//  Bonus.h
//  Game
//
//  Created by Vlad on 09.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bonus: CCNode
{
    CCSprite *bonusSprite;
    
    BOOL isActive;
}

@property (nonatomic, assign) BOOL isActive;

@end
