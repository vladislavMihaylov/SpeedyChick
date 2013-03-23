

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "RootViewController.h"

#import "CCBReader.h"

#import "Settings.h"

#import "SHKConfiguration.h"

#import "MySHKConfigurator.h"

#import "SHKFacebook.h"

#import "Configuration.h"


@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker {

	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) addNotification
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    notif.timeZone = [NSTimeZone defaultTimeZone]; //часовой пояс, я обычно пользуюсь в программах дефолтным по Гринвичу, но можно использовать systemTimeZone, это будет время в устройстве.
    
    notif.fireDate = [[NSDate date] dateByAddingTimeInterval: 86400.0f]; //время, когда наступит время нотификатора, у нас это текущая дата + 20 секунд. Можно прибегнуть к помощи NSDateComponents для установок своей даты.
    
    notif.alertAction = @"Play with me!"; //Текст кнопочки, вызывающей вашу программу из фонового режима
    
    notif.alertBody = @"Chick misses! Play with him!"; //Тело сообщения над кнопочкой
    
    notif.soundName = UILocalNotificationDefaultSoundName; //дефолтный звук сообщения. Можно задать свой в папке проекта.
    
    //notif.applicationIconBadgeNumber = 1; //число "бейджа" на иконке приложения при наступлении уведомления
    
    notif.repeatInterval = NSDayCalendarUnit; //если необходимо, используем повтор (не пытайтесь установить свое время повтора, это невозможно. Используйте только NSCalendarCalendarUnit.
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif]; //Размещаем наше локальное уведомление!
    
    [notif release];
}

- (void) deleteAllNotifs
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications]; //удаляем все!
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	

    
    [self deleteAllNotifs];
    [self addNotification];
    
    DefaultSHKConfigurator *configurator = [[[MySHKConfigurator alloc] init] autorelease];
    
    [SHKConfiguration sharedInstanceWithConfigurator: configurator];
    
    [[Settings sharedSettings] load];
    
    
    
    //[Settings sharedSettings].countOfRockets = 2;
    //[[Settings sharedSettings] save];
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//

	[director setDeviceOrientation:kCCDeviceOrientationPortrait];

	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	[director setDepthTest:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
    [window setRootViewController: viewController];
    
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MainMenu.ccb"];
    
    // Run the loaded scene
	[[CCDirector sharedDirector] runWithScene: scene];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];
    
    [SHKFacebook handleWillTerminate];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

/////////////

- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}


/////////////

@end
