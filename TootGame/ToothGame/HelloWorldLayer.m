//
//  HelloWorldLayer.m
//  jigsaw puzzle
//
//  Created by Jury on 4/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "IntroLayer.h"
#import "StartLayer.h"
#import "SimpleAudioEngine.h"
#pragma mark - HelloWorldLayer
const int MAX_TIMER =30;

@interface HelloWorldLayer(){
    AppController* mDel;
    float mScale;
    bool onEntered;
    int _projectilesDestroyed;
    int timer;
    CCSprite* selfSprite;
    float _playerY;
    int countSuccess;
}
@property(nonatomic,assign)UIPanGestureRecognizer *gestureRecognizer;
@property(nonatomic,assign)UITapGestureRecognizer* tapRecognizer;
@property(nonatomic,assign)UITapGestureRecognizer* tapSingleRecognizer;
@property(nonatomic,assign)UIPinchGestureRecognizer* pinchReg;

@property(nonatomic,strong)CCSprite *player;
@property(nonatomic,strong)NSMutableArray *targets;
@property(nonatomic,strong)CCSprite*bg;
@property(nonatomic,strong)CCSprite*bg2;
@property(nonatomic,strong)CCSprite*topBoard;
@property(nonatomic,strong)CCSprite*flash;
@property(nonatomic,strong)CCSprite*spiteTimer;
@property(nonatomic,strong)CCSprite*spriteWin;
@property(nonatomic,strong)CCSprite*btnRestart;
@property(nonatomic,strong)NSMutableArray *loading;
@end
// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
    UIPanGestureRecognizer *gestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:layer action:@selector(handlePanFrom:)] autorelease];
    AppController*mDel=(AppController*)[UIApplication sharedApplication].delegate;
    [mDel.navController.view addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer* tapSingleRecognizer=[[[UITapGestureRecognizer alloc]initWithTarget:layer action:@selector(singleTouch:)]autorelease];
    tapSingleRecognizer.numberOfTapsRequired=1;
    [mDel.navController.view addGestureRecognizer:tapSingleRecognizer];
    
    layer.gestureRecognizer=gestureRecognizer;
    layer.tapSingleRecognizer=tapSingleRecognizer;
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        onEntered=NO;
        if([[CCDirector sharedDirector] enableRetinaDisplay:YES]){
            mScale=2.0;
        }else{
            mScale=1.0;
        }
        mDel=(AppController*)[UIApplication sharedApplication].delegate;
        self.targets = [[[NSMutableArray alloc] init]autorelease];
        self.loading = [[[NSMutableArray alloc] init]autorelease];
        self.bg2=[CCSprite spriteWithFile:@"background_scare tooth.png"];
        _bg2.position=ccp(winSize.width/2,winSize.height/2);
        _bg2.scale=mScale;
        [self addChild:_bg2 z:-2];
        self.bg=[CCSprite spriteWithFile:@"background_smile tooth.png"];
        _bg.position=ccp(winSize.width/2,winSize.height/2);
        _bg.scale=mScale;
        [self addChild:_bg z:-2];
        self.topBoard=[CCSprite spriteWithFile:@"top board.png"];
        _topBoard.position=ccp(_topBoard.contentSize.width*mScale/2,winSize.height-_topBoard.contentSize.height*mScale/2);
        _topBoard.scale=mScale;
        [self addChild:_topBoard];
		// Get the dimensions of the window for calculation purposes
       
        self.spiteTimer=[CCSprite spriteWithFile:@"30.png"];
        _spiteTimer.position=ccp(winSize.width-_spiteTimer.contentSize.width*mScale*2/2-30,winSize.height-_spiteTimer.contentSize.height*mScale*2/2-70);
        _spiteTimer.scale=mScale*2;
        [self addChild:_spiteTimer];
		
		// Add the player to the middle of the screen along the y-axis,
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
		self.player = [CCSprite spriteWithFile:@"bar.png"];
        _playerY=_player.contentSize.height*mScale/2+200;
		_player.position = ccp(winSize.width/2-_player.contentSize.width*mScale/2, _playerY);
        _player.scale=mScale;
		[self addChild:_player];
        countSuccess=0;
        
        // Useful for taking screenshots
		timer=MAX_TIMER;
		// Call game logic about every second
        [self startSchedule];
        if(mDel.enableMusic){
            [mDel playSound:E_SOUND_BG];
        }
	}
	return self;
}
-(void)runTimer:(ccTime)dt{
    timer--;
    [self addTimer];
    if(timer<=0){
        [self endGame];
        [self unschedule:@selector(runTimer:)];
    }
}
-(void)addTimer{
    if(timer<0)return;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSString*file=[NSString stringWithFormat:@"%d.png",timer];
    [_spiteTimer removeFromParentAndCleanup:YES];
    self.spiteTimer=[CCSprite spriteWithFile:file];
    _spiteTimer.position=ccp(winSize.width-_spiteTimer.contentSize.width*mScale*2/2-30,winSize.height-_spiteTimer.contentSize.height*mScale*2/2-70);
    _spiteTimer.scale=mScale*2;
    [self addChild:_spiteTimer];
}
-(void)endGame{
    NSLog(@"end Game");
    bool isWin=NO;
    if(countSuccess>=15){
        isWin=YES;
    }
    
    [self stopAllActions];
    [self removeSchedule];
    if(isWin){
        [mDel playSound:E_SOUND_WIN];
        [self showWinScreen];
    }else{
        [mDel playSound:E_SOUND_LOSE];
        [self showLoseScreen];
    }
}
-(void)removeSchedule{
    [self unschedule:@selector(update:)];
    [self unschedule:@selector(runTimer:)];
    [self unschedule:@selector(gameLogic:)];
}
-(void)startSchedule{
    [self schedule:@selector(gameLogic:) interval:0.5];
    [self schedule:@selector(update:)];
    [self schedule:@selector(runTimer:) interval:1.0];
}
-(void)showWinScreen{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [_spriteWin removeFromParentAndCleanup:YES];
    self.spriteWin=[CCSprite spriteWithFile:@"win noti.png"];
    _spriteWin.position=ccp(winSize.width/2-70,winSize.height/2);
    _spriteWin.scale=mScale;
    [self addChild:_spriteWin];
    [_btnRestart removeFromParentAndCleanup:YES];
    self.btnRestart=[CCSprite spriteWithFile:@"begin again button.png"];
    _btnRestart.position=ccp(_spriteWin.position.x+_spriteWin.contentSize.width*mScale/2-_btnRestart.contentSize.width*mScale/2-50,_spriteWin.position.y-_spriteWin.contentSize.height*mScale/2+_btnRestart.contentSize.height*mScale/2+20);
    _btnRestart.scale=mScale;
    [self addChild:_btnRestart];
    
}
-(void)showLoseScreen{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [_spriteWin removeFromParentAndCleanup:YES];
    self.spriteWin=[CCSprite spriteWithFile:@"lose noti.png"];
    _spriteWin.position=ccp(winSize.width/2-70,winSize.height/2);
    _spriteWin.scale=mScale;
    [self addChild:_spriteWin];
    [_btnRestart removeFromParentAndCleanup:YES];
    self.btnRestart=[CCSprite spriteWithFile:@"begin again button.png"];
    _btnRestart.position=ccp(_spriteWin.position.x+_spriteWin.contentSize.width*mScale/2-_btnRestart.contentSize.width*mScale/2-50,_spriteWin.position.y-_spriteWin.contentSize.height*mScale/2+_btnRestart.contentSize.height*mScale/2+20);
    _btnRestart.scale=mScale;
    [self addChild:_btnRestart];
    [self unschedule:@selector(resetBG)];
    _bg2.zOrder=-1;
    _bg.zOrder=-2;
}
- (void)update:(ccTime)dt {
    
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		for (CCSprite *target in _targets) {
//			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2),
//										   target.position.y - (target.contentSize.height/2),
//										   target.contentSize.width,
//										   target.contentSize.height);
            
			if (CGRectIntersectsRect(_player.boundingBox, target.boundingBox)) {
				[targetsToDelete addObject:target];
                [mDel playSound:E_SOUND_SUCCESS];
                [self addFlash:_player.position];
                countSuccess++;
                [self addLoadingProgress];
			}
		}
		
		for (CCSprite *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];
		}
		
		[targetsToDelete release];
	
}
-(void)addLoadingProgress{
    if(countSuccess>20)return;
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
-(void)addFlash:(CGPoint)pos{
    [self resetFlash];
    self.flash=[CCSprite spriteWithFile:@"flash.png"];
    _flash.position=ccp(pos.x,pos.y+35);
    _flash.scale=mScale;
    [self addChild:_flash];
    [self schedule:@selector(resetFlash) interval:0.5];
}
-(void)resetFlash{
    [_flash removeFromParentAndCleanup:YES];
    [self unschedule:@selector(resetFlash)];
}
-(void)addTarget {
    bool randomX=NO;
    NSString* fileName=[self getRandomTarget];
	CCSprite *target = [CCSprite spriteWithFile:fileName];
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    int actualX;
    if(randomX){
        int minX = target.contentSize.width*mScale/2;
        int maxX = winSize.width - target.contentSize.width*mScale-300;
        int rangeX = maxX - minX;
        actualX = (arc4random() % rangeX) + minX;
    }else{
        actualX= [self getPosXWithFile:fileName];
    }
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp( actualX,winSize.height + (target.contentSize.height*mScale/2)-50);
    target.scale=mScale;
	[self addChild:target];
	
	// Determine speed of the target
    float minDuration = 1.0;
    float maxDuration = 2.0;
    if(timer<=15){
        minDuration=0.5;
        maxDuration=1.0;
    }
	int rangeDuration = maxDuration - minDuration;
	float actualDuration = (arc4random() % rangeDuration) + minDuration;
	if(timer>=20){
        actualDuration=0.8;
    }else if(timer>=10){
        actualDuration=0.6;
    }else{
        actualDuration=0.4;
    }
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(actualX,target.contentSize.height*mScale/2+100)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[_targets addObject:target];
	
}
-(int)getPosXWithFile:(NSString*)file{
    if([file isEqualToString:@"ice.png"]){
        return 70;
    }else if([file isEqualToString:@"brush.png"]){
        return 270;
    }else if([file isEqualToString:@"mango.png"]){
        return 470;
    }else if([file isEqualToString:@"ice cream.png"]){
        return 670;
    }
    return 70;
}
-(void)spriteMoveFinished:(id)sender {
    
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
		
	}
	_bg2.zOrder=-1;
    _bg.zOrder=-2;
    [mDel playSound:E_SOUND_WRONG];
    [self schedule:@selector(resetBG) interval:1.0];
}
-(void)resetBG{
    [self unschedule:@selector(resetBG)];
	_bg2.zOrder=-2;
    _bg.zOrder=-1;
}
-(void)gameLogic:(ccTime)dt {
	
	[self addTarget];
	
}
-(NSString*)getRandomTarget{
    int i=arc4random()%4;
    switch (i) {
        case 0:
            return @"brush.png";
        case 1:
            return @"ice cream.png";
        case 2:
            return @"mango.png";
        case 3:
            return @"ice.png";
        default:
            break;
    }
    return @"ice.png";
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!onEntered){
        NSLog(@"wait a second");
        return NO;
    }
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    if (CGRectContainsPoint(_player.boundingBox, touchLocation)) {
            selfSprite = _player;
    }else{
        selfSprite=nil;
    }
}
- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGPoint retval = newPos;
    retval.x=self.position.x;
    retval.y=self.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (selfSprite) {
        CGPoint newPos = ccpAdd(selfSprite.position, translation);
        selfSprite.position = ccp(newPos.x,_playerY);
    } else {
//        CGPoint newPos = ccpAdd(self.position, translation);
//        self.position = [self boundLayerPos:newPos];
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!onEntered){
        NSLog(@"wait a second1");
        return ;
    }
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        [self selectSpriteForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    }
}
- (void)singleTouch1:(UITapGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    if (CGRectContainsPoint(_btnRestart.boundingBox, touchLocation)) {
        onEntered=NO;
        [self btnRestartClicked];
    }
}
-(void)btnRestartClicked{
//    for(CCSprite*loading in _loading){
//        [loading removeFromParentAndCleanup:YES];
//    }
//    [_spiteTimer removeFromParentAndCleanup:YES];
//    CGSize winSize = [[CCDirector sharedDirector] winSize];
//    self.spiteTimer=[CCSprite spriteWithFile:@"30.png"];
//    _spiteTimer.position=ccp(winSize.width-_spiteTimer.contentSize.width*mScale*2/2-30,winSize.height-_spiteTimer.contentSize.height*mScale*2/2-70);
//    _spiteTimer.scale=mScale*2;
//    [self addChild:_spiteTimer];
//    [_loading removeAllObjects];
//    [_btnRestart removeFromParentAndCleanup:YES];
//    [_spriteWin removeFromParentAndCleanup:YES];
//    countSuccess=0;
//    timer=MAX_TIMER;
//    [self startSchedule];
    if(mDel.enableMusic){
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[StartLayer scene] withColor:ccWHITE]];
    [mDel openStartLayer];
//    [[CCDirector sharedDirector] popToRootScene];
}
@end
