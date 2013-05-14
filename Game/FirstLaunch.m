//
//  FirstLaunch.m
//  Game
//
//  Created by Vlad on 24.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FirstLaunch.h"

#import "Settings.h"

#import "CCBReader.h"
#import "GameConfig.h"
#import "MainMenu.h"

@implementation FirstLaunch

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    FirstLaunch *layer = [FirstLaunch node];
    
    [scene addChild: layer];
    
    return scene;
}

- (void) dealloc
{    
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"mainMenuTextures%@.plist", suffix]];
        
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"mainMenuBg.png"];
        bg.position = ccp(GameCenterX, GameCenterY);
        [self addChild: bg];
        
        CCLabelBMFont *tapTheEgg = [CCLabelBMFont labelWithString: @"Tap twice on the egg to get your chick!"
                                                           fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]
                                     ];
        
        tapTheEgg.position = ccp(GameCenterX, GameCenterY / 2.5);
        [self addChild: tapTheEgg z: 2 tag: 2];
        
        CCMenu *eggMenu = [CCMenu menuWithItems: nil];
        eggMenu.position = ccp(0, 0);
        [self addChild: eggMenu z:1 tag: 1];
        
        CCMenuItemImage *egg = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"egg1%@.png", suffix]
                                                      selectedImage: [NSString stringWithFormat: @"egg1%@.png", suffix]
                                                             target: self
                                                           selector: @selector(tapEgg)
                                ];
        
        egg.position = ccp(GameCenterX, GameCenterY);
        
        [eggMenu addChild: egg];
        
        okBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"okBtn%@.png", suffix]
                                       selectedImage: [NSString stringWithFormat: @"okBtn%@.png", suffix]
                                              target: self
                                            selector: @selector(pressedOkBtn)
                 ];
        
        okBtn.position = ccp(GameCenterX, GameCenterY / 2);
        
        okBtn.isEnabled = NO;
        okBtn.visible = NO;
        
        CCMenu *menu = [CCMenu menuWithItems: okBtn, nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
        
        CCSprite *leftArrow = [CCSprite spriteWithFile: @"leftArrow.png"];
        leftArrow.position = ccp(GameCenterX * 1.4, GameCenterY);
        leftArrow.scale = 1.5;
        [self addChild: leftArrow z: 2 tag: 3];
        
        CCSprite *rightArrow = [CCSprite spriteWithFile: @"rightArrow.png"];
        rightArrow.position = ccp(GameCenterX * 0.6, GameCenterY);
        rightArrow.scale = 1.5;
        [self addChild: rightArrow z: 2 tag: 4];
        
        [leftArrow runAction:
            [CCRepeatForever actionWithAction:
                        [CCSequence actions:
                                    [CCMoveTo actionWithDuration: 0.8
                                                        position: ccp(leftArrow.position.x - 10, leftArrow.position.y)],
                                    [CCMoveTo actionWithDuration: 0.8
                                                        position: ccp(leftArrow.position.x + 10, leftArrow.position.y)],
                         nil]
             ]
         ];
        
        [rightArrow runAction:
            [CCRepeatForever actionWithAction:
                        [CCSequence actions:
                                    [CCMoveTo actionWithDuration: 0.8
                                                        position: ccp(rightArrow.position.x + 10, rightArrow.position.y)],
                                    [CCMoveTo actionWithDuration: 0.8
                                                        position: ccp(rightArrow.position.x - 10, rightArrow.position.y)],
                         nil]
             ]
         ];
        
        
    }
    
    return self;
}

- (void) tapEgg
{
    [self removeChildByTag: 1 cleanup: YES];
    [self removeChildByTag: 2 cleanup: YES];
    
    CCMenuItemImage *egg2 = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"egg2%@.png", suffix]
                                                   selectedImage: [NSString stringWithFormat: @"egg2%@.png", suffix]
                                                          target: self
                                                        selector: @selector(brakeEgg)
                             ];
    
    egg2.position = ccp(GameCenterX, GameCenterY);
    
    CCMenu *eggMenu2 = [CCMenu menuWithItems: egg2, nil];
    eggMenu2.position = ccp(0, 0);
    [self addChild: eggMenu2 z:1 tag: 2];
    
    [egg2 runAction:
                [CCSequence actions:
                                [CCMoveTo actionWithDuration: 0.05 position: ccp(egg2.position.x + 5, egg2.position.y)],
                                [CCMoveTo actionWithDuration: 0.1 position: ccp(egg2.position.x - 5, egg2.position.y)],
                                [CCMoveTo actionWithDuration: 0.05 position: ccp(egg2.position.x, egg2.position.y)],
                 nil]
    ];
}

