//
//  Level.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubLevel.h"

@interface Level : NSObject

@property (copy,nonatomic) NSString *num;
@property(strong,readonly,nonatomic) NSArray *sublevels;

-(id)init;
-(void)anadirSublevel:(SubLevel *)sublevel;

@end
