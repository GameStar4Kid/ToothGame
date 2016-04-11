//
//  AppDelegate.h
//  jigsaw puzzle
//
//  Created by Jury on 4/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
typedef enum{
    E_SOUND_BG,
    E_SOUND_ON_OFF,
    E_SOUND_TICK,
    E_SOUND_WRONG,
    E_SOUND_SUCCESS,
    E_SOUND_WIN,
    E_SOUND_LOSE
}ENUM_SOUND;
@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate,UIImagePickerControllerDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    UIPopoverController*popoverController;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic,strong) UIImage *photoImage;
@property (nonatomic) bool enableSound;
@property (nonatomic) bool enableMusic;
@property (nonatomic) float mScalePhone;
-(void)openIntroLayer;
-(void)openStartLayer;
-(void)openGameLayer;
-(void)playSound:(ENUM_SOUND)type;
@end
