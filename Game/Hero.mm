

#import "GameLayer.h"
#import "Hero.h"
#import "HeroContactListener.h"
#import "Box2D.h"
#import "Settings.h"

#import "GameConfig.h"

#import "Common.h"

@interface Hero()
- (void) createBox2DBody;
@end

@implementation Hero

@synthesize game = _game;
@synthesize sprite = _sprite;
@synthesize awake = _awake;
@synthesize diving = _diving;

+ (id) heroWithGame:(GameLayer*)game {
	return [[[self alloc] initWithGame:game] autorelease];
}

- (id) initWithGame:(GameLayer*)game {
	
	if ((self = [super init])) {

		self.game = game;
		
#ifndef DRAW_BOX2D_WORLD
        
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicks%@.plist", suffix]];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSString stringWithFormat: @"chicksAnim%@.plist", suffix]];
        
        [Common loadAnimationWithPlist: @"chicksAnimation"
                               andName: [NSString stringWithFormat: @"c%ianim", [Settings sharedSettings].currentPinguin]
         ];
        
		self.sprite = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"c%ianim1.png", [Settings sharedSettings].currentPinguin]];
        //self.sprite.scale = 0.5;
		[self addChild:_sprite];
        
        
#endif
		_body = NULL;
		_radius = bodyRadius;

		_contactListener = new HeroContactListener(self);
		_game.world->SetContactListener(_contactListener);

		[self reset];
	}
	return self;
}

- (void) dealloc {

	self.game = nil;
	
#ifndef DRAW_BOX2D_WORLD
	self.sprite = nil;
#endif

	delete _contactListener;
	[super dealloc];
}

- (void) createBox2DBody {

	CGPoint startPosition = ccp(0, _game.screenH/2+_radius);
    
	b2BodyDef bd;
	bd.type = b2_dynamicBody;
	bd.linearDamping = 0.05f;
	bd.fixedRotation = true;
	bd.position.Set(startPosition.x/PTM_RATIO, startPosition.y/PTM_RATIO);
	_body = _game.world->CreateBody(&bd);
	
	b2CircleShape shape;
	shape.m_radius = _radius/PTM_RATIO;
	
	b2FixtureDef fd;
	fd.shape = &shape;
	fd.density = 1.0f;
	fd.restitution = 0; // bounce
	fd.friction = 0;
	
	_body->CreateFixture(&fd);
}

- (void) reset {
    _awake = NO;
	_flying = NO;
	_diving = NO;
	_nPerfectSlides = 0;
	if (_body) {
		_game.world->DestroyBody(_body);
	}
	[self createBox2DBody];
	[self updateNode];
	[self sleep];
    
}

- (void) sleep {
	_awake = NO;
	_body->SetActive(false);
}

- (void) wake {
	_awake = YES;
	_body->SetActive(true);
	_body->ApplyLinearImpulse(b2Vec2(1,2), _body->GetPosition());
    [_game startCat];
    
    [_sprite runAction:
                [CCRepeatForever actionWithAction:
                    [CCAnimate actionWithAnimation:
                        [[CCAnimationCache sharedAnimationCache] animationByName: [NSString stringWithFormat: @"c%ianim", [Settings sharedSettings].currentPinguin]]
                     ]
                 ]
     ];
    
}

- (void) stopBird
{
    if(_body -> GetLinearVelocity().x > 0)
    {
        _body->ApplyForce(b2Vec2(-40, forceY),_body->GetPosition());
    }
}

- (void) applyBonus
{
    _body->ApplyLinearImpulse(b2Vec2(12 * coefForCoords,0),_body->GetPosition());
}

- (void) applyRocket
{
    _body->ApplyLinearImpulse(b2Vec2(8 * coefForCoords, 5 * coefForCoords),_body->GetPosition());
}

- (void) applyEnergy
{
    _body->ApplyLinearImpulse(b2Vec2(7,0),_body->GetPosition());
}

- (void) pauseChickAnimation
{
    [_sprite pauseSchedulerAndActions];
}

- (void) stopChickAnimation
{
    [_sprite stopAllActions];
}

- (void) resumeChickAnimation
{
    [_sprite resumeSchedulerAndActions];
}

- (void) updatePhysics {

	// apply force if diving
	if (_diving)
    {
		if (!_awake)
        {
			[self wake];
			_diving = NO;
		}
        else
        {
			_body->ApplyForce(b2Vec2(0, forceY),_body->GetPosition());
            
		}
	}
    
    if(self.position.y > currentHeightOfFly * coefForCoords)
    {
        _body->ApplyForce(b2Vec2(0, forceY/2 ),_body->GetPosition());
    }
    
	// limit velocity
	const float minVelocityX = minSpeedX;
	const float minVelocityY = minSpeedY;
	b2Vec2 vel = _body->GetLinearVelocity();
	
    if(!isFinish)
    {
        if (vel.x < minVelocityX)
        {
            vel.x = minVelocityX;
        }
        
        if (vel.y < minVelocityY)
        {
            vel.y = minVelocityY;
        }
        
        if(vel.x > currentSpeedOfFly)
        {
            vel.x = currentSpeedOfFly;
        }
        
        _body->SetLinearVelocity(vel);
    }
    else
    {
        if(_body -> GetLinearVelocity().x > 1)
        {
            _body->ApplyForce(b2Vec2(-25 * coefForCoords, forceY),_body->GetPosition());
        }
        else
        {
            if(_body -> GetLinearVelocity().y == 0)
            {
                _body -> SetLinearVelocity(b2Vec2(0.2, _body -> GetLinearVelocity().y));
                [self sleep];
            }
        }
        
    }	
}

- (void) updateNode {
	float x = _body->GetPosition().x * PTM_RATIO;
	float y = _body->GetPosition().y * PTM_RATIO;

	// CCNode position and rotation
	self.position = ccp(x, y);
	b2Vec2 vel = _body->GetLinearVelocity();
	float angle = atan2f(vel.y, vel.x);

#ifdef DRAW_BOX2D_WORLD
	body->SetTransform(body->GetPosition(), angle);
#else
	self.rotation = -1 * CC_RADIANS_TO_DEGREES(angle);
#endif
	
	// collision detection
	b2Contact *c = _game.world->GetContactList();
	if (c) {
		if (_flying) {
			[self landed];
		}
	} else {
		if (!_flying) {
			[self tookOff];
		}
	}
	
	// TEMP: sleep if below the screen
	if (y < -_radius && _awake) {
		[self sleep];
	}
}

- (void) landed {
//	NSLog(@"landed");
	_flying = NO;
}

- (void) tookOff {
//	NSLog(@"tookOff");
	_flying = YES;
	b2Vec2 vel = _body->GetLinearVelocity();
//	NSLog(@"vel.y = %f",vel.y);
	if (vel.y > kPerfectTakeOffVelocityY) {
//		NSLog(@"perfect slide");
		_nPerfectSlides++;
		if (_nPerfectSlides > 1) {
			if (_nPerfectSlides == 4) {
				[_game showFrenzy];
			} else {
				[_game showPerfectSlide];
			}
		}
	}
}

- (void) hit {
//	NSLog(@"hit");
	_nPerfectSlides = 0;
	[_game showHit];
}

- (void) setDiving:(BOOL)diving {
	if (_diving != diving) {
		_diving = diving;
		// TODO: change sprite image here
	}
}

@end
