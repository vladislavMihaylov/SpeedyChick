//
//  Configuration.h
//  Game
//
//  Created by Vlad on 17.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Configuration: CCNode
{
    
}

+ (Configuration *) sharedConfiguration;

- (void) setConfig;
- (void) setParameters;


@end
