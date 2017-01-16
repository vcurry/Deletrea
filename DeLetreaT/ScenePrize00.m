//
//  ScenePrize00.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 15/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "ScenePrize00.h"
#import "Scene01.h"
#import "AppDelegate.h"
#import "Pieza.h"

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

@implementation ScenePrize00{
    NSMutableArray *pieces;
    NSArray *correctPieces;
    SKSpriteNode *puzzlePiece;
    SKSpriteNode *touchedNode;
    AppDelegate *delegado;
    Pieza *correctPiece;
   // CGPoint iniPosition;
  //  CGPoint correctPosition;
    CGPoint touchPoint;
    int contador;
}


//@synthesize physicsBody;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    pieces = [NSMutableArray array];
    for (int i=0; i<16; i++) {
        NSString *pieceName=[NSString stringWithFormat:@"piece%02d", i+1];
        puzzlePiece=(SKSpriteNode *)[self childNodeWithName:pieceName];
        puzzlePiece.zPosition = 1;
        puzzlePiece.name = pieceName;
        [pieces addObject:puzzlePiece];
    }
    correctPieces = delegado.puzzle;
 //   Pieza *p=[correctPieces objectAtIndex:0];
 //   NSLog(@"pieza 0 nombre: %@",p.name);
    contador=0;
    NSLog(@"printing size sceneprize00 %f, %f", self.size.height, self.size.width);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [self selectNodeForTouch:location];
       // NSLog(@"Posicion correcta: %f,%f", correctPiece.correctPosition.x,correctPiece.correctPosition.y);
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touchedNode.position=[[touches anyObject] locationInNode:self];
}

/**
 * when the touches are correct until the wolf, it transitions to the next scene.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint endPosition=[[touches anyObject] locationInNode:self];

                    NSLog(@"Posicion correcta: %f,%f", correctPiece.correctPosition.x,correctPiece.correctPosition.y);
            //      NSLog(@"Posicion usuario: %f,%f", selectedNode.position.x,selectedNode.position.y);
    if ([self cercano:endPosition a:correctPiece.correctPosition]) {
        touchedNode.position=correctPiece.correctPosition;
        contador+=1;
        touchedNode.userInteractionEnabled = YES;
    }else{
        touchedNode.position=correctPiece.iniPosition;
    }
    
    if (contador==16) {
        touchedNode.position=correctPiece.correctPosition;
        contador+=1;
        touchedNode.zPosition=1;
        touchedNode=nil;
        [touchedNode removeFromParent];
        Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:scene];
    }
    
    touchedNode.zPosition=1;
    touchedNode=nil;
}


-(void)selectNodeForTouch:(CGPoint)location{
    SKSpriteNode *selectedNode = (SKSpriteNode *)[self nodeAtPoint:location];
   // iniPosition = CGPointMake(588, 1091);
    if([selectedNode.name isEqualToString:@"backButton"]){
        Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Present the scene.
        [self.view presentScene:scene];
    }
    for (int i=0; i<16; i++) {
        SKSpriteNode *piece=[pieces objectAtIndex:i];
        if ([selectedNode.name isEqualToString:piece.name]) {
            touchedNode = piece;
           // touchedNode.position = touchPoint;
            touchedNode.zPosition = 16;
            touchedNode.physicsBody.velocity=CGVectorMake(0, 0);
            touchedNode.physicsBody.angularVelocity = 0;
            NSLog(@"importado puzzle? %lu", (unsigned long)delegado.puzzle.count);
            correctPiece = [correctPieces objectAtIndex:i];
            NSLog(@"touched: %@ correct: %@", touchedNode.name, correctPiece.name);
          //  correctPosition = CGPointMake(correctPiece.posx, correctPiece.posy);
        }
    }
}

/**
 * checks if the points the user chooses are near enaough to the correct point
 **/
-(BOOL) cercano:(CGPoint)R1 a:(CGPoint)R2{
    const int OFFSET = 30;
    if(R1.x>=R2.x-OFFSET && R1.x<=R2.x+OFFSET && R1.y>=R2.y-OFFSET && R1.y<=R2.y+OFFSET){
        return YES;
    }
    return NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


@end
