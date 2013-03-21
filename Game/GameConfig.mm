//
//  GameConfig.m
//  Game
//
//  Created by Vlad on 08.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

CGPoint catStartPosition = CGPointMake(40, 40);
CGPoint cocoStartPosition = CGPointMake(240, 40);
CGPoint finishPointForCoco = CGPointMake(440, 40);

NSInteger currentWorld = 0;
NSInteger currentLevel = 0;
NSInteger defaultHeightOfFly = 800;
NSInteger defaultSpeedOfFly = 33;
NSInteger costForOpenLevel = 100;

NSInteger currentHeightOfFly = 0;
NSInteger currentSpeedOfFly = 0;

float countOfMana = 0;

BOOL isGameActive = NO;
BOOL ChickOnTheStart = YES;
