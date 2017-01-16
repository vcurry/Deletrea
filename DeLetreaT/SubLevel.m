//
//  SubLevel.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "SubLevel.h"


@implementation SubLevel

@synthesize num=num, level=level, palabras=palabras;

-(id)init{
    self=[super init];
    if (self) {
        self.num=num;
        self.level=level;
        self->palabras=[NSMutableArray array];
    }
    return self;
}

-(void)anadirPalabra:(NSString *)palabra{
    [(NSMutableArray *) self->palabras addObject:palabra];
}

@end
