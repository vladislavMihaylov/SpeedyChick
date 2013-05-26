

#import <UIKit/UIKit.h>

#import "MPAdView.h"


@interface RootViewController : UIViewController <MPAdViewDelegate>
{
    
}

@property (nonatomic, retain) MPAdView *adView;

- (void) applyAdView;

@end
