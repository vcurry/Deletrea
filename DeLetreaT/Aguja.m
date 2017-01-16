//
//  Aguja.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 11/1/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

#import "Aguja.h"

@implementation Aguja

@synthesize num=num, angleR=angleR, angle=angle, position=position, zRotate=_zRotate;

-(id)init{
    self = [super init];
    if(self){
        self.num=num;
        self.angleR=angleR;
        self.angle=angle;
        self.position=position;
        self.zRotate=_zRotate;
    }
    return self;
}

@end