- (void) brakeEgg
{
    [self removeChildByTag: 2 cleanup: YES];
    [self removeChildByTag: 3 cleanup: YES];
    [self removeChildByTag: 4 cleanup: YES];
    
    CCLabelBMFont *enterNameLabel = [CCLabelBMFont labelWithString: @"Name your chick!"
                                                           fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]
                                     ];
    
    enterNameLabel.position = ccp(GameCenterX, GameHeight * 1.2);
    enterNameLabel.scale = 1.4;
    enterNameLabel.color = ccc3(0, 0, 255);
    [self addChild: enterNameLabel];
    
    CCSprite *chick = [CCSprite spriteWithFile: [NSString stringWithFormat: @"chick%@.png", suffix]];
    chick.position = ccp(GameCenterX, GameCenterY);
    chick.scale = 0.5;
    [self addChild: chick];
    
    CCSprite *leftEgg = [CCSprite spriteWithFile: [NSString stringWithFormat: @"egg_3_left%@.png", suffix]];
    leftEgg.position = ccp(GameCenterX, GameCenterY);
    
    CCSprite *rightEgg = [CCSprite spriteWithFile: [NSString stringWithFormat: @"egg_3_right%@.png", suffix]];
    rightEgg.position = ccp(GameCenterX, GameCenterY);
    
    [self addChild: leftEgg];
    [self addChild: rightEgg];
    
    [leftEgg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(-100, leftEgg.position.y)]];
    [rightEgg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(GameWidth + 100, rightEgg.position.y)]];
    
    [chick runAction:
                [CCSequence actions:
                                [CCScaleTo actionWithDuration: 1 scale: 1],
                                [CCScaleTo actionWithDuration: 0.5 scale: 0],
                                [CCCallFunc actionWithTarget: self selector: @selector(createTextField)],
                       nil]
     ];
    
    [chick runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 1],
                                [CCFadeTo actionWithDuration: 0.5 opacity: 0],
                       nil]
     ];
    
    [enterNameLabel runAction:
                            [CCSequence actions:
                                            [CCDelayTime actionWithDuration: 1.5],
                                            [CCMoveTo actionWithDuration: 0.3 position: ccp(GameCenterX, GameCenterY * 1.5)],
                                            
                             nil]
     ];
    
    
}

- (void) createTextField
{
    nameField = [[UITextField alloc] initWithFrame: rectForTextField];
    [nameField setText: @"Name"];
    nameField.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: textFontSize];
    [nameField setTextColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1.0]];
    nameField.backgroundColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 0.5];
    nameField.textAlignment = UITextAlignmentCenter;
    [nameField setDelegate: self];
    nameField.transform = CGAffineTransformMakeRotation(M_PI / -2.0);
    [[[[CCDirector sharedDirector] openGLView] window] addSubview: nameField];
    
    [nameField becomeFirstResponder];
    [nameField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn: (UITextField*) textField
{
    [nameField resignFirstResponder];
    
    if([nameField.text isEqualToString: @""] || [nameField.text isEqualToString: @"Enter your name!"])
    {
        nameField.text = @"Enter your name!";
        
        okBtn.isEnabled = NO;
        okBtn.visible = NO;
    }
    else
    {
        okBtn.isEnabled = YES;
        okBtn.visible = YES;
    }
    
    return YES;
}

- (void) pressedOkBtn
{
    [Settings sharedSettings].nameOfPlayer = nameField.text;
    [Settings sharedSettings].isFirstRun = NO;
    [[Settings sharedSettings] save];
    
    [nameField removeFromSuperview];
    [nameField release];
    
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"MainMenu%@.ccb", suffix]];
    
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

@end
