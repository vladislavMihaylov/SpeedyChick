

#import "GameLayer.h"
#import "Sky.h"
#import "Terrain.h"
#import "Hero.h"
#import "Settings.h"

#import "Configuration.h"

#import "CCBReader.h"

#import "GameConfig.h"

#import "SimpleAudioEngine.h"

@interface GameLayer()
- (void) createBox2DWorld;
- (void) reset;
@end

@implementation GameLayer

@synthesize screenW = _screenW;
@synthesize screenH = _screenH;
@synthesize world = _world;
@synthesize sky = _sky;
@synthesize terrain = _terrain;
@synthesize hero = _hero;
@synthesize resetButton = _resetButton;

@synthesize guiLayer;

+ (CCScene*) scene {
	CCScene *scene = [CCScene node];
	//[scene addChild:[GameLayer node]];
    
    GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer];
    
    GuiLayer *gui = [GuiLayer node];
    [scene addChild: gui];
    
    layer.guiLayer = gui;
    gui.gameLayer = layer;
    
	return scene;
}

- (id) init {
	
	if ((self = [super init]))
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"SpeedyChick_BackgroundTheme.mp3" loop: YES];
        
        isPauseOfGame = NO;
        isUserPlayed = YES;
        //[[Configuration sharedConfiguration] setConfig];
        
        CCSprite *bgSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"bg_0%i%@.png", currentWorld, suffix]];
        
        bgSprite.position = ccp(GameCenterX, GameCenterY);
        [self addChild: bgSprite];
        
        //CCLOG(@"W: %i ",[Settings sharedSettings].openedLevels);
        
        isGameActive = YES;
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		_screenW = screenSize.width;
		_screenH = screenSize.height;

		[self createBox2DWorld];

#ifndef DRAW_BOX2D_WORLD

		//self.sky = [Sky skyWithTextureSize: 1024];
		//[self addChild:_sky];
		
#endif

		self.terrain = [Terrain terrainWithWorld: _world];
		[self addChild: _terrain];
        
		self.hero = [Hero heroWithGame:self];
		[_terrain addChild:_hero];
        
        [_hero reset]; // <--

		//self.resetButton = [CCSprite spriteWithFile:@"reset.png"];
		//[self addChild:_resetButton];
		//CGSize size = _resetButton.contentSize;
		//float padding = 8;
		//_resetButton.position = ccp(_screenW-size.width/2-padding, _screenH-size.height/2-padding);
		
		self.isTouchEnabled = YES;
        
        
        [self scheduleUpdate];
        //CCLOG(@"TerrainRC: %i", [self.terrain retainCount]);
        [_terrain resetHillVertices];
        
        [self schedule: @selector(chirikchirik) interval: 25];
        
	}
	return self;
}

- (void) chirikchirik
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_ChickenCheep.wav"];
}

- (void) exitToWorldsMenu
{
    self.hero = nil;
}

- (void) exitToMainMenu
{
    //[self unscheduleUpdate];
    [_hero reset];
    [_terrain reset];
    
    CCScene * scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"MainMenu%@.ccb", suffix]];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) exitToCustomization
{
    [_hero reset];
    [_terrain reset];
    
    CCScene * scene = [CCBReader sceneWithNodeGraphFromFile: [NSString stringWithFormat: @"CustomizeMenu%@.ccb", suffix]];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
}

- (void) setVisibleOfChick: (BOOL) vis
{
    _hero.visible = vis;
}

- (void) applyRocket
{
    [_hero applyRocket];
}

- (void) dealloc
{
	self.sky = nil;
	self.terrain = nil;
	self.hero = nil;
	self.resetButton = nil;
    
#ifdef DRAW_BOX2D_WORLD

	delete _render;
	_render = NULL;
	
#endif
	
	delete _world;
	_world = NULL;
	
	[super dealloc];
}

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (void) nextLevel
{
    [_terrain removeBody];
    
    [self removeChild: _terrain cleanup: YES];
    self.terrain = nil;
    
    self.terrain = [Terrain terrainWithWorld: _world];
    [self addChild: _terrain];
    
    self.hero = [Hero heroWithGame:self];
    [_terrain addChild:_hero];
    
    _terrain.offsetX = 0;
    isGameActive = YES;
}

