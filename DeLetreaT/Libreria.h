//
//  Libreria.h
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Diccionario.h"

@class Libreria;

@protocol LibreriaDelegate <NSObject>

-(void)libreriaCargada:(Libreria *) libreria;

@end

@interface Libreria : NSObject <NSXMLParserDelegate>{
@private Diccionario *diccionario;
}

@property (strong,readonly,nonatomic) NSArray *diccionarios;
@property (strong,readonly,nonatomic) NSArray *puzzle;
@property (strong,readonly,nonatomic) NSArray *memory;
@property (strong,readonly,nonatomic) NSArray *agujas;
@property (strong,nonatomic) id<LibreriaDelegate> delegado;

+(Libreria *)instancia;
-(void)anadirDiccionario:(Diccionario *) diccionario;
-(void)cargarXML:(NSString *)ruta;

@end
