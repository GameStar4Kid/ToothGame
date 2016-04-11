//
//  AppDelegate.m
//  jigsaw puzzle
//
//  Created by Jury on 4/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "StartLayer.h"
#import "SimpleAudioEngine.h"
@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.mScalePhone=0.5;
    }else{
        self.mScalePhone=1.0;
    }
//    self.enableSound=[[[NSUserDefaults standardUserDefaults] objectForKey:@"enableSound"] boolValue];
//    self.enableMusic=[[[NSUserDefaults standardUserDefaults] objectForKey:@"enableMusic"] boolValue];
    self.enableMusic=YES;
    self.enableSound=YES;
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
//	[director_ setDisplayStats:YES];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
    CCScene*scene=[StartLayer scene];
	[director_ pushScene:scene ];
    StartLayer *layer = (StartLayer *) [scene.children objectAtIndex:0];
//    UIPanGestureRecognizer *gestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:layer action:@selector(handlePanFrom:)] autorelease];
//    [navController_.view addGestureRecognizer:gestureRecognizer];
	
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
    UITapGestureRecognizer* tapSingleRecognizer1=[[[UITapGestureRecognizer alloc]initWithTarget:layer action:@selector(singleTouch1:)]autorelease];
    tapSingleRecognizer1.numberOfTapsRequired=1;
    [navController_.view addGestureRecognizer:tapSingleRecognizer1];
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	return YES;
}
-(void)openIntroLayer{
    CCScene*scene=[IntroLayer scene];
	[director_ replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:scene withColor:ccWHITE]];
    IntroLayer *layer = (IntroLayer *) [scene.children objectAtIndex:0];
    UITapGestureRecognizer* tapSingleRecognizer1=[[[UITapGestureRecognizer alloc]initWithTarget:layer action:@selector(singleTouch1:)]autorelease];
    tapSingleRecognizer1.numberOfTapsRequired=1;
    [navController_.view addGestureRecognizer:tapSingleRecognizer1];
}
-(void)openStartLayer{
    CCScene*scene=[StartLayer scene];
	[director_ replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:scene withColor:ccWHITE]];
    IntroLayer *layer = (IntroLayer *) [scene.children objectAtIndex:0];
    UITapGestureRecognizer* tapSingleRecognizer1=[[[UITapGestureRecognizer alloc]initWithTarget:layer action:@selector(singleTouch1:)]autorelease];
    tapSingleRecognizer1.numberOfTapsRequired=1;
    [navController_.view addGestureRecognizer:tapSingleRecognizer1];
}
-(void)openGameLayer{
    CCScene*scene=[HelloWorldLayer scene];
	[director_ replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:scene withColor:ccWHITE]];
    IntroLayer *layer = (IntroLayer *) [scene.children objectAtIndex:0];
    UITapGestureRecognizer* tapSingleRecognizer1=[[[UITapGestureRecognizer alloc]initWithTarget:layer action:@selector(singleTouch1:)]autorelease];
    tapSingleRecognizer1.numberOfTapsRequired=1;
    [navController_.view addGestureRecognizer:tapSingleRecognizer1];
}
// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}
// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}
// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}

-(void)playSound:(ENUM_SOUND)type{
    switch (type) {
        case E_SOUND_BG:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"frame3_background.mp3" loop:YES];
            break;
        case E_SOUND_ON_OFF:
            if(self.enableSound){
                [[SimpleAudioEngine sharedEngine] playEffect:@"frame2_Choose normal.wav"];
            }
            break;
        case E_SOUND_SUCCESS:
            if(self.enableSound){
                [[SimpleAudioEngine sharedEngine] playEffect:@"frame3_smile.WAV"];
            }
            break;
        case E_SOUND_WRONG:
            if(self.enableSound){
                [[SimpleAudioEngine sharedEngine] playEffect:@"frame3_cry.WAV"];
            }
            break;
        case E_SOUND_WIN:
            if(self.enableSound){
                [[SimpleAudioEngine sharedEngine] playEffect:@"frame3_win.WAV"];
            }
            break;
        case E_SOUND_LOSE:
            if(self.enableSound){
                [[SimpleAudioEngine sharedEngine] playEffect:@"frame3_loose.wav"];
            }
            break;
        default:
            break;
    }
}
@end

