//
//  HelloWorldLayer.m
//  demo_01
//
//  Created by llbt_wgh on 14-2-26.
//  Copyright llbt 2014年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

enum{
    kTagPalyer = 1,
};
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
    
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bgSprite  = [CCSprite spriteWithFile:@"background_1.jpg"];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite z:0];
        
        CCSprite *playerSprite = [CCSprite spriteWithFile:@"hero_1.png"];
        playerSprite.position = CGPointMake(winSize.width/2, playerSprite.contentSize.height/2+20);
        [self addChild:playerSprite z:4 tag:kTagPalyer];
        
//        CCAction *jump = [CCJumpTo actionWithDuration:40 position:ccp(winSize.width-100, winSize.height/3) height:50 jumps:30];

//        [playerSprite runAction:jump];
//        CCAction *jumpBy = [CCJumpBy actionWithDuration:5 position:ccp(200, 100) height:60 jumps:60];
//        [playerSprite runAction:jumpBy];
        
//        ccBezierConfig  c = {ccp(300,200),ccp(50, 50),ccp(-50, -50)};
//        [playerSprite runAction:[CCBezierTo actionWithDuration:3 bezier:c]];
//        [playerSprite runAction:[CCBezierBy actionWithDuration:3 bezier:c]];

//        [playerSprite runAction:[CCPlace actionWithPosition:ccp(200, 200)]];
        
        
//        [playerSprite runAction:[CCScaleTo actionWithDuration:3 scale:.2]];
//        [playerSprite runAction:[CCRotateTo actionWithDuration:2 angle:270]];
//        [playerSprite runAction:[CCToggleVisibility action]];
        
//        [playerSprite runAction:[CCBlink actionWithDuration:4 blinks:10]];
        
//        [playerSprite runAction:[CCFlipY actionWithFlipY:YES]];
        
//        CCAction *action = [CCSpawn actions:[CCFadeOut actionWithDuration:5],[CCScaleTo actionWithDuration:5 scale:5],[CCFadeIn actionWithDuration:5], nil];
//        [playerSprite runAction:action];
        
        CCAction *scale  = [CCScaleTo actionWithDuration:5 scale:1];
//        [playerSprite runAction:scale];
//        CCFiniteTimeAction *action  = [CCSequence actions:[CCFadeIn actionWithDuration:2],[CCBlink actionWithDuration:1 blinks:3], nil];
//        [playerSprite runAction:action];
        
