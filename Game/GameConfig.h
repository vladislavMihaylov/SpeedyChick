

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


// keys for settings

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
#define kEnergyKey            @"kEnergyKey"
#define kBuyedChicks          @"kBuyedChicks"

// Purchase

#define p_coins1000                 0
#define p_rockets15                 1
#define p_coins20000                2
#define p_rockets3                  3
#define p_coins5000                 4
#define p_rockets50                 5
#define p_ghostChick                6
#define p_kidsMode                  7
#define p_noads                     8
#define p_superChick                9

// tags and screen's parameters

#define backBtnTag                  -1
#define menuBgTag                   10
#define exitBtnTag                  11
#define selectLevelMenuTag          100 

#define kWidthIPAD                  1024
#define kHeightIPAD                 768

#define kWidthIPHONE                480
#define kHeightIPHONE               320

// Physics

#define iPadRadius                  16 //23
#define iPhoneRadius                13

#define usualSegmentWidth           15
#define retinaSegmentWidth          8

#define defaultHeightOfFly          550
#define defaultSpeedOfFly           33

#define defaultHeightOfFlyIPAD      1100
#define defaultSpeedOfFlyIPAD       66

#define minVelocityXIPHONE          3
#define minVelocityYIPHONE          -20

#define minVelocityXIPAD            9
#define minVelocityYIPAD            -180

#define forceYIPAD                  -50 // -60
#define forceYIPHONE                -22 // -20

#define gravityIpad                 -19.6
#define gravityIphone               -9.8


// Other

#define iPadShopTextScale   0.8
#define iPhoneShopTextScale 0.6

#define iPadNoAdsBtnMultiplier 0.95
#define iPhoneNoAdsBtnMultiplier 1.02

#define iPadRestoreBtnMultiplier 0.4
#define iPhoneRestoreBtnMultiplier 0.47

#define iPadCustomItemXcoefForPos 18
#define iPhoneCustomItemXcoefForPos 9

#define iPadCustomItemHeightParameter 70
#define iPhoneCustomItemHeightParameter 25

#define iPadCustomItemMultiplier 1.33
#define iPhoneCustomItemMultiplier 1.45

#define iPadCustomItemScale 1
#define iPhoneCustomItemScale 0.95

// settings

extern float shopTextScale;
extern float noAdsBtnMultiplier;
extern float restoreBtnMultiplier;
extern float customItemXcoefForPos;
extern float customItemHeightParameter;
extern float customItemMultiplier;
extern float customItemScale;

extern float countOfMana;

extern CGRect iPhoneShopRect;
extern CGRect iPadShopRect;
extern CGRect thisisRECT;

extern CGRect iPhoneCustomizeRect;
extern CGRect iPadCustomizeRect;
extern CGRect customizeRect;

extern CGRect iPadBannerRect;
extern CGRect iPhoneBannerRect;
extern CGRect bannerRect;

// screen's parameters

extern float GameWidth;
extern float GameHeight;
extern float GameCenterX;
extern float GameCenterY;

extern float xPositionForTextField;
extern float yPositionForTextField;
extern float textFontSize;

extern CGRect rectForTextField;

// gui parameters

extern CGPoint catStartPosition;
extern CGPoint cocoStartPosition;
extern CGPoint finishPointForCoco;

// other parameters

extern NSInteger currentWorld;
extern NSInteger currentLevel;
extern NSInteger costForOpenLevel;

extern NSInteger coefForCoords;

extern NSInteger currentHeightOfFly;
extern NSInteger currentSpeedOfFly;

extern NSInteger countOfLoses;
extern NSInteger countOfPlays;

extern NSString *suffix;

// flags

extern BOOL isMopubShowed;

extern BOOL isGameActive;
extern BOOL isPauseOfGame;
extern BOOL ChickOnTheStart;
extern BOOL isFinish;
extern BOOL isInviteShowed;
extern BOOL isUserPlayed;
extern BOOL isAlertAboutOutOfRocketsShowed;
extern BOOL isAlertWantToGetCoinsShowed;
extern BOOL isAlertGetThisChickShowed;

// Physics parameters

extern NSInteger segmentWidth;

extern float bodyRadius;
extern float minSpeedX;
extern float minSpeedY;
extern float forceY;
extern float gravityY;
