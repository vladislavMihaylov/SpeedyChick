
#import "Common.h"

@implementation Common

+ (CCAnimation *) loadAnimationWithPlist: (NSString *) file andName: (NSString *) name
{
    CCAnimation *animation = nil;
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: file ofType: @"plist"]];
    if(!plistDict)
    {
        CCLOG(@"no such file! - %@", file);
        return nil;
    }
    
    NSDictionary *animationDict = [plistDict objectForKey: name];
    
    if(!animationDict)
    {
        CCLOG(@"no such animation! - %@", name);
        return nil;
    }
    
    animation = [CCAnimation animation];
    
    float animationDelay = [[animationDict objectForKey: @"delay"] floatValue];
    [animation setDelay: animationDelay];
    
    NSString *animationFrames = [animationDict objectForKey: @"animationFrames"];
    
    NSArray *frameIndices = [animationFrames componentsSeparatedByString: @","];
    
    for(NSString *frameIndex in frameIndices)
    {
        NSString *frameName = [NSString stringWithFormat: @"%@%@.png", name, frameIndex];
        
        [animation addFrame: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: frameName]];
    }
    
    [[CCAnimationCache sharedAnimationCache] addAnimation: animation name: name];
    
    return animation;
}

@end