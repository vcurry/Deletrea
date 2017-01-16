//
//  User.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 24/6/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name=name, level=level, sublevel=sublevel, chosenLevel=chosenLevel;

-(id)init{
    self=[super init];
    self.name=name;
    self.level=level;
    self.sublevel=sublevel;
    self.chosenLevel=chosenLevel;
    return self;
}

@end
