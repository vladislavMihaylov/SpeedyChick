

#import "cocos2d.h"
#import "Box2D.h"

#define kMaxHillKeyPoints 60    //50
#define kMaxHillVertices 1000    //2000
#define kMaxBorderVertices 5000  //10000
#define kHillSegmentWidth 15

@class GameLayer;

@interface Terrain : CCNode
{
	CGPoint hillKeyPoints[kMaxHillKeyPoints];
	int nHillKeyPoints;
	int fromKeyPointI;
	int toKeyPointI;
	CGPoint hillVertices[kMaxHillVertices];
	CGPoint hillTexCoords[kMaxHillVertices];
	int nHillVertices;
	CGPoint borderVertices[kMaxBorderVertices];
	int nBorderVertices;
	CCSprite *_stripes;
	float _offsetX;
	b2World *world;
	b2Body *body;
	int screenW;
	int screenH;
	int textureSize;
    
    NSInteger finishPoint;
    
    NSMutableArray *bonusesArray;
    NSArray *pointsArray;
    
    BOOL firstTime;
}

@property (nonatomic, retain) CCSprite *stripes;
@property (nonatomic, assign) float offsetX;

@property (nonatomic, assign) NSInteger finishPoint;

+ (id) terrainWithWorld:(b2World*)w;
- (id) initWithWorld:(b2World*)w;
- (void) removeBody;

- (BOOL) checkBonusCollisionWithCoordinats: (CGPoint) heroPosition;
- (void) reset;
- (void) resetHillVertices;

@end
