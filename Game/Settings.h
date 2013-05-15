
#import <Foundation/Foundation.h>

@interface Settings: NSObject
{
    NSInteger currentPinguin;
    NSInteger countOfRockets;
    BOOL isCatEnabled;
    
    NSInteger countOfRuns;
    NSInteger countOfCoins;
    BOOL isAdEnabled;
    BOOL isFirstRun;
    
    BOOL isKidsModeBuyed;
    BOOL isSuperChickBuyed;
    BOOL isGhostChickBuyed;
    
    NSInteger openedWorlds;
    NSString *openedLevels;
    
    NSString *starsCount;
    NSString *futureDate;
    
    NSString *nameOfPlayer;
    
    NSString *buyedCustomiziedChicks;
    
    NSInteger energy;
}

+ (Settings *) sharedSettings;

- (void) load;
- (void) save;

@property (nonatomic, assign) NSInteger currentPinguin;
@property (nonatomic, assign) NSInteger countOfRockets;
@property (nonatomic, assign) BOOL isCatEnabled;

@property (nonatomic, assign) NSInteger countOfRuns;
@property (nonatomic, assign) NSInteger countOfCoins;
@property (nonatomic, assign) BOOL isAdEnabled;
@property (nonatomic, assign) BOOL isFirstRun;

@property (nonatomic, assign) BOOL isKidsModeBuyed;
@property (nonatomic, assign) BOOL isSuperChickBuyed;
@property (nonatomic, assign) BOOL isGhostChickBuyed;

@property (nonatomic, assign) NSInteger openedWorlds;
@property (nonatomic, retain) NSString *openedLevels;

@property (nonatomic, retain) NSString *starsCount;
@property (nonatomic, retain) NSString *futureDate;

@property (nonatomic, retain) NSString *nameOfPlayer;

@property (nonatomic, retain) NSString *buyedCustomiziedChicks;

@property (nonatomic, assign) NSInteger energy;

@end