
#import "Settings.h"
#import "GameConfig.h"

@implementation Settings

Settings *sharedSettings = nil;

@synthesize currentPinguin;
@synthesize countOfRockets;

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
    if(pinguinData)
    {
        self.countOfRockets = [rocketsData integerValue];
    }
    else
    {
        self.countOfRockets = 1;
    }
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithInteger: self.currentPinguin] forKey: kPinguinKey];
    [defaults setObject: [NSNumber numberWithInteger: self.countOfRockets] forKey: kRocketsKey];
    
    [defaults synchronize];
}


@end
