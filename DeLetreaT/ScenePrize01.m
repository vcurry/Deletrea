//
//  ScenePrize01.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 15/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "ScenePrize01.h"
#import "Scene01.h"

#define ARC4RANDOM_MAX      0xFFFFFFFFu

@implementation ScenePrize01{
    SKSpriteNode *balloon;
    int contadorAciertos;
    float rotationCounter;
}

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundFiesta"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        background.zPosition=-3;
        [self addChild: background];
        
        //BackButton to improve JUST TEST MODE
        SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"rButton"];
        backButton.name = @"backButton";
        backButton.position = CGPointMake(size.width-backButton.size.width, size.height-backButton.size.height);
        backButton.zPosition=3;
        [self addChild: backButton];

        
        contadorAciertos = 0;
        
        float duration = 1.0f;
        rotationCounter = 0.5;
        [self runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction performSelector:@selector(spawnBalloon) onTarget:self],[SKAction waitForDuration:duration]]] count:50]];
        
     /**   SKSpriteNode *balloon1 = [SKSpriteNode spriteNodeWithImageNamed:@"balloon00"];
        balloon1.position = CGPointMake(self.size.width-balloon1.size.width/2, 100);
        [self addChild:balloon1];*/
        
        [NSTimer scheduledTimerWithTimeInterval:57 target:self selector:@selector(showScore) userInfo:nil repeats:NO];
    }
    return self;
}

-(void)spawnBalloon{
    CGFloat randomNumber = ((float)rand() / RAND_MAX) * 5;
    float duration = 3 + arc4random_uniform(8 - 3 + 1);
    
    NSString *balloonName = [NSString stringWithFormat:@"balloon0%.0f", randomNumber];
    NSString *balloonImage = [NSString stringWithFormat:@"%@_0", balloonName];
    balloon = [SKSpriteNode spriteNodeWithImageNamed:balloonImage];
    balloon.name = balloonName;

    balloon.position = CGPointMake((balloon.size.width/2+arc4random_uniform(self.size.width-balloon.size.width)), -balloon.size.height);
    [self addChild:balloon];

    SKAction *actionMove = [SKAction moveTo:CGPointMake(balloon.position.x, self.size.height+balloon.size.height/2) duration:duration];
    SKAction *actionRemove = [SKAction removeFromParent];
    [balloon runAction:[SKAction sequence:@[actionMove,actionRemove]]];

    rotationCounter = -rotationCounter;
    SKAction *rotateForth = [SKAction rotateToAngle:rotationCounter duration:2.5];
    SKAction *rotateBack = [SKAction rotateToAngle:-rotationCounter duration:2.5];
    SKAction *rotate = [SKAction sequence:@[rotateForth,rotateBack]];
    [balloon runAction:rotate];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKSpriteNode *selectedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        if([selectedNode.name isEqualToString:@"backButton"]){
            Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            // Present the scene.
            [self.view presentScene:scene];
        }

        if ([selectedNode.name containsString:@"balloon"]) {
          NSLog(@"touched");
            NSMutableArray *textures = [NSMutableArray array];
            for (int i=1; i<5; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@_%d",selectedNode.name,i];
                SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
                [textures addObject:texture];
            }
            SKAction *explode = [SKAction animateWithTextures:textures timePerFrame:0.01];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *endTouchedBalloon = [SKAction sequence:@[explode,remove]];
            [selectedNode runAction:endTouchedBalloon];
           // [selectedNode removeAllActions];
          //  [selectedNode removeFromParent];
            contadorAciertos+=1;
        }
    }
}

-(void)showScore{
    NSLog(@"puntuacion %d",contadorAciertos);
    SKLabelNode *etiqueta = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    NSString *scoreText;
    UIColor *textColor;
    if (contadorAciertos < 30) {
        scoreText = [NSString stringWithFormat:@"¡Sólo %d! Puedes hacerlo mejor", contadorAciertos];
        textColor = [UIColor orangeColor];
    } else if (contadorAciertos < 40) {
        scoreText = [NSString stringWithFormat:@"¡%d globos! Muy bien", contadorAciertos];
        textColor = [UIColor colorWithRed:26.0/255.0 green:155.0/255.0 blue:222.0/255.0 alpha:1.0];
    } else if (contadorAciertos < 50) {
        scoreText = [NSString stringWithFormat:@"¡%d globos! Casi los explotas todos", contadorAciertos];
        textColor = [UIColor greenColor];
    } else if (contadorAciertos == 50) {
        scoreText = [NSString stringWithFormat:@"¡%d globos! Genial, no quedó ni uno", contadorAciertos];
        textColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    }
    etiqueta.fontColor = textColor;
    etiqueta.text = scoreText;
    etiqueta.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:etiqueta];
    SKAction *rotate = [SKAction rotateToAngle:M_PI*2 duration:1];
    [etiqueta runAction:rotate];
    
    [self setUserInteractionEnabled:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];

}

-(void) nextScene {
    Scene01 *scene=[[Scene01 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition=[SKTransition fadeWithColor:[UIColor whiteColor] duration:1];
    [self.view presentScene:scene transition:sceneTransition];

}
@end
