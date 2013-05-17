
#import "Settings.h"
#import "GameConfig.h"

@implementation Settings

Settings *sharedSettings = nil;

@synthesize currentPinguin;
@synthesize countOfRockets;
@synthesize isCatEnabled;

@synthesize countOfRuns;
@synthesize countOfCoins;
@synthesize isAdEnabled;
@synthesize isFirstRun;

@synthesize isKidsModeBuyed;
@synthesize isSuperChickBuyed;
@synthesize isGhostChickBuyed;

@synthesize openedWorlds;
@synthesize openedLevels;

@synthesize starsCount;

@synthesize futureDate;

@synthesize nameOfPlayer;

@synthesize energy;

+ (Settings *) sharedSettings
{
    if(!sharedSettings)
    {
        sharedSettings = [[Settings alloc] init];
    }
    
    return sharedSettings;
}

- (id) init
{
    if((self = [super init]))
    {
        //
    }
    
    return self;
}

- (void) dealloc
{
    [self save];
    [super dealloc];
}

#pragma mark -
#pragma mark load/save

- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Integer
    
    NSNumber *pinguinData = [defaults objectForKey: kPinguinKey];
    if(pinguinData)
    {
        self.currentPinguin = [pinguinData integerValue];
    }
    else
    {
        self.currentPinguin = 1;
    }
    
    NSNumber *rocketsData = [defaults objectForKey: kRocketsKey];
    if(rocketsData)
    {
        self.countOfRockets = [rocketsData integerValue];
    }
    else
    {
        self.countOfRockets = 1;
    }
    
    NSNumber *countRunsData = [defaults objectForKey: kCountOfRunsKey];
    if(countRunsData)
    {
        self.countOfRuns = [countRunsData integerValue];
    }
    else
    {
        self.countOfRuns = 0;
    }
    
    NSNumber *countCoinsData = [defaults objectForKey: kCountOfCoins];
    if(countCoinsData)
    {
        self.countOfCoins = [countCoinsData integerValue];
    }
    else
    {
        self.countOfCoins = 10;
    }
    
    NSNumber *openedWorldsData = [defaults objectForKey: kOpenedWorldsKey];
    if(openedWorldsData)
    {
        self.openedWorlds = [openedWorldsData integerValue];
    }
    else
    {
        self.openedWorlds = 1;
    }
    
    NSString *openedLevelsData = [defaults objectForKey: kOpenedLevelsKey];
    if(openedLevelsData)
    {
        self.openedLevels = openedLevelsData;
    }
    else
    {
        self.openedLevels = @"4100000000000000";
    }
    
    NSString *starsCountData = [defaults objectForKey: kStarsCountKey];
    if(starsCountData)
    {
        self.starsCount = starsCountData;
    }
    else
    {
        self.starsCount = @"4000000000000000";
    }
    
    NSString *nameData = [defaults objectForKey: kNameKey];
    if(nameData)
    {
        self.nameOfPlayer = nameData;
    }
    else
    {
        self.nameOfPlayer = @"";
    }
    
    NSString *buyedData = [defaults objectForKey: kBuyedChicks];
    if(buyedData)
    {
        self.buyedCustomiziedChicks = buyedData;
    }
    else
    {
        self.buyedCustomiziedChicks = @"10000000000";
    }
    
    // BOOL
    
    NSNumber *catsEnabledData = [defaults objectForKey: kCatKey];
    if(catsEnabledData)
    {
        self.isCatEnabled = [catsEnabledData boolValue];
    }
    else
    {
        self.isCatEnabled = YES;
    }
    
    NSNumber *AdEnabledData = [defaults objectForKey: kAdKey];
    if(AdEnabledData)
    {
        self.isAdEnabled = [AdEnabledData boolValue];
    }
    else
    {
        self.isAdEnabled = YES;
    }
    
    NSNumber *firstRunData = [defaults objectForKey: kFirstRunKey];
    if(firstRunData)
    {
        self.isFirstRun = [firstRunData boolValue];
    }
    else
    {
        self.isFirstRun = YES;
    }
    
    NSNumber *kidsModeData = [defaults objectForKey: kKidsModeKey];
    if(kidsModeData)
    {
        self.isKidsModeBuyed = [kidsModeData boolValue];
    }
    else
    {
        self.isKidsModeBuyed = NO;
    }
    
    NSNumber *superChickData = [defaults objectForKey: kSuperChickKey];
    if(superChickData)
    {
        self.isSuperChickBuyed = [superChickData boolValue];
    }
    else
    {
        self.isSuperChickBuyed = NO;
    }
    
    NSNumber *ghostChickData = [defaults objectForKey: kGhostChickKey];
    if(ghostChickData)
    {
        self.isGhostChickBuyed = [ghostChickData boolValue];
    }
    else
    {
        self.isGhostChickBuyed = NO;
    }
    
    NSString *futureDateData = [defaults objectForKey: kDateKey];
    if(futureDateData)
    {
        self.futureDate = futureDateData;
    }
    else
    {
        self.futureDate = @"";
    }
    
    NSNumber *energyData = [defaults objectForKey: kEnergyKey];
    if(energyData)
    {
        self.energy = [energyData integerValue];
    }
    else
    {
        self.energy = 0;
    }
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithInteger: self.currentPinguin] forKey: kPinguinKey];
    [defaults setObject: [NSNumber numberWithInteger: self.countOfRockets] forKey: kRocketsKey];
    [defaults setObject: [NSNumber numberWithBool: self.isCatEnabled] forKey: kCatKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.countOfRuns] forKey: kCountOfRunsKey];
    [defaults setObject: [NSNumber numberWithInteger: self.countOfCoins] forKey: kCountOfCoins];
    [defaults setObject: [NSNumber numberWithBool: self.isAdEnabled] forKey: kAdKey];
    [defaults setObject: [NSNumber numberWithBool: self.isFirstRun] forKey: kFirstRunKey];
    
    [defaults setObject: [NSNumber numberWithBool: self.isKidsModeBuyed] forKey: kKidsModeKey];
    [defaults setObject: [NSNumber numberWithBool: self.isSuperChickBuyed] forKey: kSuperChickKey];
    [defaults setObject: [NSNumber numberWithBool: self.isGhostChickBuyed] forKey: kGhostChickKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.openedWorlds] forKey: kOpenedWorldsKey];
    [defaults setObject: [NSString stringWithString: self.openedLevels] forKey: kOpenedLevelsKey];
    
    
    [defaults setObject: [NSString stringWithString: self.starsCount] forKey: kStarsCountKey];
    
    [defaults setObject: [NSString stringWithString: self.futureDate] forKey: kDateKey];
    
    [defaults setObject: [NSString stringWithString: self.nameOfPlayer] forKey: kNameKey];
    
    [defaults setObject: [NSString stringWithString: self.buyedCustomiziedChicks] forKey: kBuyedChicks];
    
    [defaults setObject: [NSNumber numberWithInteger: self.energy] forKey: kEnergyKey];
    
    [defaults synchronize];
}


@end
