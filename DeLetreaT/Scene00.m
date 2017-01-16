//
//  Scene00.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 24/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene00.h"
#import "Scene01.h"
#import "SceneEnterUser.h"
#import "AppDelegate.h"
#import "User.h"
@implementation Scene00{

    SKSpriteNode *plus;
    SKSpriteNode *userIcon;
    SKSpriteNode *deleteIcon;
    SKLabelNode *etiqueta;
    NSArray *fetchedObjects;
    NSMutableArray *userIcons;
    NSMutableArray *deleteIcons;
    NSMutableArray *nameLabels;
    AppDelegate *delegado;
    NSManagedObjectContext *context;
}


-(id)initWithSize:(CGSize)size{
    if(self=[super initWithSize:size]){
     NSLog(@"printing size scene00 %f, %f", self.size.height, self.size.width);
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"background00"];
        background.zPosition=-1;
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        [self addChild:background];
        
        plus=[SKSpriteNode spriteNodeWithImageNamed:@"plus"];

        userIcons=[NSMutableArray array];
        deleteIcons=[NSMutableArray array];
        nameLabels = [NSMutableArray array];
        
        delegado = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        context = [delegado managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSError *error;
        
        //Insertamos un usuario para probar todos los juegos
        fetchedObjects = [context executeFetchRequest:request error:&error];
        NSLog(@"COUNT %lu", (unsigned long)fetchedObjects.count);
        if (fetchedObjects.count==0) {
            plus.position=CGPointMake(self.size.width/2+150, self.size.height/1.8);
            [self addChild:plus];
            userIcon=[SKSpriteNode spriteNodeWithImageNamed:@"person"];
            userIcon.position=CGPointMake(self.size.width/2-90, self.size.height/1.8);
            [userIcons addObject:userIcon];
            [self addChild:userIcon];
            NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                  inManagedObjectContext:context];
            
            [user setValue:@"Prueba" forKey:@"name"];
            [user setValue:@4 forKey:@"level"];
            [user setValue:@4 forKey:@"sublevel"];
            
            //   NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }

        }else if (fetchedObjects.count <3){
            [self setLabels:fetchedObjects];
            plus.position=CGPointMake(self.size.width/2+150, self.size.height/1.8-(100*fetchedObjects.count));
            [self addChild:plus];
        }else if (fetchedObjects.count >= 3){
            [self setLabels:fetchedObjects];
            NSLog(@"Mas de 3");
        }
    }
    
    return self;
}

-(void) setLabels:(NSArray *)cDObjects{
    for(int i=0;i<fetchedObjects.count;i++){
        NSManagedObject *user=[fetchedObjects objectAtIndex:i];
        NSString *userName=[user valueForKey:@"name"];
        userIcon=[SKSpriteNode spriteNodeWithImageNamed:@"userIcon"];
        userIcon.name=userName;
        userIcon.position=CGPointMake(self.size.width/2-150, self.size.height/1.8-(100*i));
        [userIcons addObject:userIcon];
        [self addChild:userIcon];
        
        deleteIcon=[SKSpriteNode spriteNodeWithImageNamed:@"minus"];
        deleteIcon.name=userName;
        deleteIcon.position=CGPointMake(self.size.width/2+150, self.size.height/1.8-(100*i));
        [deleteIcons addObject:deleteIcon];
        [self addChild:deleteIcon];
        
        
        etiqueta=[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        etiqueta.position=CGPointMake(self.size.width/2, self.size.height/1.8-(100*i));
        etiqueta.horizontalAlignmentMode=SKLabelHorizontalAlignmentModeCenter;
        etiqueta.verticalAlignmentMode=SKLabelVerticalAlignmentModeCenter;
        etiqueta.fontColor=[UIColor darkGrayColor];
        etiqueta.fontSize=40;
        etiqueta.text=userName;
        etiqueta.zPosition=3;
        [nameLabels addObject:etiqueta];
        [self addChild:etiqueta];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location=[touch locationInNode:self];
        if ([plus containsPoint:location]) {
            SceneEnterUser *scene=[[SceneEnterUser alloc] initWithSize:self.size];
            [self.view presentScene:scene];
        }else{
            if (etiqueta.text!=nil){
                for (int i=0; i<userIcons.count; i++) {
                    userIcon=[userIcons objectAtIndex:i];
                    etiqueta = [nameLabels objectAtIndex:i];
                    if ([etiqueta containsPoint:location]){
                        for (NSManagedObject *user in fetchedObjects) {
                            NSLog(@"userIcon.name %@ y fetchedObjectsUser.name %@", userIcon.name,[user valueForKey:@"name"] );
                            if ([[user valueForKey:@"name"] isEqualToString:userIcon.name]) {
                                NSLog(@"FOUND");
                                //userPlaying=[[User alloc] init];
                                delegado.userPlaying.name=[user valueForKey:@"name"];
                                delegado.userPlaying.level=[user valueForKey:@"level"];
                                delegado.userPlaying.sublevel=[user valueForKey:@"sublevel"];
                                NSLog(@"Sets User %@, level %ld, sublevel %ld", delegado.userPlaying.name, (long)[delegado.userPlaying.level integerValue], (long)[delegado.userPlaying.sublevel integerValue]);
                            }
                        }
                        Scene01 *scene=[[Scene01 alloc] initWithSize:self.size];
                        scene.scaleMode = SKSceneScaleModeAspectFill;
                        SKTransition *sceneTransition=[SKTransition fadeWithColor:[UIColor whiteColor] duration:1];
                        [self.view presentScene:scene transition:sceneTransition];
                    }
                }
                for (int j=0; j<deleteIcons.count; j++) {
                    deleteIcon=[deleteIcons objectAtIndex:j];
                    if ([deleteIcon containsPoint:location]){
                        NSLog(@"FOUND 1 %@ to Delete", deleteIcon.name);
                        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"¿Estás seguro? Se borrarán todos los niveles alcanzados" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        NSLog(@"FOUND 2.0 %@ to Delete", deleteIcon.name);
                        NSString *nameToDelete = deleteIcon.name;
                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            for (NSManagedObject *user in fetchedObjects) {
                                NSLog(@"FOUND 2 %@ to NameToDelete", nameToDelete);
                                if ([[user valueForKey:@"name"] isEqualToString:nameToDelete]) {
                                     NSLog(@"fetchedObjectsUser.name %@", [user valueForKey:@"name"] );
                                    NSLog(@"FOUND 3 %@ to Delete", deleteIcon.name);
                                    delegado = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                    NSManagedObjectContext *contextd=[delegado managedObjectContext];
                                    [contextd deleteObject:user];
                                    NSError * error = nil;
                                    if (![contextd save:&error])
                                    {
                                        NSLog(@"Error ! %@", error);
                                    }
                                    NSLog(@"Deleted");
                                    Scene00 *scene=[[Scene00 alloc] initWithSize:self.size];
                                    [self.view presentScene:scene];
                                }
                            }
                            [deleteAlert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [deleteAlert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [deleteAlert addAction:ok];
                        [deleteAlert addAction:cancel];
                        UIViewController *viewC = self.view.window.rootViewController;
                        [viewC presentViewController:deleteAlert animated:YES completion:nil];
                    }
                }
            }
        }
    }
}


@end
