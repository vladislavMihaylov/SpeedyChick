

#import "Terrain.h"

#import "Bonus.h"

#import "WorldsDatabase.h"
#import "WorldsInfo.h"

#import "GameConfig.h"

@interface Terrain()
- (CCSprite*) generateStripesSprite;
- (CCTexture2D*) generateStripesTexture;
- (void) renderStripes;
- (void) renderGradient;
- (void) renderHighlight;
- (void) renderTopBorder;
- (void) renderNoise;
- (void) generateHillKeyPoints;
- (void) generateBorderVertices;
- (void) createBox2DBody;
- (void) resetHillVertices;
- (ccColor4F) randomColor;
@end

@implementation Terrain

@synthesize stripes = _stripes;
@synthesize offsetX = _offsetX;


@synthesize finishPoint;

+ (id) terrainWithWorld:(b2World*)w {
	return [[[self alloc] initWithWorld:w] autorelease];
}

- (id) initWithWorld:(b2World*)w {
	
	if ((self = [super init])) {
        
        
        
        firstTime = YES;
        
        [self reset];
		
        bonusesArray = [[NSMutableArray alloc] init];
        pointsArray = [[NSArray alloc] init];
        
		world = w;

		//CGSize size = [[CCDirector sharedDirector] winSize];
		screenW = 480;//size.width;
		screenH = 320;//size.height;
        
        NSString *number =[NSString stringWithFormat: @"%i%i", currentWorld, currentLevel];
        
        NSInteger num = [number integerValue];
        
        
        
        NSArray *worldsInfo = [[WorldsDatabase database] worldsInfosWithID: num];
        
        NSString *points;
        
        for(WorldsInfo *info in worldsInfo)
        {
            points = info.points;
            //CCLOG(@"INFO: %i, %@, %@, %@", info.uniqueID, info.points, info.bonusPoints, info.times);
        }
        
        pointsArray = [points componentsSeparatedByString: @"/"];
        
        //[worldsInfo release];
        
        //CCLOG(@"INFO: %@", pointsArray);
		
#ifndef DRAW_BOX2D_WORLD
		textureSize = 1024;
		self.stripes = [self generateStripesSprite];
#endif
		
		[self generateHillKeyPoints];
		[self generateBorderVertices];
		[self createBox2DBody];

		self.offsetX = 0;
        
        
        //[self setPosition: ccp(60, self.position.y)];
	}
	return self;
}

- (void) dealloc {

#ifndef DRAW_BOX2D_WORLD
	
	self.stripes = nil;
	
#endif

    //[pointsArray release];
    [bonusesArray release];
    
	[super dealloc];
}

- (CCSprite*) generateStripesSprite {
	//CCTexture2D *texture = [self generateStripesTexture];
	CCSprite *sprite = [CCSprite spriteWithFile: @"Noise.png"];//[CCSprite spriteWithTexture: texture]
	ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
	[sprite.texture setTexParameters:&tp];
	
	return sprite;
}

- (CCTexture2D*) generateStripesTexture {
	
	CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth: textureSize height: textureSize];
	[rt begin];
	[self renderStripes];
	[self renderGradient];
	[self renderHighlight];
	[self renderTopBorder];
	[self renderNoise];
	[rt end];
	
	return rt.sprite.texture;
}