//        id action = [CCMoveBy actionWithDuration:2 position:ccp(100, 0)];
//        [playerSprite runAction:[CCRepeatForever actionWithAction:action]];
        
        
//        id easeAction  = [CCEaseBounceOut actionWithAction:[CCMoveTo actionWithDuration:2 position:ccp(100+winSize.width/2, winSize.height/2)]];
//        id action  = [CCSequence actions:easeAction,[CCScaleTo actionWithDuration:2 scale:2], nil];
//        [playerSprite runAction:action];
        
        _enemySprites = [[CCArray alloc]init];
        
        const int NUM_OF_ENEMIES = 100;
        for (int i=0; i<NUM_OF_ENEMIES; i++) {
            CCSprite *enemySprite = [CCSprite spriteWithFile:@"enemy1.png"];
            enemySprite.position = ccp(0, winSize.height+enemySprite.contentSize.height+10);
            enemySprite.visible = NO;
            [self addChild:enemySprite z:4];
            [_enemySprites addObject:enemySprite];
        }
        
        [self performSelector:@selector(spawnEnemy)
                   withObject:nil
                   afterDelay:1.0f];
        
        self.isAccelerometerEnabled = YES;
        
        [self scheduleUpdate];
		
        self.isTouchEnabled = YES;
        _isTouchToShoot = NO;
        
        _bulletSprite = [CCSprite spriteWithFile:@"bullet1.png"];
        _bulletSprite.visible = NO;
        [self addChild:_bulletSprite z:4];
        
        //11.add audio support
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bullet.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_music.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
        
        
        CCLabelTTF *lifeIndicator = [CCLabelTTF labelWithString:@" 生命值 :" fontName:@"Arial" fontSize:20];
        lifeIndicator.anchorPoint = ccp(0.0,0.5);
        lifeIndicator.position = ccp(20,winSize.height - 20);
        [self addChild:lifeIndicator z:10];
        
        _lifeLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Arial" fontSize:20]; _lifeLabel.position = ccpAdd(lifeIndicator.position, ccp(lifeIndicator. contentSize.width+10,0));
        [self addChild:_lifeLabel z:10];
        
        CCLabelTTF *scoreIndicator = [CCLabelTTF labelWithString:@" 分数:" fontName:@"Arial" fontSize:20];
        scoreIndicator.anchorPoint = ccp(0.0,0.5f);
        scoreIndicator.position = ccp(winSize.width - 100,winSize.height - 20);
        [self addChild:scoreIndicator z:10];
        
        _scoreLabel = [CCLabelTTF labelWithString:@"00" fontName:@"Arial" fontSize:20];
        _scoreLabel.position = ccpAdd(scoreIndicator.position, ccp(scoreIndicator. contentSize.width,0));
        [self addChild:_scoreLabel z:10];
        
        _totalLives = 3;
        _totalScore = 0;
        
        _gameEndLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:40];
        _gameEndLabel.position = ccp(winSize.width/2,winSize.height/2);
        _gameEndLabel.visible = NO;
        [self addChild:_gameEndLabel z:10];
        
        
        
        
	}
	return self;
}
- (void)spawnEnemy
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *enemySprite  =[self getAvailableEnemySprite];
    
    float durationTime = arc4random()%4+1;
    
    id moveBy = [CCMoveBy actionWithDuration:durationTime position:ccp(0, -enemySprite.contentSize.height-enemySprite.position.y)];
    
    id callBack  = [CCCallBlockN actionWithBlock:^(id sender) {
        
        CCSprite *sp = (CCSprite *)sender;
        sp.visible= NO;
        sp.position = ccp(0,winSize.height + sp.contentSize.height + 10);

        CCLOG(@"reset enemy plane!");
        
    }];
    
    id action = [CCSequence actions:moveBy,callBack, nil];
    
    enemySprite.visible = YES;
    enemySprite.position = ccp(arc4random()%(int)(winSize.width-enemySprite.contentSize.width)+enemySprite.contentSize.width/2, enemySprite.position.y);
    
    [enemySprite runAction:action];
    
    [self performSelector:_cmd withObject:nil afterDelay:arc4random()%3+1];
    

    
}

-(CCSprite*) getAvailableEnemySprite{
    CCSprite *result = nil;
    CCARRAY_FOREACH(_enemySprites, result)
    {
        if (!result.visible) {
            break;
        }
    }
    return result;
}
- (void)update:(ccTime)delta
{
    [self updatePlayerPosition:delta];
    [self updatePlayerShooting:delta];
    [self collisionDetection:delta];
    [self updateHUD:delta];

}

-(void) updatePlayerPosition:(ccTime)dt{
    
    CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
    CGPoint pos = playerSprite.position;
    pos.x += _playerVelocity.x;
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    float imageWidthHavled = playerSprite.texture.contentSize.width * 0.5f;
    float leftBoderLimit = imageWidthHavled;
    float rightBoderLimit = screenSize.width - imageWidthHavled;
    
    if (pos.x < leftBoderLimit) {
        pos.x = leftBoderLimit;
        _playerVelocity = CGPointZero;
    }else if(pos.x > rightBoderLimit){
        pos.x = rightBoderLimit;
        _playerVelocity = CGPointZero;
    }
    
    playerSprite.position = pos;
}

-(void) bulletFinishedMoving:(id)sender
{
    _bulletSprite.visible = NO;
    _isTouchToShoot = NO;
}
#pragma mark - accelerometer callback
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
    float deceleration = 0.4f;
    float sensitivity = 6.0f;
    
    float maxVelocity = 100;
    
    _playerVelocity.x = _playerVelocity.x * deceleration + acceleration.x * sensitivity;
    if (_playerVelocity.x > maxVelocity) {
        _playerVelocity.x = maxVelocity;
    }else if(_playerVelocity.x < -maxVelocity){
        _playerVelocity.x = -maxVelocity;
    }
    
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"touch!");
    UITouch *touch = [touches anyObject];
    CCSprite *palyerSprite  = (CCSprite*)[self getChildByTag:kTagPalyer];
    CGPoint pt = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(palyerSprite.boundingBox, pt)) {
        _isTouchToShoot=YES;
    }
    
}

