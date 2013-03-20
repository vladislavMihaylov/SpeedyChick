//
//  WorldsInfo.m
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WorldsInfo.h"


@implementation WorldsInfo

@synthesize uniqueID = _uniqueID;
@synthesize points = _points;
@synthesize bonusPoints = _bonusPoints;
@synthesize times = _times;

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithUniqueID: (int) uniqueID isOpen: (NSString *) points openLevels: (NSString *) bonusPoints times: (NSString *) times
{
    if((self = [super init]))
    {
        self.uniqueID = uniqueID;
        self.points = points;
        self.bonusPoints = bonusPoints;
        self.times = times;
    }
    
    return self;
}


@end
