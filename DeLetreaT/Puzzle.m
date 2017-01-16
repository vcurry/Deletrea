//
//  Puzzle.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 14/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Puzzle.h"


@implementation Puzzle

@synthesize piezas=piezas;

-(id)init{
    self=[super init];
    if(self){
        self->piezas=[NSMutableArray array];
    }
    return self;
}

-(void) anadirpiezas:(Pieza *)pieza{
    [(NSMutableArray *) self->piezas addObject:pieza];
}


@end