- (void) renderStripes {
	
	const int minStripes = 3;
	const int maxStripes = 4;
	
	// random even number of stripes
	int nStripes = arc4random()%(maxStripes-minStripes)+minStripes;
	if (nStripes%2) {
		nStripes++;
	}
//	NSLog(@"nStripes = %d", nStripes);
	
	CGPoint *vertices = (CGPoint*)malloc(sizeof(CGPoint)*nStripes*6);
	ccColor4F *colors = (ccColor4F*)malloc(sizeof(ccColor4F)*nStripes*6);
	int nVertices = 0;
	
	float x1, x2, y1, y2, dx, dy;
	ccColor4F c;
	
	
     if (arc4random()%2) {
		
		// diagonal stripes
		
		dx = (float)textureSize*2 / (float)nStripes;
		dy = 0;
		
		x1 = -textureSize;
		y1 = 0;
		
		x2 = 0;
		y2 = textureSize;
		
		for (int i=0; i<nStripes/2; i++) {
			c = [self randomColor];
			for (int j=0; j<2; j++) {
				for (int k=0; k<6; k++) {
					colors[nVertices+k] = c;
				}
				vertices[nVertices++] = ccpMult(ccp(x1+j*textureSize, y1), CC_CONTENT_SCALE_FACTOR()) ;
				vertices[nVertices++] = ccpMult(ccp(x1+j*textureSize+dx, y1), CC_CONTENT_SCALE_FACTOR()) ;
				vertices[nVertices++] = ccpMult(ccp(x2+j*textureSize, y2), CC_CONTENT_SCALE_FACTOR()) ;
				vertices[nVertices++] = ccpMult(vertices[nVertices-2], CC_CONTENT_SCALE_FACTOR()) ;
				vertices[nVertices++] = ccpMult(vertices[nVertices-2], CC_CONTENT_SCALE_FACTOR()) ;
				vertices[nVertices++] = ccpMult(ccp(x2+j*textureSize+dx, y2), CC_CONTENT_SCALE_FACTOR()) ;
			}
			x1 += dx;
			x2 += dx;
		}
		
	} else {
		
		// horizontal stripes
		
		dx = 0;
		dy = (float)textureSize / (float)nStripes;
		
		x1 = 0;
		y1 = 0;
		
		x2 = textureSize;
		y2 = 0;
		
		for (int i=0; i<nStripes; i++) {
			c = [self randomColor];
			for (int k=0; k<6; k++) {
				colors[nVertices+k] = c;
			}
			vertices[nVertices++] = ccpMult(ccp(x1, y1), CC_CONTENT_SCALE_FACTOR()) ;
			vertices[nVertices++] = ccpMult(ccp(x2, y2), CC_CONTENT_SCALE_FACTOR()) ;
			vertices[nVertices++] = ccpMult(ccp(x1, y1+dy), CC_CONTENT_SCALE_FACTOR()) ;
			vertices[nVertices++] = ccpMult(vertices[nVertices-2], CC_CONTENT_SCALE_FACTOR()) ;
			vertices[nVertices++] = ccpMult(vertices[nVertices-2], CC_CONTENT_SCALE_FACTOR()) ;
			vertices[nVertices++] = ccpMult(ccp(x2, y2+dy), CC_CONTENT_SCALE_FACTOR()) ;
			y1 += dy;
			y2 += dy;
		}
		
	}
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glColor4f(1, 1, 1, 1);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);
	
	free(vertices);
	free(colors);
}

