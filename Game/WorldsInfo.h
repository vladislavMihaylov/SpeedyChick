//
//  WorldsInfo.h
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WorldsInfo: NSObject
{
    int _uniqueID;
    NSString *_points;
    NSString *_bonusPoints;
    NSString *_times;
}


@property (nonatomic, assign) int uniqueID;
@property (nonatomic, assign) NSString *points;
@property (nonatomic, assign) NSString *bonusPoints;
@property (nonatomic, assign) NSString *times;

- (id) initWithUniqueID: (int) uniqueID isOpen: (NSString *) points openLevels: (NSString *) bonusPoints times: (NSString *) times;

@end