-(void) updatePlayerShooting:(ccTime)delta{
    if (_bulletSprite.visible || !_isTouchToShoot) {
        return;
    }
    
    CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
    CGPoint pos = playerSprite.position;
    
    CGPoint bulletPos = CGPointMake(pos.x,
                                    pos.y + playerSprite.contentSize.height/ 2 + _bulletSprite.contentSize.height);
    _bulletSprite.position = bulletPos;
    _bulletSprite.visible = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    id moveBy = [CCMoveBy actionWithDuration:1.0 position:ccp(0,winSize.height - bulletPos.y)];
    id callback = [CCCallFuncN actionWithTarget:self selector:@selector(bulletFinishedMoving:)];
    id ac = [CCSequence actions:moveBy,callback, nil];
    [_bulletSprite runAction:ac];
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"bullet.mp3"];
    CCLOG(@"_bulletSprite runAction");
}

-(CGRect) rectOfSprite:(CCSprite*)sprite{
    return CGRectMake(sprite.position.x - sprite.contentSize.width / 2,
                      sprite.position.y - sprite.contentSize.height /2,
                      sprite.contentSize.width, sprite.contentSize.height);
}
-(void) collisionDetection:(ccTime)dt
{
    CCSprite *enemy;
    CGRect bulletRect = [self rectOfSprite:_bulletSprite];
    CCARRAY_FOREACH(_enemySprites, enemy)
    {
        if (enemy.visible) {
            //1.bullet & enemy collision detection
            CGRect enemyRect = [self rectOfSprite:enemy];
            if (_bulletSprite.visible && CGRectIntersectsRect(enemyRect, bulletRect)) {
                enemy.visible = NO;
                _bulletSprite.visible = NO;
                
                _totalScore += 100;
                
                if (_totalScore >= 1000) {
                    [_gameEndLabel setString:@"游戏胜利！"];
                    _gameEndLabel.visible = YES;
                    
                    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
                    [_gameEndLabel runAction:scaleTo];
                    
                    [self unscheduleUpdate];
                    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:2.0f];
                }
                
                [_bulletSprite stopAllActions];
                [enemy stopAllActions];
                CCLOG(@"collision bullet");
                break;
            }
            
            //2.enemy & player collision detection
            CCSprite *playerSprite = (CCSprite*)[self getChildByTag:kTagPalyer];
            CGRect playRect = [self rectOfSprite:playerSprite];
            if (playerSprite.visible &&
                playerSprite.numberOfRunningActions == 0
                && CGRectIntersectsRect(enemyRect, playRect)) {
                enemy.visible = NO;
                
                _totalLives -= 1;
                
                if (_totalLives <= 0) {
                    [_gameEndLabel setString:@"游戏失败!"];
                    _gameEndLabel.visible = YES;
                    id scaleTo = [CCScaleTo actionWithDuration:1.0 scale:1.2f];
                    [_gameEndLabel runAction:scaleTo];
                    
                    [self unscheduleUpdate];
                    
                    [self performSelector:@selector(onRestartGame) withObject:nil afterDelay:3.0f];
                }
                
                id blink = [CCBlink actionWithDuration:2.0 blinks:4];
                [playerSprite stopAllActions];
                [playerSprite runAction:blink];
                CCLOG(@"collision player");
                break;
            }
        }
    }

}

- (void)onRestartGame
{
    CCTransitionFade *transitionScene  = [CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer scene] withColor:ccYELLOW];
    CCTransitionFadeTR *transitionScene1= [CCTransitionFadeTR transitionWithDuration:1 scene:[HelloWorldLayer scene]];
        [[CCDirector sharedDirector] replaceScene:transitionScene1];
    
}
-(void) updateHUD:(ccTime)dt{
    [_lifeLabel setString:[NSString stringWithFormat:@"%2d",_totalLives]];
    [_scoreLabel setString:[NSString stringWithFormat:@"%04d",_totalScore]];
}
-(void)draw
{
    [super draw];
    ccDrawColor4F(255, 0, 0, 0);
    glLineWidth(8);
    ccDrawLine(ccp(10, 10), ccp(200, 200));
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    [_enemySprites release];
    _enemySprites = nil;
}
-(void)onEnter
{
    [super onEnter];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
}

@end
