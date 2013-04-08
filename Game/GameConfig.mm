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
NSInteger defaultHeightOfFly = 550;
NSInteger defaultSpeedOfFly = 33;
NSInteger costForOpenLevel = 100;

NSInteger currentHeightOfFly = 0;
NSInteger currentSpeedOfFly = 0;

NSInteger coefForCoords = 1;

NSString *suffix = @"";

float countOfMana = 0;

BOOL isGameActive = NO;
BOOL isPauseOfGame = NO;
BOOL ChickOnTheStart = YES;
BOOL isFinish = NO;

float GameWidth =  480;
float GameHeight = 320;

float GameCenterX = GameWidth / 2;
float GameCenterY = GameHeight / 2;

float xPositionForTextField;
float yPositionForTextField;

CGRect rectForTextField = CGRectMake(-20, 220, 240, 40);

float textFontSize = 30;

float bodyRadius = iPhoneRadius;

NSInteger segmentWidth = usualSegmentWidth;