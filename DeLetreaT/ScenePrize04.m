//
//  ScenePrize04.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 15/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "ScenePrize04.h"
#import "AppDelegate.h"
#import "Aguja.h"
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

@implementation ScenePrize04{
    AppDelegate *delegado;
//    SKSpriteNode *needle;
    SKSpriteNode *readyButton;
    SKSpriteNode *train;
    NSMutableArray *needles;
    //SKSpriteNode *needle;
}

-(void)didMoveToView:(SKView *)view {
    
    delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    train = (SKSpriteNode *)[self childNodeWithName:@"train"];
//    train.hidden = YES;
    needles = [NSMutableArray array];
    
    for (Aguja *aguja in delegado.agujas) {
        SKSpriteNode *needle = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        needle.zRotation = aguja.zRotate;
        needle.position = aguja.position;
        needle.anchorPoint = CGPointZero;
        needle.name = @"needle";
        [needles addObject:needle];
        [self addChild:needle];
    }
    
    readyButton = [SKSpriteNode spriteNodeWithImageNamed:@"plus"];
    readyButton.position = CGPointMake(self.size.width-50, 80);
    [self addChild:readyButton];
    
    
 //   SKSpriteNode *vagon = (SKSpriteNode *)[self childNodeWithName:@"vagon"];
 //   SKPhysicsJointPin *pin = [SKPhysicsJointPin jointWithBodyA:train.physicsBody bodyB:vagon.physicsBody anchor:CGPointMake(train.position.x, train.position.y)];
   // [self.physicsWorld addJoint:pin];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    Aguja *aguja;
//    NSLog(@"aguja num %@ gradoR %f grado %f", aguja.num, aguja.angleR, aguja.angle);
    for(UITouch *touch in touches){
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if([node.name isEqualToString:@"backButton"]){
            Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            // Present the scene.
            [self.view presentScene:scene];
        }
        if([node.name containsString:@"needle"]){
            int index = [needles indexOfObject:node];
            aguja = [delegado.agujas objectAtIndex:index];
        }
        if ([node.name isEqualToString:@"needle"]) {
            SKAction *turn = [SKAction rotateToAngle:aguja.angleR duration:0.5];
            [node runAction:turn];
            NSLog(@"rotamos a %f", aguja.angleR);
            node.name = @"needleR";
        } else if ([node.name isEqualToString:@"needleR"]){
            SKAction *turnBack = [SKAction rotateToAngle:aguja.angle duration:0.5];
            [node runAction:turnBack];
            NSLog(@"rotamos a %f", aguja.angle);
            node.name = @"needle";
        } else if ([node isEqual:readyButton]){
            [self buildPath];
        }
    }
}

