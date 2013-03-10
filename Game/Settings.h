
#import <Foundation/Foundation.h>

@interface Settings: NSObject
{
    NSInteger currentPinguin;
    NSInteger countOfRockets;
}

+ (Settings *) sharedSettings;

- (void) load;
- (void) save;

@property (nonatomic, assign) NSInteger currentPinguin;
@property (nonatomic, assign) NSInteger countOfRockets;

@end