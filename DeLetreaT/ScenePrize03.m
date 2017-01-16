//
//  ScenePrize03.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 15/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "ScenePrize03.h"
#import "AppDelegate.h"
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

@implementation ScenePrize03{
    NSMutableArray *caps;
    NSMutableArray *pants;
    NSMutableArray *tshirts;
//    NSMutableArray *clothes;
    
    NSMutableArray *correctClothes;
    NSMutableArray *playerClothes;
    int contador;
    
    NSMutableArray *clothesInDrawer;
    
    NSMutableArray *characters;
    SKSpriteNode *cat;
    SKSpriteNode *monkey;
    SKSpriteNode *panda;
    NSMutableArray *cats;
    NSMutableArray *monkeys;
    NSMutableArray *pandas;
    
    UILabel *progress;
    NSTimer *timer;
    int currentSecond;
    
    SKSpriteNode *drawer;
    SKSpriteNode *buttonCap;
    SKSpriteNode *buttonTshirt;
    SKSpriteNode *buttonPants;
    
    SKSpriteNode *touchedNode;

    AppDelegate *delegado;
    
    CGPoint iniPosition;
    
}

-(void)didMoveToView:(SKView *)view {
    [self setUserInteractionEnabled:NO];
    caps = [NSMutableArray array];
    pants = [NSMutableArray array];
    tshirts = [NSMutableArray array];
 //   clothes = [NSMutableArray arrayWithObjects:caps,tshirts,pants, nil];
    
    correctClothes = [NSMutableArray arrayWithCapacity:9];
    playerClothes = [NSMutableArray array];
    clothesInDrawer = [NSMutableArray array];
    contador = 0;
    
    cat = (SKSpriteNode *)[self childNodeWithName:@"cat"];
    monkey = (SKSpriteNode *)[self childNodeWithName:@"monkey"];
    panda = (SKSpriteNode *)[self childNodeWithName:@"panda"];
    characters = [NSMutableArray arrayWithObjects:cat,monkey,panda, nil];
    
    cats = [NSMutableArray array];
    monkeys = [NSMutableArray array];
    pandas = [NSMutableArray array];
    
    for (int i=0; i<4; i++) {
        NSString *cap = [NSString stringWithFormat:@"cap%d",i];
        [caps addObject:cap];
        NSString *pant = [NSString stringWithFormat:@"pants%d",i];
        [pants addObject:pant];
        NSString *tshirt = [NSString stringWithFormat:@"tshirt%d",i];
        [tshirts addObject:tshirt];
    }
    
    [self dressCharacters];
    
    progress = [[UILabel alloc] initWithFrame:CGRectMake(self.size.width/2, self.size.height/2-200, 100, 50)];
    progress.tag = 1001;
    progress.textColor = [UIColor whiteColor];
    progress.font = [UIFont fontWithName:@"Chalkduster" size:60];
    progress.text = @"15";
    [self.view addSubview:progress];
 //   currentMinute = 1;
    currentSecond = 15;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(flickClothes) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:16 target:self selector:@selector(play) userInfo:nil repeats:NO];

}

-(void)dressCharacters {
    delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SKSpriteNode *garment;
    
    for (int i=0; i<characters.count; i++) {
        for (int j=0; j<3; j++) {
            int randomNum = arc4random() % 4;
            NSString *garmentName;
            if (j==0) {
                garmentName =  [NSString stringWithFormat:@"cap%d",randomNum];
            } else if (j==1) {
                garmentName =  [NSString stringWithFormat:@"tshirt%d",randomNum];
            } else if (j==2) {
                garmentName =  [NSString stringWithFormat:@"pants%d",randomNum];
            }
            garment = [SKSpriteNode spriteNodeWithImageNamed:garmentName];
            garment.name = garmentName;
            garment.zPosition = 2;
            int index = correctClothes.count;
            NSValue *pos = [delegado.memory objectAtIndex:index];
            garment.position =[pos CGPointValue];
            [self addChild: garment];
            [correctClothes addObject:garment];
        }
    }

    
    for (int t=0; t<correctClothes.count; t++) {
        SKSpriteNode *cC = [correctClothes objectAtIndex:t];
        NSLog(@"correctClothes %d: %@",t,cC.name);
        [playerClothes addObject:cC];
    }
 //   playerClothes = correctClothes;
}

