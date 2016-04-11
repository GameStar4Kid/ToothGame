//
//  IntroLayer.m
//  SpotDiff
//
//  Created by tbnguyen on 3/15/13.
//  Copyright tbnguyen 2013. All rights reserved.
//


// Import the interfaces
#import "StartLayer.h"
#import "IntroLayer.h"
#import "AppDelegate.h"
#pragma mark - IntroLayer
@interface StartLayer(){
    CCSprite *background;
    AppController* mDel;
    CCSprite* btnPlay,*btnSetting,*btnHelp,*btnGallery,*btnMode;
    CCSprite *lblMode;
    CCLabelTTF*lblText;
    float mScale;
    bool onEntered;
    float mScaleIPhone;
}
@property (nonatomic,assign) int mMode;
@end
// HelloWorldLayer implementation
@implementation StartLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	StartLayer *layer = [StartLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}
-(void)dealloc{
    [super dealloc];
}
// 
-(id) init
{
	if( (self=[super init])) {
        if([[CCDirector sharedDirector] enableRetinaDisplay:YES]){
            mScale=2.0;
        }else{
            mScale=1.0;
        }
		mDel=((AppController*)[UIApplication sharedApplication].delegate);
        [self initBackground];
	}
	
	return self;
}

/*
 * Initializes everything in the background
 */
-(void)initBackground
{
//    CGSize screen = [[CCDirector sharedDirector] winSize];
    
    // add the background image
    CCSprite *theme = [CCSprite spriteWithFile:@"begin screen.png"];
    theme.anchorPoint=ccp(0.5,0.5);
    theme.position = ccp(theme.contentSize.width*mScale/2,theme.contentSize.height*mScale/2);
    theme.scale=mScale;
    [self addChild:theme z:0];
    btnPlay = [CCSprite spriteWithFile:@"begin button.png"];
    btnPlay.position = ccp(theme.contentSize.width*mScale-btnPlay.contentSize.width*mScale/2-10,btnPlay.contentSize.height*mScale/2+10);
    btnPlay.scale=mScale;
    [self addChild:btnPlay z:0];
    
}
-(void) onEnter
{
	[super onEnter];
    onEntered=YES;
}

-(void)btnPlayClicked{
    NSLog(@"btnPlayClicked");
    [mDel playSound:E_SOUND_ON_OFF];
    [mDel openIntroLayer];
}
- (void)singleTouch1:(UITapGestureRecognizer *)recognizer {
    if(!onEntered)return;
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    if (CGRectContainsPoint(btnPlay.boundingBox, touchLocation)) {
        onEntered=NO;
        [self btnPlayClicked];
    }
}

@end
