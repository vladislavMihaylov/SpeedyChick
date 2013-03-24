

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "GuiLayer.h"

@class Sky;
@class Terrain;
@class Hero;

@interface GameLayer : CCLayer
{
    GuiLayer *gui;
    
	int _screenW;
	int _screenH;
	b2World *_world;
	Sky *_sky;
	Terrain *_terrain;
	Hero *_hero;
	GLESDebugDraw *_render;
	CCSprite *_resetButton;
    
    CGPoint beginTouchPoint;
    
    BOOL iCanDoSwipe;
    
}
@property (readonly) int screenW;
@property (readonly) int screenH;
@property (nonatomic, readonly) b2World *world;
@property (nonatomic, retain) Sky *sky;
@property (nonatomic, retain) Terrain *terrain;
@property (nonatomic, retain) Hero *hero;
@property (nonatomic, retain) CCSprite *resetButton;

@property (nonatomic, assign) GuiLayer *guiLayer;

+ (CCScene*) scene;

- (void) applyRocket;
- (void) reset;
- (void) nextLevel;
- (void) showPerfectSlide;
- (void) showFrenzy;
- (void) showHit;
- (void) exitToMainMenu;
- (void) startCat;

@end

