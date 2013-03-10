

#import "GameLayer.h"
#import "Sky.h"
#import "Terrain.h"
#import "Hero.h"
#import "Settings.h"


#import "CCBReader.h"

#import "GameConfig.h"

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

+ (CCScene*) scene {
	CCScene *scene = [CCScene node];
	[scene addChild:[GameLayer node]];
	return scene;
}

- (id) init {
	
	if ((self = [super init]))
    {
        isGameActive = YES;
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		_screenW = screenSize.width;
		_screenH = screenSize.height;

		[self createBox2DWorld];

#ifndef DRAW_BOX2D_WORLD

		self.sky = [Sky skyWithTextureSize: 1024];
		[self addChild:_sky];
		
#endif

		self.terrain = [Terrain terrainWithWorld: _world];
		[self addChild: _terrain];
		
		self.hero = [Hero heroWithGame:self];
		[_terrain addChild:_hero];

		self.resetButton = [CCSprite spriteWithFile:@"reset.png"];
		[self addChild:_resetButton];
		CGSize size = _resetButton.contentSize;
		float padding = 8;
		_resetButton.position = ccp(_screenW-size.width/2-padding, _screenH-size.height/2-padding);
		
		self.isTouchEnabled = YES;
        
        applyRocket = [CCMenuItemImage itemFromNormalImage: @"rocket.png" selectedImage: @"rocket.png" target: self selector: @selector(applyRocket)];
        applyRocket.position = ccp(screenSize.width - 100, screenSize.height - 50);
        
        CCMenuItemImage *exitBtn = [CCMenuItemImage itemFromNormalImage: @"exit.png" selectedImage: @"exit.png" target: self selector: @selector(exitToMainMenu)];
        exitBtn.position = ccp(screenSize.width - 30, screenSize.height - 80);
        
        CCMenu *ROCKET = [CCMenu menuWithItems: applyRocket, exitBtn, nil];
        ROCKET.position = ccp(0, 0);
        [self addChild: ROCKET z: 10];
        
        [self updateRocket];
        
        [self scheduleUpdate];
        
        //[_terrain resetHillVertices];
        
	}
	return self;
}

- (void) exitToMainMenu
{
    [self unscheduleUpdate];
    
    CCScene * scene = [CCBReader sceneWithNodeGraphFromFile: @"MainMenu.ccb"];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.5 scene: scene]];
    
}

- (void) applyRocket
{
    if([Settings sharedSettings].countOfRockets > 0)
    {
        [_hero applyRocket];
        [Settings sharedSettings].countOfRockets--;
        [[Settings sharedSettings] save];
        
        [self updateRocket];
    }
}

- (void) updateRocket
{
    if([Settings sharedSettings].countOfRockets <= 0)
    {
        applyRocket.isEnabled = NO;
        applyRocket.visible = NO;
    }
}

- (void) dealloc {
	
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

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) reset {
    
    [_terrain reset];
    [_hero reset];
    
    _terrain.offsetX = 0;
    isGameActive = YES;
    
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	CGPoint pos = _resetButton.position;
	CGSize size = _resetButton.contentSize;
	float padding = 8;
	float w = size.width+padding*2;
	float h = size.height+padding*2;
	CGRect rect = CGRectMake(pos.x-w/2, pos.y-h/2, w, h);
	if (CGRectContainsPoint(rect, location)) {
		[self reset];
	} else {
		_hero.diving = YES;
	}
	
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	_hero.diving = NO;
}

- (void) update: (ccTime) dt
{
    //CCLOG(@"HERO POSITION: %f %f", _hero.position.x, _hero.position.y);
    
    BOOL isBonus = [_terrain checkBonusCollisionWithCoordinats: ccp(_hero.position.x, _hero.position.y)];
    
    if(isBonus)
    {
        CCLOG(@"BONUS!");
        [_hero applyBonus];
    }
    
    if(isGameActive)
    {
        if(_terrain.offsetX > _terrain.finishPoint)
        {
            isGameActive = NO;
            
            CCLOG(@"FINISH!!!!");
        }
        
        [_hero updatePhysics];
        
        int32 velocityIterations = 8;
        int32 positionIterations = 3;
        _world->Step(dt, velocityIterations, positionIterations);
    //	_world->ClearForces();
        
        [_hero updateNode];

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
	gravity.Set(0.0f, -10.8f);
	
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
	NSString *str = @"perfect slide";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:@"good_dog_plain_32.fnt"];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showFrenzy {
	NSString *str = @"FRENZY!";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:@"good_dog_plain_32.fnt"];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:2.0f scale:1.4f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:2.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

- (void) showHit {
	NSString *str = @"hit";
	CCLabelBMFont *label = [CCLabelBMFont labelWithString:str fntFile:@"good_dog_plain_32.fnt"];
	label.position = ccp(_screenW/2, _screenH/16);
	[label runAction:[CCScaleTo actionWithDuration:1.0f scale:1.2f]];
	[label runAction:[CCSequence actions:
					  [CCFadeOut actionWithDuration:1.0f],
					  [CCCallFuncND actionWithTarget:label selector:@selector(removeFromParentAndCleanup:) data:(void*)YES],
					  nil]];
	[self addChild:label];
}

@end
