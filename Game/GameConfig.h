

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H


#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

#endif // __GAME_CONFIG_H

#define kPinguinKey           @"pinguinKey"
#define kRocketsKey           @"rocketsKey"
#define kCatKey               @"catKey"

#define kCountOfRunsKey       @"run'sCountKey"
#define kCountOfCoins         @"coin'sCountKey"
#define kAdKey                @"AdKey"
#define kFirstRunKey          @"kFirstRunKey"

#define kKidsModeKey          @"kKidsModeKey"
#define kSuperChickKey        @"kSuperChickKey"
#define kGhostChickKey        @"kGhostChickKey"

#define kOpenedWorldsKey      @"kOpenedWorldsKey"
#define kOpenedLevelsKey      @"kOpenedLevelsKey"

#define kStarsCountKey        @"kStarsCountKey"

#define kDateKey              @"kDateKey"

#define kNameKey              @"kNameKey"

#define backBtnTag         -1
#define menuBgTag          10
#define exitBtnTag         11
#define selectLevelMenuTag 100 

extern CGPoint catStartPosition;
extern CGPoint cocoStartPosition;
extern CGPoint finishPointForCoco;

extern NSInteger currentWorld;
extern NSInteger currentLevel;
extern NSInteger defaultHeightOfFly;
extern NSInteger defaultSpeedOfFly;
extern NSInteger costForOpenLevel;

extern NSInteger currentHeightOfFly;
extern NSInteger currentSpeedOfFly;

extern float countOfMana;

extern BOOL isGameActive;
extern BOOL ChickOnTheStart;