-(void)timerFired{
    if (currentSecond>=0) {
        if (currentSecond > 0) {
            currentSecond -= 1;
            if (currentSecond <= 10 && currentSecond > 5) {
                progress.textColor = [UIColor yellowColor];
            } else if (currentSecond <= 5) {
                progress.textColor = [UIColor redColor];
            }
        } else if (currentSecond == 0) {
            [progress removeFromSuperview];
            [timer invalidate];
        }

    }
    if (currentSecond > -1) {
        [progress setText:[NSString stringWithFormat:@"%02d", currentSecond]];
    } else {
        [timer invalidate];
    }
    
}

-(void)flickClothes{
    SKAction *hide = [SKAction hide];
    SKAction *show = [SKAction unhide];
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *flick = [SKAction sequence:@[hide,wait,show,wait,hide, wait,show,wait,wait,wait,hide]];
    for (int t=0; t<correctClothes.count; t++) {
        SKSpriteNode *cC = [correctClothes objectAtIndex:t];
        [cC runAction:flick];
    }
}

-(void)play {
    drawer = (SKSpriteNode *)[self childNodeWithName:@"drawer"];
    SKSpriteNode *cover = (SKSpriteNode *)[self childNodeWithName:@"drawerCover"];
    buttonCap = (SKSpriteNode *)[self childNodeWithName:@"buttonCap"];
    buttonTshirt = (SKSpriteNode *)[self childNodeWithName:@"buttonTshirt"];
    buttonPants = (SKSpriteNode *)[self childNodeWithName:@"buttonPants"];
    SKAction *showDrawer = [SKAction moveToX:self.size.width-60 duration:0.5];
    showDrawer.timingMode = SKActionTimingEaseInEaseOut;
    [drawer runAction:showDrawer];
    [cover runAction:showDrawer];
    [buttonCap runAction:showDrawer];
    [buttonTshirt runAction:showDrawer];
    [buttonPants runAction:showDrawer];
    [self setUserInteractionEnabled:YES];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        if([touchedNode.name isEqualToString:@"backButton"]){
            Scene01 *scene = [Scene01 sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            // Present the scene.
            [self.view presentScene:scene];
        }
        if ([buttonCap containsPoint:location]) {
            [self setClothesToChoose:caps];
        } else if ([buttonTshirt containsPoint:location]){
            [self setClothesToChoose:tshirts];
        } else if ([buttonPants containsPoint:location]){
            [self setClothesToChoose:pants];
        } else if ([clothesInDrawer containsObject:touchedNode]){
            iniPosition = touchedNode.position;
            touchedNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:touchedNode.size];
            touchedNode.physicsBody.affectedByGravity = NO;
            touchedNode.physicsBody.allowsRotation = NO;
            NSLog(@"touchedNode name %@",touchedNode.name);
        }
        // NSLog(@"Posicion correcta: %f,%f", correctPiece.correctPosition.x,correctPiece.correctPosition.y);
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([clothesInDrawer containsObject:touchedNode]){
            touchedNode.position = location;
            touchedNode.zPosition =4;
        }
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint endPosition=[[touches anyObject] locationInNode:self];

    if ([clothesInDrawer containsObject:touchedNode]) {
        for (int i = 0; i<characters.count; i++) {
            SKSpriteNode *character = [characters objectAtIndex:i];
            if ([character containsPoint:endPosition]) {
                [self putOnClothes:i :character];
            }
        }
        touchedNode.position = iniPosition;
        touchedNode.zPosition = 1;
        touchedNode.physicsBody = nil;
        touchedNode = nil;
    }
    if (contador==9) {
        NSLog(@"terminado");
        for (int i = 0; i< clothesInDrawer.count; i++) {
            SKSpriteNode *item = [clothesInDrawer objectAtIndex:i];
            SKAction *hideClothes = [SKAction moveToX:self.size.width-60 duration:0.5];
            hideClothes.timingMode = SKActionTimingEaseInEaseOut;
            [item runAction:hideClothes];
        }
        SKAction *hideDrawer = [SKAction moveToX:self.size.width-60 duration:0.5];
        hideDrawer.timingMode = SKActionTimingEaseInEaseOut;
        [drawer runAction:hideDrawer completion:^{
            for (int i = 0; i< clothesInDrawer.count; i++) {
                SKSpriteNode *item = [clothesInDrawer objectAtIndex:i];
                [item removeFromParent];
            }
            [clothesInDrawer removeAllObjects];
        }];
        [self checkPlayerChoices];
    }
}

