//
//  FirstLaunch.h
//  Game
//
//  Created by Vlad on 24.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FirstLaunch: CCLayer <UITextFieldDelegate>
{
    UITextField *nameField;
    
    CCMenuItemImage *okBtn;
}

+ (CCScene *) scene;

@end
