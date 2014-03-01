//
//  HelloWorldLayer.h
//  demo_01
//
//  Created by llbt_wgh on 14-2-26.
//  Copyright llbt 2014年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer 
{
    CCArray * _enemySprites;
    CGPoint _playerVelocity;
    
    BOOL _isTouchToShoot;
    CCSprite *_bulletSprite;

    CCLabelTTF *_lifeLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_gameEndLabel;
    int     _totalLives;
    int     _totalScore;
    
}
-(void)spawnEnemy;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(CCSprite *)getAvailableEnemySprite;
-(void) updatePlayerPosition:(ccTime)dt;
-(void) bulletFinishedMoving:(id)sender;
-(void) updatePlayerShooting:(ccTime)dt;
-(CGRect) rectOfSprite:(CCSprite*)sprite;
-(void) collisionDetection:(ccTime)dt;
-(void) updateHUD:(ccTime)dt;
@end
