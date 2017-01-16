//
//  Diccionario.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Diccionario.h"

@implementation Diccionario
@synthesize levels=levels;

-(id)init{
    self=[super init];
    if(self){
        self->levels=[NSMutableArray array];
    }
    return self;
}

-(void) anadirlevels:(Level *)level{
    [(NSMutableArray *) self->levels addObject:level];
}

@end
