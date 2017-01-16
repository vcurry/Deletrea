//
//  Puzzle.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 14/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pieza.h"

@interface Puzzle : NSObject

@property(strong,readonly,nonatomic) NSArray *piezas;

-(id)init;
-(void)anadirpiezas:(Pieza *) pieza;

@end
