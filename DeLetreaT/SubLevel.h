//
//  SubLevel.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubLevel : NSObject

@property(copy,nonatomic)NSString *num;
@property(copy,nonatomic)NSString *level;
@property(strong,readonly,nonatomic)NSArray *palabras;

-(id)init;
-(void)anadirPalabra:(NSString *)palabra;


@end
