//
//  ScenePrize02.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 15/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "ScenePrize02.h"
#import "Scene01.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end


@implementation ScenePrize02{
    int contador;
}

-(void)didMoveToView:(SKView *)view {
    contador=0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    if([touchedNode.name isEqualToString:@"backButton"]){
        Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:scene];
    }
    if (contador<7 && [touchedNode.name isEqualToString:@"difference"]) {
        contador += 1;
        SKSpriteNode *found = [SKSpriteNode spriteNodeWithImageNamed:@"found"];
        found.position = touchedNode.position;
        found.zPosition = 2;
        [self addChild:found];
        touchedNode.name = nil;
        NSLog(@"encontrado");
    }
    if(contador >= 7) {
        SKLabelNode *etiqueta = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        etiqueta.fontColor = [UIColor yellowColor];
        etiqueta.text = @"¡Genial! Encontraste las 8 diferencias";
        etiqueta.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:etiqueta];
        SKAction *rotate = [SKAction rotateToAngle:M_PI*2 duration:1];
        [etiqueta runAction:rotate];
        
    }
}

@end
