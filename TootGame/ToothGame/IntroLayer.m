//
//  IntroLayer.m
//  SpotDiff
//
//  Created by tbnguyen on 3/15/13.
//  Copyright tbnguyen 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "AppDelegate.h"
#pragma mark - IntroLayer
@interface IntroLayer(){
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
@implementation IntroLayer

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
	IntroLayer *layer = [IntroLayer node];
	
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
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // add the background image
    CCSprite *theme = [CCSprite spriteWithFile:@"background_smile tooth.png"];
    theme.anchorPoint=ccp(0.5,0.5);
    theme.position = ccp(theme.contentSize.width*mScale/2,theme.contentSize.height*mScale/2);
    theme.scale=mScale;
    [self addChild:theme z:0];
    btnPlay = [CCSprite spriteWithFile:@"chon_op1.png"];
    btnPlay.position = ccp(theme.contentSize.width*mScale/2-btnPlay.contentSize.width*mScale/2-20-100,theme.contentSize.height*mScale/2);
    btnPlay.scale=mScale;
    [self addChild:btnPlay z:0];
    btnHelp = [CCSprite spriteWithFile:@"chon_op2.png"];
    btnHelp.position = ccp(theme.contentSize.width*mScale/2+btnHelp.contentSize.width*mScale/2+20-100,theme.contentSize.height*mScale/2);
    btnHelp.scale=mScale;
    [self addChild:btnHelp z:0];
    lblText=[CCLabelTTF labelWithString:@"Chọn Kem Đánh Răng\n Giúp Bảo Vệ Răng Khỏi Ê Buốt" fontName:@"arial" fontSize:25];
    lblText.position=ccp(theme.contentSize.width*mScale/2-100,theme.contentSize.height*mScale/2+150);
    [self addChild:lblText z:0];
    CCSprite* _spiteTimer=[CCSprite spriteWithFile:@"30.png"];
    _spiteTimer.position=ccp(winSize.width-_spiteTimer.contentSize.width*mScale*2/2-30,winSize.height-_spiteTimer.contentSize.height*mScale*2/2-70);
    _spiteTimer.scale=mScale*2;
    [self addChild:_spiteTimer];
    [self addLoadingProgress];
}
-(void)addLoadingProgress{
    NSMutableArray*_loading=[NSMutableArray arrayWithCapacity:0];
    for(int countSuccess=1;countSuccess<=20;countSuccess++){
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        NSString*file= [NSString stringWithFormat:@"loading%d.png",countSuccess];
        CCSprite* loading=[CCSprite spriteWithFile:file];
        float deltaY=20+loading.contentSize.height*mScale/2;
        if(countSuccess>1){
            int prev=countSuccess-2;
            CCSprite*prevLoading=[_loading objectAtIndex:prev];
            deltaY=prevLoading.position.y+prevLoading.contentSize.height*mScale/2+loading.contentSize.height*mScale/2;
        }
        int i=countSuccess;
        if(i==2||i==3||i==5||i==6||i==7||i==8||i==11||i==12||i==13||i==14||i==16||i==17||i==18||i==19||i==20){
        deltaY--;
        }
        loading.position=ccp(winSize.width-loading.contentSize.width*mScale/2-20,deltaY);
        loading.scale=mScale;
        [self addChild:loading];
        [_loading addObject:loading];
    }
}
-(void) onEnter
{
	[super onEnter];
    onEntered=YES;
}

-(void)btnPlayClicked{
    NSLog(@"btnPlayClicked");
    [mDel playSound:E_SOUND_ON_OFF];
    [mDel openGameLayer];
}
-(void)btnHelpClicked{
    [mDel playSound:E_SOUND_WRONG];
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
    else if (CGRectContainsPoint(btnHelp.boundingBox, touchLocation)) {
        [self btnHelpClicked];
    }
}

@end
