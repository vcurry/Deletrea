//
//  Pieza.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 11/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Pieza.h"

@implementation Pieza

@synthesize name=name, iniPosition=iniPosition, correctPosition=correctPosition;

-(id)init{
    self=[super init];
    if(self){
        self.name=name;
        self.iniPosition=iniPosition;
        self.correctPosition =correctPosition;
    }
    return self;
}



@end