/**
 * checks if the points the user chooses are near enough to the correct point
 **/
-(BOOL) cercano:(CGPoint)R1 a:(CGPoint)R2{
    const int OFFSET = 30;
    if(R1.x>=R2.x-OFFSET && R1.x<=R2.x+OFFSET && R1.y>=R2.y-OFFSET && R1.y<=R2.y+OFFSET){
        return YES;
    }
    return NO;
}

-(void)setClothesToChoose: (NSMutableArray *) clothesNames {
  //  NSLog(@"clothes in the drawer count %d", clothesInDrawer.count);
    if (clothesInDrawer.count>0) {
        [self closeDrawer: clothesNames];
    } else {
        [self fillDrawer: clothesNames];
        [self openDrawer];
    }
}

-(void)openDrawer{
    for (int i = 0; i< clothesInDrawer.count; i++) {
        SKSpriteNode *item = [clothesInDrawer objectAtIndex:i];
        SKAction *showClothes = [SKAction moveToX:self.size.width-208 duration:0.5];
        showClothes.timingMode = SKActionTimingEaseInEaseOut;
        [item runAction:showClothes];
    }
    SKAction *showDrawer = [SKAction moveToX:self.size.width-218 duration:0.5];
    showDrawer.timingMode = SKActionTimingEaseInEaseOut;
    [drawer runAction:showDrawer];

}

-(void)closeDrawer: (NSMutableArray *) clothesNames{
    for (int i = 0; i< clothesInDrawer.count; i++) {
        SKSpriteNode *item = [clothesInDrawer objectAtIndex:i];
        SKAction *hideClothes = [SKAction moveToX:self.size.width-60 duration:0.5];
        hideClothes.timingMode = SKActionTimingEaseInEaseOut;
        [item runAction:hideClothes];
    }
    SKAction *hideDrawer = [SKAction moveToX:self.size.width-60 duration:0.5];
    hideDrawer.timingMode = SKActionTimingEaseInEaseOut;
    [drawer runAction:hideDrawer completion:^{
        for (int i = 0; i< clothesInDrawer.count; i++) {
            SKSpriteNode *item = [clothesInDrawer objectAtIndex:i];
            [item removeFromParent];
        }
        [clothesInDrawer removeAllObjects];
        [self fillDrawer:clothesNames];
        [self openDrawer];
        
        }];
}

-(void)fillDrawer: (NSMutableArray *) clothesNames {
    for (int i = 0; i< clothesNames.count; i++) {
        SKSpriteNode *item = [SKSpriteNode spriteNodeWithImageNamed:[clothesNames objectAtIndex:i]];
        item.position = CGPointMake(self.size.width-60, 590-(140*i));
        item.name = [clothesNames objectAtIndex:i];
        item.zPosition = 1;
        [self addChild:item];
        [clothesInDrawer addObject:item];
    }
}

