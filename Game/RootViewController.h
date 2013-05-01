

#import <UIKit/UIKit.h>

#import "MPInterstitialAdController.h"

@interface RootViewController : UIViewController <MPInterstitialAdControllerDelegate>
{
    
}

@property (nonatomic, retain) MPInterstitialAdController *interstitial;

- (void)showMopubAd;

@end
