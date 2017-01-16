//
//  Diccionario.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface Diccionario : NSObject

@property(strong,readonly,nonatomic) NSArray *levels;

-(id)init;
-(void)anadirlevels:(Level *) level;

@end
