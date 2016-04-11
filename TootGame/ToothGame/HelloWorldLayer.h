//
//  HelloWorldLayer.h
//  jigsaw puzzle
//
//  Created by Jury on 4/3/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
typedef enum{
    E_MODE_EASY=0,
    E_MODE_NORMAL,
    E_MODE_HARD
}ENUM_MODE;
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