- (void) renderGradient {
	
	float gradientAlpha = 0.9f;
	float gradientWidth = textureSize;
	
	CGPoint vertices[6];
	ccColor4F colors[6];
	int nVertices = 0;
	
	vertices[nVertices] = ccpMult(ccp(0, 0), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
	vertices[nVertices] = ccpMult(ccp(textureSize, 0), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
	
	vertices[nVertices] = ccpMult(ccp(0, gradientWidth), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
	vertices[nVertices] = ccpMult(ccp(textureSize, gradientWidth), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
	
	if (gradientWidth < textureSize) {
		vertices[nVertices] = ccpMult(ccp(0, textureSize), CC_CONTENT_SCALE_FACTOR()) ;
		colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
		vertices[nVertices] = ccpMult(ccp(textureSize, textureSize), CC_CONTENT_SCALE_FACTOR()) ;
		colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
}

- (void) renderHighlight {
	
	float highlightAlpha = 0.9f;
	float highlightWidth = textureSize/4;
	
	CGPoint vertices[4];
	ccColor4F colors[4];
	int nVertices = 0;
	
	vertices[nVertices] = ccpMult(ccp(0, 0), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){1, 1, 0.5f, highlightAlpha}; // yellow
	vertices[nVertices] = ccpMult(ccp(textureSize, 0), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){1, 1, 0.5f, highlightAlpha};
	
	vertices[nVertices] = ccpMult(ccp(0, highlightWidth), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
	vertices[nVertices] = ccpMult(ccp(textureSize, highlightWidth), CC_CONTENT_SCALE_FACTOR()) ;
	colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glColorPointer(4, GL_FLOAT, 0, colors);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
}

- (void) renderTopBorder {
	
	float borderAlpha = 0.5f;
	float borderWidth = 4.0f;
	
	CGPoint vertices[2];
	int nVertices = 0;
	
	vertices[nVertices++] = ccpMult(ccp(0, borderWidth/2), CC_CONTENT_SCALE_FACTOR()) ;
	vertices[nVertices++] = ccpMult(ccp(textureSize, borderWidth/2), CC_CONTENT_SCALE_FACTOR()) ;
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glLineWidth(borderWidth);
	glColor4f(0, 0, 0, borderAlpha);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDrawArrays(GL_LINE_STRIP, 0, (GLsizei)nVertices);
}

- (void) renderNoise {
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	CCSprite *s = [CCSprite spriteWithFile:@"Noise2.png"];
	[s setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
	s.position = ccp(textureSize/2, textureSize/2);
	s.scale = (float)textureSize/512.0f;
	glColor4f(1, 1, 1, 1);
	[s visit];
	[s visit]; // more contrast
}

- (void) generateHillKeyPoints
{

    nHillKeyPoints = 0;
    
    for(NSString *node in pointsArray)
    {
        NSArray *curPoints = [node componentsSeparatedByString: @","];
        
        CGPoint curPoint = CGPointMake([[curPoints objectAtIndex: 0] floatValue], [[curPoints objectAtIndex: 1] floatValue]);
        //CCLOG(@"Current Point: %f %f", curPoint.x, curPoint.y);
        
        hillKeyPoints[nHillKeyPoints++] = curPoint;
        
        finishPoint = curPoint.x;
    }
    
	fromKeyPointI = 0;
	toKeyPointI = 0;
	
	/*float x, y, dx, dy, ny;
	
	x = -120;// -screenW/4;
	y = 240;//screenH*3/4;
	hillKeyPoints[nHillKeyPoints++] = ccp(x, y);

	// starting point
	x = 0;
	y = 160;//screenH/2;
	hillKeyPoints[nHillKeyPoints++] = ccp(x, y);
	
	int minDX = 160, rangeDX = 80;
	int minDY = 60,  rangeDY = 60;
	float sign = -1; // +1 - going up, -1 - going  down
	float maxHeight = 320;//screenH;
	float minHeight = 20;
	while (nHillKeyPoints < kMaxHillKeyPoints-2) {
		dx = arc4random()%rangeDX+minDX;
		x += dx;
		dy = arc4random()%rangeDY+minDY;
		ny = y + dy*sign;
		if(ny > maxHeight) ny = maxHeight;
		if(ny < minHeight) ny = minHeight;
		y = ny;
		sign *= -1;
		hillKeyPoints[nHillKeyPoints++] = ccp(x, y);
        
        NSInteger randNum = arc4random() % 5 + 1;
        
        if(sign == 1 && randNum == 2)
        {
            Bonus *bonus = [[[Bonus alloc] init] autorelease];
            bonus.position = ccp(x, y + bonus.contentSize.height/2);
            bonus.scale = 0.8;
            
            [bonusesArray addObject: bonus];
            
            [self addChild: bonus];
        }
	}

	// cliff
	x += minDX+rangeDX;
	y = 10;
	hillKeyPoints[nHillKeyPoints++] = ccp(x, y);
    
    finishPoint = x;
    
    x += 1000;//minDX+rangeDX;
	y = 10;
	hillKeyPoints[nHillKeyPoints++] = ccp(x, y);
	
	fromKeyPointI = 0;
	toKeyPointI = 0;*/
}

- (BOOL) checkBonusCollisionWithCoordinats: (CGPoint) heroPosition
{
    BOOL isCollision = NO;
    
    for(Bonus *curBonus in bonusesArray)
    {
        if((fabsf(heroPosition.x - curBonus.position.x) < curBonus.contentSize.width/2) && (fabsf(heroPosition.y - curBonus.position.y) < curBonus.contentSize.height/2))
        {
            if(curBonus.isActive)
            {
                curBonus.isActive = NO;
                curBonus.visible = NO;
                
                isCollision = YES;
            }
        }
    }
    
    return isCollision;
}

- (void) generateBorderVertices {

	nBorderVertices = 0;
	CGPoint p0, p1, pt0, pt1;
	p0 = hillKeyPoints[0];
	for (int i=1; i<nHillKeyPoints; i++) {
		p1 = hillKeyPoints[i];
		
		int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
		float dx = (p1.x - p0.x) / hSegments;
		float da = M_PI / hSegments;
		float ymid = (p0.y + p1.y) / 2;
		float ampl = (p0.y - p1.y) / 2;
		pt0 = p0;
		borderVertices[nBorderVertices++] = pt0;
		for (int j=1; j<hSegments+1; j++) {
			pt1.x = p0.x + j*dx;
			pt1.y = ymid + ampl * cosf(da*j);
			borderVertices[nBorderVertices++] = pt1;
			pt0 = pt1;
		}
		
		p0 = p1;
	}
//	NSLog(@"nBorderVertices = %d", nBorderVertices);
}

- (void) createBox2DBody {
	
	b2BodyDef bd;
	bd.position.Set(0, 0);
	
	body = world->CreateBody(&bd);
	
	b2Vec2 b2vertices[kMaxBorderVertices];
	int nVertices = 0;
	for (int i=0; i<nBorderVertices; i++) {
		b2vertices[nVertices++].Set(borderVertices[i].x/PTM_RATIO,borderVertices[i].y/PTM_RATIO);
	}
	b2vertices[nVertices++].Set(borderVertices[nBorderVertices-1].x/PTM_RATIO,0);
	b2vertices[nVertices++].Set(-screenW/4,0);
	
	b2LoopShape shape;
	shape.Create(b2vertices, nVertices);
	body->CreateFixture(&shape, 0);
    
    body->SetActive(YES);
}

- (void) removeBody
{
    world->DestroyBody(body);
}

- (void) resetHillVertices {

#ifdef DRAW_BOX2D_WORLD
	return;
#endif
	
	static int prevFromKeyPointI = -1;
	static int prevToKeyPointI = -1;
	
	// key points interval for drawing
	
	float leftSideX = _offsetX-screenW/8/self.scale;
	float rightSideX = _offsetX+screenW*7/8/self.scale;
	
	while (hillKeyPoints[fromKeyPointI+1].x < leftSideX) {
		fromKeyPointI++;
		if (fromKeyPointI > nHillKeyPoints-1) {
			fromKeyPointI = nHillKeyPoints-1;
			break;
		}
	}
	while (hillKeyPoints[toKeyPointI].x < rightSideX) {
		toKeyPointI++;
		if (toKeyPointI > nHillKeyPoints-1) {
			toKeyPointI = nHillKeyPoints-1;
			break;
		}
	}
	
	if (prevFromKeyPointI != fromKeyPointI || prevToKeyPointI != toKeyPointI) {
		
//		NSLog(@"building hillVertices array for the visible area");

//		NSLog(@"leftSideX = %f", leftSideX);
//		NSLog(@"rightSideX = %f", rightSideX);
		
//		NSLog(@"fromKeyPointI = %d (x = %f)",fromKeyPointI,hillKeyPoints[fromKeyPointI].x);
//		NSLog(@"toKeyPointI = %d (x = %f)",toKeyPointI,hillKeyPoints[toKeyPointI].x);
		
		// vertices for visible area
		nHillVertices = 0;
		CGPoint p0, p1, pt0, pt1;
		p0 = hillKeyPoints[fromKeyPointI];
		for (int i=fromKeyPointI+1; i<toKeyPointI+1; i++) {
			p1 = hillKeyPoints[i];
			
			// triangle strip between p0 and p1
			int hSegments = floorf((p1.x-p0.x)/kHillSegmentWidth);
			int vSegments = 1;
			float dx = (p1.x - p0.x) / hSegments;
			float da = M_PI / hSegments;
			float ymid = (p0.y + p1.y) / 2;
			float ampl = (p0.y - p1.y) / 2;
			pt0 = p0;
			for (int j=1; j<hSegments+1; j++) {
				pt1.x = p0.x + j*dx;
				pt1.y = ymid + ampl * cosf(da*j);
				for (int k=0; k<vSegments+1; k++)
                {
					hillVertices[nHillVertices] =  ccpMult(ccp(pt0.x, pt0.y-(float)textureSize/vSegments*k), CC_CONTENT_SCALE_FACTOR());
					hillTexCoords[nHillVertices++] = ccpMult(ccp(pt0.x/(float)textureSize, (float)(k)/vSegments), CC_CONTENT_SCALE_FACTOR());
					hillVertices[nHillVertices] = ccpMult(ccp(pt1.x, pt1.y-(float)textureSize/vSegments*k), CC_CONTENT_SCALE_FACTOR());
					hillTexCoords[nHillVertices++] = ccpMult(ccp(pt1.x/(float)textureSize, (float)(k)/vSegments), CC_CONTENT_SCALE_FACTOR());
                    
                }
                
                
				pt0 = pt1;
			}
			
			p0 = p1;
		}
		
//		NSLog(@"nHillVertices = %d", nHillVertices);
		
		prevFromKeyPointI = fromKeyPointI;
		prevToKeyPointI = toKeyPointI;
	}
}

- (ccColor4F) randomColor {
	const int minSum = 450;
	const int minDelta = 150;
	int r, g, b, min, max;
	while (true) {
		r = arc4random()%256;
		g = arc4random()%256;
		b = arc4random()%256;
		min = MIN(MIN(r, g), b);
		max = MAX(MAX(r, g), b);
		if (max-min < minDelta) continue;
		if (r+g+b < minSum) continue;
		break;
	}
	return ccc4FFromccc3B(ccc3(r, g, b));
}

- (void) draw {
    
#ifdef DRAW_BOX2D_WORLD
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	world->DrawDebugData();
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
	
#else
	
	glBindTexture(GL_TEXTURE_2D, _stripes.texture.name);
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glColor4f(1, 1, 1, 1);
	glVertexPointer(2, GL_FLOAT, 0, hillVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, hillTexCoords);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nHillVertices);
	
	glEnableClientState(GL_COLOR_ARRAY);
	
#endif
}

- (void) setOffsetX:(float)offsetX
{
	if (_offsetX != offsetX || firstTime)
    {
		firstTime = NO;
		_offsetX = offsetX;
		self.position = ccp(screenW/8-_offsetX*self.scale, 0);
		[self resetHillVertices];
	}
}

- (void) reset {
	
#ifndef DRAW_BOX2D_WORLD
	self.stripes = [self generateStripesSprite];
#endif
    
    for(Bonus *curBonus in bonusesArray)
    {
        curBonus.visible = YES;
        curBonus.isActive = YES;
    }
    
	
	fromKeyPointI = 0;
	toKeyPointI = 0;
}

@end