- (void) reset {
    
    [_terrain reset];
    [_hero reset];
    
    _terrain.offsetX = 0;
    isGameActive = YES;
    
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
    iCanDoSwipe = YES;
    
    beginTouchPoint = location;
    
    _hero.diving = YES;
    
    [_hero increaseChickAnimation];
    /*if(ChickOnTheStart)
    {
        [guiLayer start];
    }*/
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([Settings sharedSettings].isGhostChickBuyed)
    {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if(iCanDoSwipe)
        {
            float difference = location.x - beginTouchPoint.x;
            
            if(difference > 50)
            {
                if(guiLayer.energy >= 2)
                {
                    [guiLayer decreaseEnergy];
                    iCanDoSwipe = NO;
                    //CCLOG(@"SWIPE");
                    
                    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_Coins.wav"];
                    
                    [_hero applyEnergy];
                }
            }
        }
    }
}



- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	_hero.diving = NO;
    
    [_hero resumeChickAnimation];
    
    iCanDoSwipe = YES;
}

- (void) startCat
{
    [guiLayer start];
}

- (void) update: (ccTime) dt
{
    //CCLOG(@"HERO POSITION: %f %f", _hero.position.x, _hero.position.y);
    
    //CCLOG(@"Awake: %i diving: %i ", _hero.awake, _hero.diving);
    
    BOOL isBonus = [_terrain checkBonusCollisionWithCoordinats: ccp(_hero.position.x, _hero.position.y)];
    
    if(isBonus)
    {
        [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_CollectRocket.wav"];
        
        CCLOG(@"BONUS!");
        //[_hero applyBonus];
        [Settings sharedSettings].countOfRockets++;
        [[Settings sharedSettings] save];
        [guiLayer updateRocket];
    }
    
    BOOL isCoin = [_terrain checkCoinCollisionWithCoordinats: ccp(_hero.position.x, _hero.position.y)];
    
    if(isCoin)
    {
        [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_Coins.wav"];
        
        [Settings sharedSettings].countOfCoins += 1;
        [[Settings sharedSettings] save];
    } 
    
    [guiLayer moveCocoOffsetX: _terrain.offsetX andFinishPoint: _terrain.finishPoint];
    
    if(!isPauseOfGame)
    {
        [_hero updatePhysics];
        int32 velocityIterations = 8;
        int32 positionIterations = 3;
        _world->Step(dt, velocityIterations, positionIterations);
        [_hero updateNode];
    }
    
    if(isGameActive)
    {
        if(_terrain.offsetX > _terrain.finishPoint)
        {
            //isGameActive = NO;
            [guiLayer finish];
            _hero.diving = NO;
            [_hero stopChickAnimation];
        }
        

        // terrain scale and offset
        float height = _hero.position.y;
        const float minHeight = _screenH*4/5;
        if (height < minHeight) {
            height = minHeight;
        }
        float scale = minHeight / height;
        _terrain.scale = scale;
        _terrain.offsetX = _hero.position.x;

    #ifndef DRAW_BOX2D_WORLD
        [_sky setOffsetX:_terrain.offsetX*0.2f];
        [_sky setScale:1.0f-(1.0f-scale)*0.75f];
    #endif
    }
}

- (void) createBox2DWorld {
	
	b2Vec2 gravity;
	///gravity.Set(0.0f, gravity);
    gravity.Set(0.0, gravityY);
	
	_world = new b2World(gravity, false);

#ifdef DRAW_BOX2D_WORLD
	
	_render = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(_render);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
//	flags += b2Draw::e_jointBit;
//	flags += b2Draw::e_aabbBit;
//	flags += b2Draw::e_pairBit;
//	flags += b2Draw::e_centerOfMassBit;
	_render->SetFlags(flags);
	
#endif
}

- (void) showPerfectSlide {
    
    if([Settings sharedSettings].isGhostChickBuyed)
    {
        [guiLayer increaseEnergy];
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_Landing.wav"];
    
	//NSString *str = @"perfect slide";
    NSString *str = @"";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showFrenzy {
    
    if([Settings sharedSettings].isGhostChickBuyed)
    {
        //[guiLayer increaseEnergy];
        [_hero applyEnergy];
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_Landing.wav"];
    
	//NSString *str = @"FRENZY!";
    NSString *str = @"";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:2.0f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:2.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showHit {
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"SpeedyChick_Landing.wav"];
    
	//NSString *str = @"hit";
    NSString *str = @"";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", suffix]];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

@end
