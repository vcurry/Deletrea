//
//  Scene01.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 30/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene01.h"
#import "AppDelegate.h"
#import "SceneLevel00.h"
#import "ScenePrize00.h"
#import "ScenePrize01.h"
#import "ScenePrize02.h"
#import "ScenePrize03.h"
#import "ScenePrize04.h"

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

@implementation Scene01{
    
    NSMutableArray *levels;
    AppDelegate *delegado;
    SKSpriteNode *selectedNode;
}

@synthesize user=user;

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
     //   user=[[User alloc] init];
        delegado=(AppDelegate *)[[UIApplication sharedApplication] delegate];
   //     NSLog(@"SCENE01 User name %d", [delegado.userPlaying.level integerValue]);
        NSLog(@"printing size %f, %f", self.size.height, self.size.width);
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"background01"];
        background.zPosition=-1;
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.userInteractionEnabled=YES;
        [self addChild:background];
        
    }
    levels=[NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSString *nameLevel=[NSString stringWithFormat:@"level%d",i];
        [self setButtons:nameLevel en:i altura:1.8];
        NSString *namePrize=[NSString stringWithFormat:@"prize%d",i];
        [self setButtons:namePrize en:i altura:5.35];
    }
    
    return self;
}

-(void)setButtons:(NSString *)name en:(int)index altura:(float)posY{
    SKSpriteNode *level=[SKSpriteNode spriteNodeWithImageNamed:name];
    level.name=name;
    level.anchorPoint=CGPointZero;
    int xIndex=(self.size.width-(level.size.width*5))/8;
    level.position=CGPointMake(xIndex*(index+2)+(level.size.width*index)+50, self.size.height/posY);
    if (index<=[delegado.userPlaying.level intValue]) {
        level.userInteractionEnabled=NO;
        NSLog(@"level: %@ enabled", name);
        NSLog(@"levels: %d",[delegado.userPlaying.level intValue]);
    }else{
        level.userInteractionEnabled=YES;
    }
    [self addChild: level];
    [levels addObject:level];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location=[touch locationInNode:self];
     //   [self selectNodeForTouch: location];
        SKSpriteNode *touchedNode=(SKSpriteNode *)[self nodeAtPoint:location];
        if ([touchedNode.name containsString:@"level"]) {
            NSLog(@"%c",[touchedNode.name characterAtIndex:5]);
            delegado.userPlaying.chosenLevel=[NSString stringWithFormat:@"%c",[touchedNode.name characterAtIndex:5]];
            SceneLevel00 *scene=[[SceneLevel00 alloc] initWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }else if([touchedNode.name containsString:@"prize"]){
            NSString *prizeNr=[NSString stringWithFormat:@"%c",[touchedNode.name characterAtIndex:5]];
            if ([prizeNr isEqualToString:@"0"]) {
                ScenePrize00 *scene = [ScenePrize00 unarchiveFromFile:@"ScenePrize00"];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }else if ([prizeNr isEqualToString:@"1"]) {
                ScenePrize01 *scene=[[ScenePrize01 alloc] initWithSize:self.size];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }else if ([prizeNr isEqualToString:@"2"]) {
                ScenePrize02 *scene = [ScenePrize02 unarchiveFromFile:@"ScenePrize02"];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }else if ([prizeNr isEqualToString:@"3"]) {
                ScenePrize03 *scene=[ScenePrize03 unarchiveFromFile:@"ScenePrize03"];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }else if ([prizeNr isEqualToString:@"4"]) {
                ScenePrize04 *scene=[ScenePrize04 unarchiveFromFile:@"ScenePrize04"];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }
        }
    }
}

-(void)selectNodeForTouch:(CGPoint)touchLocation{
    SKSpriteNode *touchedNode=(SKSpriteNode *)[self nodeAtPoint:touchLocation];
    NSLog(@"node touched named %@",touchedNode.name);
}

@end
