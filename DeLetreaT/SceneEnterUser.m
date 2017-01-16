//
//  SceneEnterUser.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 26/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "SceneEnterUser.h"
#import "Scene00.h"
#import "User.h"
#import "AppDelegate.h"

@implementation SceneEnterUser{
    UITextField *campo;
    NSString *texto;
    UIViewController *viewC;
}

-(id)initWithSize:(CGSize)size{
    if(self=[super initWithSize:size]){
        self.backgroundColor=[UIColor whiteColor];
        
        SKSpriteNode *titulo=[SKSpriteNode spriteNodeWithImageNamed:@"deLetrea"];
        titulo.position=CGPointMake(self.size.width/2, self.size.height/1.2);
        [self addChild: titulo];
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view{
    campo=[[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2-100, self.size.height/3, 200, 30)];
    campo.borderStyle=UITextBorderStyleRoundedRect;
    campo.textColor=[UIColor blueColor];
    campo.placeholder=@"Escribe tu nombre";
    campo.backgroundColor=[UIColor whiteColor];
    campo.keyboardType=UIKeyboardTypeDefault;
    campo.autocorrectionType=UITextAutocorrectionTypeNo;
    campo.delegate=self;
    [self.view addSubview:campo];
    
    viewC = self.view.window.rootViewController;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    [self processReturn];
    return YES;
}

-(BOOL)textField:(UITextField *)_campo shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self isCorrectTypeOfString:string] && _campo.text.length<8) {
        return YES;
    }
    return NO;
}

-(void)processReturn{
    [campo resignFirstResponder];
    texto=campo.text;
    
    if (texto.length==0) {
        UIAlertController *noName = [UIAlertController alertControllerWithTitle:@"Introduce un nombre" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [noName dismissViewControllerAnimated:YES completion:nil];
        }];
        [noName addAction:ok];
        [viewC presentViewController:noName animated:YES completion:nil];
    }else{
        BOOL userExists = false;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
    
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        if (fetchedObjects.count==0) {
            NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                  inManagedObjectContext:context];
            
            [user setValue:campo.text forKey:@"name"];
            [user setValue:@0 forKey:@"level"];
            [user setValue:@0 forKey:@"sublevel"];
            
            //   NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
            
            NSLog(@"User added");
            
            [campo removeFromSuperview];
            Scene00 *scene=[[Scene00 alloc] initWithSize:self.size];
            [self.view presentScene:scene];
        } else {

            for (NSManagedObject *user in fetchedObjects) {
        //      NSLog(@"userIcon.name %@ y fetchedObjectsUser.name %@", userIcon.name,[user valueForKey:@"name"] );
                if ([[user valueForKey:@"name"] isEqualToString:texto]) {
                    userExists = true;
                }
            }
            if (userExists) {
                NSLog(@"entra en userexists");
                UIAlertController *userExistsAlert = [UIAlertController alertControllerWithTitle:@"Ya existe un usuario con ese nombre" message:@"Elige otro nombre" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [userExistsAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                [userExistsAlert addAction:ok];
                [viewC presentViewController:userExistsAlert animated:YES completion:nil];
                campo.text = @"";

            }else {
                
                NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                  inManagedObjectContext:context];
            
                [user setValue:campo.text forKey:@"name"];
                [user setValue:@0 forKey:@"level"];
                [user setValue:@0 forKey:@"sublevel"];
            
                //   NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            
            
                NSLog(@"User added");
            
                [campo removeFromSuperview];
                Scene00 *scene=[[Scene00 alloc] initWithSize:self.size];
                [self.view presentScene:scene];

            }
        }
    }
}

-(BOOL)isCorrectTypeOfString:(NSString *)str{
    NSCharacterSet *notLetter=[[NSCharacterSet letterCharacterSet] invertedSet];
    if ([str rangeOfCharacterFromSet:notLetter].location==NSNotFound) {
        return YES;
    }
    return NO;
}

@end

