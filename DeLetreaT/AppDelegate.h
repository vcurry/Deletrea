//
//  AppDelegate.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 24/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Libreria.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LibreriaDelegate>{
    Libreria *libreria;
}

@property (strong, nonatomic) UIWindow *window;

@property Libreria *_libreria;
@property(strong,nonatomic)Diccionario *diccionario;
@property(strong,nonatomic)NSArray *puzzle;
@property(strong,nonatomic)NSArray *memory;
@property(strong,nonatomic)NSArray *agujas;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property User *userPlaying;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

