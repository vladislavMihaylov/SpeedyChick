//
//  WorldsDatabase.m
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WorldsDatabase.h"
#import "WorldsInfo.h"

@implementation WorldsDatabase

static WorldsDatabase *_database;

+ (WorldsDatabase *) database
{
    if(_database == nil)
    {
        _database = [[WorldsDatabase alloc] init];
    }
    
    return _database;
}

- (void) dealloc
{
    sqlite3_close(_database);
    
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource: @"speedyChickDatabase" ofType: @"sqlite3"];
        
        if(sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }
    }
    
    return self;
}

- (NSArray *) worldsInfosWithID: (NSInteger) ID
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *query = [NSString stringWithFormat: @"SELECT id, points, bonusPoints, times FROM levels WHERE id = %i", ID];
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            int uniqueID = sqlite3_column_int(statement, 0);
            const unsigned char *charPoints = sqlite3_column_text(statement, 1);
            const unsigned char *charBonusPoints = sqlite3_column_text(statement, 2);
            const unsigned char *charTimes = sqlite3_column_text(statement, 3);
            
            NSString *points = [NSString stringWithFormat: @"%s", charPoints];
            NSString *bonusPoints = [NSString stringWithFormat: @"%s", charBonusPoints];
            NSString *times = [NSString stringWithFormat: @"%s", charTimes];
            
            WorldsInfo *info = [[WorldsInfo alloc] initWithUniqueID: (int) uniqueID isOpen: (NSString *) points openLevels: (NSString *) bonusPoints times: (NSString *) times];
            
            [retval addObject: info];
            
            [info release];
        }
        
        sqlite3_finalize(statement);
    }
    
    
    
    return retval;
    
}



@end