-(void)buildPath{
    
    int contadorAgujas = 0;
   // Aguja *aguja = [delegado.agujas objectAtIndex:contadorAgujas];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    SKSpriteNode *rail00 = (SKSpriteNode *)[self childNodeWithName:@"rail00"];
    SKSpriteNode *rail01 = (SKSpriteNode *)[self childNodeWithName:@"rail01"];
    SKSpriteNode *rail02 = (SKSpriteNode *)[self childNodeWithName:@"rail02"];
    SKSpriteNode *rail03 = (SKSpriteNode *)[self childNodeWithName:@"rail03"];
    SKSpriteNode *rail04 = (SKSpriteNode *)[self childNodeWithName:@"rail04"];
    SKSpriteNode *rail05 = (SKSpriteNode *)[self childNodeWithName:@"rail05"];
    SKSpriteNode *rail06 = (SKSpriteNode *)[self childNodeWithName:@"rail06"];
    SKSpriteNode *rail07 = (SKSpriteNode *)[self childNodeWithName:@"rail07"];
    SKSpriteNode *rail08 = (SKSpriteNode *)[self childNodeWithName:@"rail08"];
    SKSpriteNode *rail09 = (SKSpriteNode *)[self childNodeWithName:@"rail09"];
    SKSpriteNode *rail10 = (SKSpriteNode *)[self childNodeWithName:@"rail10"];
    SKSpriteNode *rail11 = (SKSpriteNode *)[self childNodeWithName:@"rail11"];
    SKSpriteNode *rail12 = (SKSpriteNode *)[self childNodeWithName:@"rail12"];
    SKSpriteNode *rail13 = (SKSpriteNode *)[self childNodeWithName:@"rail13"];
    SKSpriteNode *rail14 = (SKSpriteNode *)[self childNodeWithName:@"rail14"];
    SKSpriteNode *rail15 = (SKSpriteNode *)[self childNodeWithName:@"rail20"];
    SKSpriteNode *rail16 = (SKSpriteNode *)[self childNodeWithName:@"rail21"];
    SKSpriteNode *rail17 = (SKSpriteNode *)[self childNodeWithName:@"rail22"];
    
    [path moveToPoint:CGPointMake(rail00.position.x-(rail00.size.width),rail00.position.y)];
    
    SKSpriteNode *needle = [needles objectAtIndex:contadorAgujas];
    if ([needle.name isEqualToString:@"needleR"]) {
        //Aguja0
        [path addArcWithCenter:CGPointMake(rail00.position.x+(rail00.size.width/2), rail00.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
        [path addLineToPoint:CGPointMake(rail15.position.x-(rail15.size.width/2)-28, rail15.position.y-28)];
        [path addArcWithCenter:CGPointMake(rail15.position.x-(rail15.size.width/2), rail15.position.y-28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
        [path addLineToPoint:CGPointMake(rail15.position.x+(rail15.size.width/2), rail15.position.y)];
        [path addArcWithCenter:CGPointMake(rail15.position.x+(rail15.size.width/2), rail15.position.y-28) radius:28 startAngle:M_PI/2 endAngle:3*M_PI/2 clockwise:NO];
        [path addLineToPoint:CGPointMake(rail15.position.x-(rail15.size.width/2), rail15.position.y-56)];
        NSLog(@"Llegado con R");
    } else {
        [path addLineToPoint:CGPointMake(rail01.position.x+(rail01.size.width/2), rail01.position.y)];
        contadorAgujas+=1;
        needle = [needles objectAtIndex:contadorAgujas];
        if ([needle.name isEqualToString:@"needleR"]) {
            //Aguja1
            [path addArcWithCenter:CGPointMake(rail01.position.x+(rail01.size.width/2), rail01.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
            [path addArcWithCenter:CGPointMake(rail16.position.x-(rail16.size.width/2), rail16.position.y-28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
            [path addLineToPoint:CGPointMake(rail16.position.x+(rail16.size.width/2), rail16.position.y)];
        } else {
            [path addLineToPoint:CGPointMake(rail02.position.x+(rail02.size.width/2), rail02.position.y)];
            [path addArcWithCenter: CGPointMake(rail02.position.x+(rail02.size.width/2), rail02.position.y+56) radius:56 startAngle:3*M_PI/2 endAngle:M_PI/2 clockwise:YES];
            [path addLineToPoint:CGPointMake(rail03.position.x-(rail03.size.width/2), rail03.position.y)];
            [path addArcWithCenter:CGPointMake(rail03.position.x-(rail03.size.width/2), rail03.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:M_PI clockwise:NO];
            contadorAgujas+=1;
            needle = [needles objectAtIndex:contadorAgujas];
            if ([needle.name isEqualToString:@"needleR"]){
                //Aguja2
                [path addArcWithCenter:CGPointMake(rail03.position.x-(rail03.size.width/2), rail03.position.y+28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                [path addArcWithCenter:CGPointMake(rail03.position.x-(rail03.size.width/2), rail03.position.y+42) radius:14 startAngle:M_PI/2 endAngle:0 clockwise:NO];
                [path addArcWithCenter:CGPointMake(rail17.position.x-(rail17.size.width/2), rail17.position.y+14) radius:14 startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
                [path addLineToPoint:CGPointMake(rail17.position.x+(rail17.size.width/2), rail17.position.y)];
                [path addArcWithCenter:CGPointMake(rail17.position.x+(rail17.size.width/2), rail17.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
                [path addLineToPoint:CGPointMake(rail17.position.x+(rail17.size.width/2)+28, rail17.position.y+252)];
                [path addArcWithCenter:CGPointMake(rail17.position.x+(rail17.size.width/2), rail17.position.y+280) radius:28 startAngle:0 endAngle:M_PI/2 clockwise:YES];
            } else {
                [path addArcWithCenter:CGPointMake(rail03.position.x-(rail03.size.width/2)-56, rail03.position.y+28) radius:28 startAngle:0 endAngle:M_PI/2 clockwise:YES];
                contadorAgujas+=1;
                needle = [needles objectAtIndex:contadorAgujas];
                if([needle.name isEqualToString:@"needleR"]){
                    //Aguja3
                    [path addLineToPoint:CGPointMake(rail04.position.x-(rail04.size.width/2)+28, rail04.position.y)];
                    [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2)+28, rail04.position.y+14) radius:14 startAngle:3*M_PI/2 endAngle:M_PI/2 clockwise:NO];
                    [path addLineToPoint:CGPointMake(rail04.position.x+(rail04.size.width/3)+28, rail04.position.y+28)];
                } else {
                    [path addLineToPoint:CGPointMake(rail04.position.x-(rail04.size.width/2), rail04.position.y)];
                    [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2), rail04.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:M_PI clockwise:NO];
                    contadorAgujas+=1;
                    needle = [needles objectAtIndex:contadorAgujas];
                    if([needle.name isEqualToString:@"needleR"]){
                        //Aguja4
                        [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2)-56, rail04.position.y+28) radius:28 startAngle:0 endAngle:M_PI clockwise:YES];
                        [path addLineToPoint:CGPointMake(rail04.position.x-(rail04.size.width/2)-84, rail04.position.y-80)];
                    } else {
                        [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2), rail04.position.y+28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                        contadorAgujas+=1;
                        needle = [needles objectAtIndex:contadorAgujas];
                        if([needle.name isEqualToString:@"needleR"]){
                            //Aguja5
                            [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2), rail04.position.y+84) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
                            [path addArcWithCenter:CGPointMake(rail04.position.x-(rail04.size.width/2)+56, rail04.position.y+84) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                            [path addLineToPoint:CGPointMake(rail04.position.x+(rail04.size.width/2)-60, rail04.position.y+112)];

                        } else {
                            [path addLineToPoint:CGPointMake(rail05.position.x+(rail05.size.width/2), rail05.position.y)];
                            [path addArcWithCenter:CGPointMake(rail05.position.x+(rail05.size.width/2), rail05.position.y-28) radius:28 startAngle:M_PI/2  endAngle:0 clockwise:NO];
                            [path addArcWithCenter:CGPointMake(rail05.position.x+(rail05.size.width/2)+56, rail05.position.y-28) radius:28 startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
                            [path addLineToPoint:CGPointMake(rail06.position.x+(rail06.size.width/2), rail06.position.y)];
                            [path addArcWithCenter:CGPointMake(rail06.position.x+(rail06.size.width/2), rail06.position.y+84) radius:84 startAngle:3*M_PI/2 endAngle:M_PI/2 clockwise:YES];
                            [path addLineToPoint:CGPointMake(rail07.position.x-(rail07.size.width/2), rail07.position.y)];
                            [path addArcWithCenter:CGPointMake(rail07.position.x-(rail07.size.width/2), rail07.position.y-28) radius:28 startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
                            [path addArcWithCenter:CGPointMake(rail08.position.x+(rail08.size.width/2), rail08.position.y+28) radius:28 startAngle:0 endAngle:3*M_PI/2 clockwise:NO];
                            [path addLineToPoint:CGPointMake(rail08.position.x-(rail08.size.width/2), rail08.position.y)];
                            [path addArcWithCenter:CGPointMake(rail08.position.x-(rail08.size.width/2), rail08.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:M_PI/2 clockwise:NO];
                            [path addLineToPoint:CGPointMake(rail09.position.x+(rail09.size.width), rail09.position.y)];
                            [path addArcWithCenter:CGPointMake(rail09.position.x+(rail09.size.width), rail09.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
                            contadorAgujas+=1;
                            needle = [needles objectAtIndex:contadorAgujas];
                            if ([needle.name isEqualToString:@"needleR"]){
                                //Aguja6
                                [path addArcWithCenter:CGPointMake(rail09.position.x+(rail09.size.width)+56, rail09.position.y+28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                                [path addLineToPoint:CGPointMake(rail10.position.x+(rail10.size.width*1.2)+56, rail10.position.y)];

                            } else {
                                [path addArcWithCenter:CGPointMake(rail09.position.x+(rail09.size.width), rail09.position.y+28) radius:28 startAngle:0 endAngle:M_PI/2 clockwise:YES];
                                [path addLineToPoint:CGPointMake(rail10.position.x-(rail10.size.width/2), rail10.position.y)];
                                [path addArcWithCenter:CGPointMake(rail10.position.x-(rail10.size.width/2), rail10.position.y-28) radius:28 startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
                                [path addArcWithCenter:CGPointMake(rail11.position.x+(rail11.size.width/2), rail11.position.y+28) radius:28 startAngle:0 endAngle:3*M_PI/2 clockwise:NO];
                                [path addLineToPoint:CGPointMake(rail11.position.x-(rail11.size.width/2), rail11.position.y)];
                                [path addArcWithCenter:CGPointMake(rail11.position.x-(rail11.size.width/2), rail11.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:M_PI clockwise:NO];
                                [path addLineToPoint:CGPointMake(rail11.position.x-(rail11.size.width/2)-28, rail11.position.y+56)];
                                [path addArcWithCenter:CGPointMake(rail11.position.x-(rail11.size.width/2), rail11.position.y+84) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                                [path addLineToPoint:CGPointMake(rail11.position.x+(rail11.size.width/2), rail11.position.y+112)];
                                contadorAgujas+=1;
                                needle = [needles objectAtIndex:contadorAgujas];
                                if([needle.name isEqualToString:@"needleR"]){
                                    //Aguja7
                                    [path addLineToPoint:CGPointMake(rail12.position.x+60, rail13.position.y)];
                                } else {
                                    [path addArcWithCenter:CGPointMake(rail11.position.x+(rail11.size.width/2), rail11.position.y+140) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
                                    [path addArcWithCenter:CGPointMake(rail12.position.x-(rail12.size.width/2), rail12.position.y-28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                                    [path addLineToPoint:CGPointMake(rail12.position.x+(rail12.size.width/2), rail12.position.y)];
                                    [path addArcWithCenter:CGPointMake(rail12.position.x+(rail12.size.width/2), rail12.position.y-28) radius:28 startAngle:M_PI/2 endAngle:0 clockwise:NO];
                                    [path addLineToPoint:CGPointMake(rail13.position.x-(rail13.size.width/2)-28, rail13.position.y+28)];
                                    [path addArcWithCenter:CGPointMake(rail13.position.x-(rail13.size.width/2), rail13.position.y+28) radius:28 startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
                                    [path addLineToPoint:CGPointMake(rail13.position.x+(rail13.size.width/2), rail13.position.y)];
                                    contadorAgujas+=1;
                                    needle = [needles objectAtIndex:contadorAgujas];
                                    if([needle.name isEqualToString:@"needleR"]){
                                        [path addLineToPoint:CGPointMake(rail14.position.x+(rail14.size.width/2), rail13.position.y)];
                                    }
                                    [path addArcWithCenter:CGPointMake(rail13.position.x+(rail13.size.width/2), rail13.position.y+28) radius:28 startAngle:3*M_PI/2 endAngle:0 clockwise:YES];
                                    [path addArcWithCenter:CGPointMake(rail14.position.x-(rail14.size.width/2), rail14.position.y-28) radius:28 startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                                    [path addLineToPoint:CGPointMake(rail14.position.x+(rail14.size.width/2), rail14.position.y)];
                                }
                            }
                        }
                    }
                }
            }

        NSLog(@"LLegado");
    }

}
    [self setTrainInMotion: path];
}

-(void)setTrainInMotion: (UIBezierPath *) path{
  //  SKSpriteNode *train = (SKSpriteNode *)[self childNodeWithName:@"train"];
    SKSpriteNode *vagon = (SKSpriteNode *)[self childNodeWithName:@"vagon"];

    
    train.hidden=NO;
    
     SKAction *move = [SKAction followPath:[path CGPath] asOffset:false orientToPath:true speed:100];
     move.timingMode = SKActionTimingEaseInEaseOut;
     
     [train runAction:move completion:^{
     NSLog(@"train x: %f, y: %f", train.position.x,train.position.y);
         ScenePrize04 *scene = [ScenePrize04 unarchiveFromFile:@"ScenePrize04"];
         scene.scaleMode = SKSceneScaleModeAspectFill;
         [self.view presentScene:scene];

     }];
     
     
     SKShapeNode *line = [SKShapeNode node];
     line.path = [path CGPath];
     [line setStrokeColor:[UIColor whiteColor]];
     //  line.position = self.position;
     [self addChild:line];
    

}

@end
