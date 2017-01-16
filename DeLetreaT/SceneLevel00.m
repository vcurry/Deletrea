//
//  SceneLevel00.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 6/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "SceneLevel00.h"
#import "Scene01.h"
#import "AppDelegate.h"
#import "Level.h"
#import "Sublevel.h"

@implementation SceneLevel00{
    NSArray *palabras;
    int contadorPalabras;
    int contadorLetrasAcertadas;
    NSMutableArray *letrasAcertadas;
    SKSpriteNode *chosenLetter;
    SKSpriteNode *buttonBack;
}

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"background02"];
        background.zPosition=-1;
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.userInteractionEnabled=YES;
        [self addChild:background];
        
        buttonBack=[SKSpriteNode spriteNodeWithImageNamed:@"minus"];
        buttonBack.position=CGPointMake(50, 730);
        [self addChild: buttonBack];

        AppDelegate *delegado=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"chosenLevel %@", delegado.userPlaying.chosenLevel);
        
        NSString *abc=@"abcdefghijklmnñopqrstuvwxyz";
        NSLog(@"abc length %lu", (unsigned long)abc.length);
        for (int i=0; i<27; i++) {
            NSString *caracter=[NSString stringWithFormat:@"%c",[abc characterAtIndex:i]];
            SKSpriteNode *letra=[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Button",caracter]];
            letra.name=caracter;
            float fila1=letra.size.width*10;
            if (i<10) {
                letra.position=CGPointMake(((self.size.width-fila1)/1.3)+(letra.size.width*i), self.size.height/1.3);
            }else if (i<20){
                letra.position=CGPointMake(((self.size.width-fila1)/1.3)+(letra.size.width*(i-10)), (self.size.height/1.3)-letra.size.height);
            }else{
                letra.position=CGPointMake(((self.size.width-fila1)/1.3)+(letra.size.width*(i-19)), (self.size.height/1.3)-(letra.size.height*2));
            }
            [self addChild:letra];
        }

        contadorLetrasAcertadas=0;
        contadorPalabras=0;
        palabras=[NSMutableArray array];
        Level *level=[delegado.diccionario.levels objectAtIndex:[delegado.userPlaying.chosenLevel integerValue]];
        SubLevel *sublevel=[level.sublevels objectAtIndex:[delegado.userPlaying.sublevel integerValue]];
        NSLog(@"level %@ y sublevel %@", level.num, sublevel.num);
        palabras=sublevel.palabras;
        NSLog(@"contador palabras %lu",(unsigned long)palabras.count);
        letrasAcertadas=[NSMutableArray array];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSString *palabra=[palabras objectAtIndex:contadorPalabras];
    NSUInteger contadorLetras=[palabra length];
    NSLog(@"contador letras %lu",(unsigned long)contadorLetras);
    for(UITouch *touch in touches){
        CGPoint location=[touch locationInNode:self];
        if ([buttonBack containsPoint:location]) {
            Scene01 *scene=[[Scene01 alloc] initWithSize:self.size];
            [self.view presentScene:scene];
        }
        SKSpriteNode *touchedNode=(SKSpriteNode *)[self nodeAtPoint:location];
        NSLog(@"NODO %@", touchedNode.name);
        NSString *image=[NSString stringWithFormat:@"%@Button",touchedNode.name];
        chosenLetter=[SKSpriteNode spriteNodeWithImageNamed:image];
        chosenLetter.position=CGPointMake(((self.size.width/2)-touchedNode.size.width*(contadorLetras/2))+(touchedNode.size.width*contadorLetrasAcertadas), self.size.height/4);
        [self addChild:chosenLetter];
        if (contadorLetrasAcertadas<contadorLetras) {
            NSString *letra=[NSString stringWithFormat:@"%c",[palabra characterAtIndex:contadorLetrasAcertadas]];
            if ([touchedNode.name isEqualToString:letra]) {
                NSLog(@"ACERTADA %@", letra);
                contadorLetrasAcertadas+=1;
                [letrasAcertadas addObject:chosenLetter];
            }else{
                [self.view setUserInteractionEnabled:NO];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideWrongLetter) userInfo:nil repeats:NO];
            }
        }
        if(contadorLetrasAcertadas>=contadorLetras){
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(nextWord) userInfo:nil repeats:NO];
        }
    }
}

-(void)hideWrongLetter{
    [chosenLetter removeFromParent];
    [self.view setUserInteractionEnabled:YES];
}

-(void)nextWord{
    NSLog(@"letrasAcertadas count %lu", (unsigned long)letrasAcertadas.count);
    for (int i=0; i<letrasAcertadas.count; i++) {
        NSLog(@"PALABRA COMPLETA");
        SKSpriteNode *letterToRemove=[letrasAcertadas objectAtIndex:i];
        [letterToRemove removeFromParent];
    }
    [letrasAcertadas removeAllObjects];
    letrasAcertadas=[NSMutableArray array];
    contadorPalabras+=1;
    contadorLetrasAcertadas=0;
    if (contadorPalabras==5) {
        [self nextSublevel];
    }
}

-(void)nextSublevel{
    NSLog(@"subnivel completado");
    AppDelegate *delegado = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [delegado managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *user in fetchedObjects) {
        NSLog(@"userIcon.name %@ y fetchedObjectsUser.name %@", delegado.userPlaying.name,[user valueForKey:@"name"] );
        if ([[user valueForKey:@"name"] isEqualToString:delegado.userPlaying.name]) {
            NSLog(@"FOUND");
            int sublevelsAcertados=([delegado.userPlaying.sublevel intValue]+1);
            NSLog(@"Sublevels acertados: %d", sublevelsAcertados);
            if (sublevelsAcertados<7) {
                delegado.userPlaying.sublevel=[NSNumber numberWithInt:(sublevelsAcertados)];
                [user setValue:delegado.userPlaying.sublevel forKey:@"sublevel"];
            
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }else if (sublevelsAcertados==7){
                delegado.userPlaying.level=[NSNumber numberWithInt:([delegado.userPlaying.level intValue]+1)];
                delegado.userPlaying.sublevel=@0;
                [user setValue:delegado.userPlaying.level forKey:@"level"];
                [user setValue:delegado.userPlaying.sublevel forKey:@"sublevel"];
                
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                Scene01 *scene=[[Scene01 alloc] initWithSize:self.size];
                [self.view presentScene:scene];
                
                
            }
        }
        SceneLevel00 *scene=[[SceneLevel00 alloc] initWithSize:self.size];
        [self.view presentScene:scene];
    }
    NSLog(@"sublevel %d", [delegado.userPlaying.sublevel intValue]);
}

@end
