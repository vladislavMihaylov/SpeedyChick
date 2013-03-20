//
//  WorldsDatabase.h
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <sqlite3.h>

@interface WorldsDatabase : NSObject
{
    sqlite3 *_database;
}

+ (WorldsDatabase *) database;
- (NSArray *) worldsInfosWithID: (NSInteger) ID;

@end
