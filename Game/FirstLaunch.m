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
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName: @"mainMenuBg.png"];
        bg.position = ccp(size.width/2, size.height / 2);
        [self addChild: bg];
        
        CCMenu *eggMenu = [CCMenu menuWithItems: nil];
        eggMenu.position = ccp(0, 0);
        [self addChild: eggMenu z:1 tag: 1];
        
        CCMenuItemImage *egg = [CCMenuItemImage itemFromNormalImage: @"egg1.png" selectedImage: @"egg1.png" target: self selector: @selector(tapEgg)];
        egg.position = ccp(240, 160);
        
        [eggMenu addChild: egg];
        
        okBtn = [CCMenuItemImage itemFromNormalImage: @"okBtn.png" selectedImage: @"okBtnOn.png" target: self selector: @selector(pressedOkBtn)];
        okBtn.position = ccp(240, 70);
        
        okBtn.isEnabled = NO;
        okBtn.visible = NO;
        
        CCMenu *menu = [CCMenu menuWithItems: okBtn, nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
        
        //[self createTextField];
        
        
        
    }
    
    return self;
}

- (void) tapEgg
{
    [self removeChildByTag: 1 cleanup: YES];
    
    CCMenuItemImage *egg2 = [CCMenuItemImage itemFromNormalImage: @"egg2.png" selectedImage: @"egg2.png" target: self selector: @selector(brakeEgg)];
    egg2.position = ccp(240, 160);
    
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
    
    CCLabelBMFont *enterNameLabel = [CCLabelBMFont labelWithString: @"Enter your name:" fntFile: @"timeFont.fnt"];
    enterNameLabel.position = ccp(240, 340);
    [self addChild: enterNameLabel];
    
    CCSprite *chick = [CCSprite spriteWithFile: @"chick.png"];
    chick.position = ccp(240, 160);
    chick.scale = 0.5;
    [self addChild: chick];
    
    CCSprite *leftEgg = [CCSprite spriteWithFile: @"egg_3_left.png"];
    leftEgg.position = ccp(240, 160);
    
    CCSprite *rightEgg = [CCSprite spriteWithFile: @"egg_3_right.png"];
    rightEgg.position = ccp(240, 160);
    
    [self addChild: leftEgg];
    [self addChild: rightEgg];
    
    [leftEgg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(-70, leftEgg.position.y)]];
    [rightEgg runAction: [CCMoveTo actionWithDuration: 0.5 position: ccp(550, rightEgg.position.y)]];
    
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
                                            [CCMoveTo actionWithDuration: 0.3 position: ccp(240, 270)],
                                            
                             nil]
     ];
    
    
}

- (void) createTextField
{
    nameField = [[UITextField alloc] initWithFrame: CGRectMake(-20, 220, 240, 40)];
    [nameField setText: @"Name"];
    nameField.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 30];
    [nameField setTextColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1.0]];
    nameField.backgroundColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 0.5];
    nameField.textAlignment = UITextAlignmentCenter;
    [nameField setDelegate: self];
    nameField.transform = CGAffineTransformMakeRotation(M_PI / -2.0);
    [[[[CCDirector sharedDirector] openGLView] window] addSubview: nameField];
    
    //[nameField canBecomeFirstResponder];
    //[nameField canResignFirstResponder];
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
