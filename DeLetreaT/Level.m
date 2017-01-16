//
//  Level.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize num=num,sublevels=sublevels;

-(id)init{
    self=[super init];
    if(self){
        self.num=num;
        self->sublevels=[NSMutableArray array];
    }
    return self;
}

-(void)anadirSublevel:(SubLevel *)sublevel{
    [(NSMutableArray *) self->sublevels addObject:sublevel];
}

@end