-(BOOL)characterHasItem: (SKSpriteNode *)charact: (NSString *)cl{
    if ([charact.name isEqualToString:@"cat"]) {
        if ([cats containsObject:cl]) {
            return true;
        } else {
            [cats addObject:cl];
            contador +=1;
            NSLog(@"añadido %@ a cats", cl);
            return false;
        }
    } else if ([charact.name isEqualToString:@"monkey"]) {
        if ([monkeys containsObject:cl]) {
            return true;
        } else {
            [monkeys addObject:cl];
            contador +=1;
            NSLog(@"añadido %@ a monkeys", cl);
            return false;
        }
    }else if ([charact.name isEqualToString:@"panda"]) {
        if ([pandas containsObject:cl]) {
            return true;
        } else {
            [pandas addObject:cl];
            contador +=1;
            NSLog(@"añadido %@ a pandas", cl);
            return false;
        }
    }
    return true;

}

-(void)putOnClothes: (int)cIndex: (SKSpriteNode *) charact{
    int index = 0;
    SKSpriteNode *newItem = [SKSpriteNode spriteNodeWithImageNamed:touchedNode.name];
    newItem.name = touchedNode.name;
    if ([touchedNode.name containsString:@"cap"]) {
        if (![self characterHasItem:charact :@"cap"]) {
            index = cIndex * 3;
            NSValue *pos = [delegado.memory objectAtIndex:index];
            newItem.position =[pos CGPointValue];
            newItem.zPosition = 2;
            [playerClothes setObject:newItem atIndexedSubscript:index];
            [self addChild:newItem];
        }
    } else if ([touchedNode.name containsString:@"tshirt"]) {
        if (![self characterHasItem:charact :@"tshirt"]) {
            index = cIndex*3 + 1;
            NSValue *pos = [delegado.memory objectAtIndex:index];
            newItem.position =[pos CGPointValue];
            newItem.zPosition = 2;
            [playerClothes setObject:newItem atIndexedSubscript:index];
            [self addChild:newItem];
        }
    } else if ([touchedNode.name containsString:@"pants"]) {
        if (![self characterHasItem:charact :@"pants"]) {
            index = cIndex*3 + 2;
            NSValue *pos = [delegado.memory objectAtIndex:index];
            newItem.position =[pos CGPointValue];
            newItem.zPosition = 2;
            [playerClothes setObject:newItem atIndexedSubscript:index];
            [self addChild:newItem];
        }
    }
}

-(void)checkPlayerChoices {
    for (int t=0; t<correctClothes.count; t++) {
        SKSpriteNode *cC = [correctClothes objectAtIndex:t];
        SKSpriteNode *pC = [playerClothes objectAtIndex:t];
        NSLog(@"correctClothes %d: %@",t,cC.name);
         NSLog(@"playerClothes %d: %@",t,pC.name);
    }

    int aciertos = 0;
    for (int i = 0; i<playerClothes.count; i++) {
        SKSpriteNode *playerChoice = [playerClothes objectAtIndex:i];
        SKSpriteNode *correctChoice = [correctClothes objectAtIndex:i];
        if ([playerChoice.name isEqualToString:correctChoice.name]) {
            aciertos += 1;
        }
    }
    SKLabelNode *etiqueta = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    NSString *etiquetaText;
    UIColor *textColor;
    if (aciertos < 3) {
        etiquetaText = [NSString stringWithFormat:@"¡Sólo %d! Puedes hacerlo mejor", aciertos];
        textColor = [UIColor orangeColor];
    } else if (aciertos < 5) {
        etiquetaText = [NSString stringWithFormat:@"¡%d prendas! Muy bien", aciertos];
        textColor = [UIColor colorWithRed:26.0/255.0 green:155.0/255.0 blue:222.0/255.0 alpha:1.0];
    } else if (aciertos < 7) {
        etiquetaText = [NSString stringWithFormat:@"¡%d prendas! Casi los aciertas todos", aciertos];
        textColor = [UIColor greenColor];
    } else if (aciertos == 9) {
        etiquetaText = [NSString stringWithFormat:@"¡%d prendas! Genial, acertaste todas", aciertos];
        textColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    }
    etiqueta.fontColor = textColor;
    etiqueta.text =etiquetaText;
    etiqueta.position = CGPointMake(self.size.width/2, self.size.height/6.8);
    etiqueta.zPosition = 4;
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
