//
//  Libreria.m
//  DeLetreaT
//
//  Created by Verónica Cordobés on 7/7/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Libreria.h"
#import "Pieza.h"
#import "Aguja.h"

@implementation Libreria
@synthesize diccionarios=diccionarios, puzzle=puzzle, memory=memory, agujas=agujas, delegado=delegado;

+(Libreria *)instancia{
    static Libreria *libreria=nil;
    if(libreria==nil){
        libreria=[[Libreria alloc] init];
    }
    return libreria;
}

-(id)init{
    self=[super init];
    if(self){
        self->diccionarios=[NSMutableArray array];
    }
    return self;
}

-(void)anadirDiccionario:(Diccionario *)_diccionario{
    [(NSMutableArray *) self->diccionarios addObject:_diccionario];
}

-(void)cargarXML:(NSString *)ruta{
    NSString *rutaCompleta=[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:ruta];
    NSURL *URL=[NSURL fileURLWithPath:rutaCompleta];
    NSXMLParser *parser;
    parser=[[NSXMLParser alloc] initWithContentsOfURL:URL];
    parser.delegate=self;
    [parser parse];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self->diccionarios=[NSMutableArray array];
    self->puzzle=[NSMutableArray array];
    self->memory = [NSMutableArray array];
    self->agujas = [NSMutableArray array];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [delegado libreriaCargada:self];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqual:@"diccionario"]){
        self->diccionario=[[Diccionario alloc] init];
        [self anadirDiccionario:self->diccionario];
    }else if([elementName isEqual:@"level"]){
        Level *level=[[Level alloc] init];
        level.num=[attributeDict valueForKey:@"num"];
        if (level!=nil) {
            [self->diccionario anadirlevels:level];
            //NSLog(@"Pasa por Level %@", level.num);
        }
    }else if([elementName isEqual:@"sublevel"]){
        SubLevel *sublevel=[[SubLevel alloc] init];
        sublevel.num=[attributeDict valueForKey:@"num"];
        sublevel.level=[attributeDict valueForKey:@"l"];
        Level *level=[self->diccionario.levels objectAtIndex:[sublevel.level integerValue]];
        if (sublevel!=nil) {
            [level anadirSublevel:sublevel];
        }
/**        NSString *palabra0=[attributeDict valueForKey:@"palabra0"];
        if (palabra0!=nil) {
            [sublevel anadirPalabra:palabra0];
        }
        NSString *palabra1=[attributeDict valueForKey:@"palabra1"];
        if (palabra1!=nil) {
            [sublevel anadirPalabra:palabra1];
        }
        NSString *palabra2=[attributeDict valueForKey:@"palabra2"];
        if (palabra2!=nil) {
            [sublevel anadirPalabra:palabra2];
        }
        NSString *palabra3=[attributeDict valueForKey:@"palabra3"];
        if (palabra3!=nil) {
            [sublevel anadirPalabra:palabra3];
        }
        NSString *palabra4=[attributeDict valueForKey:@"palabra4"];
        if (palabra4!=nil) {
            [sublevel anadirPalabra:palabra4];
        }
*/
        for(int i=0;i<5;i++){
            NSString *word=[NSString stringWithFormat:@"palabra%d",i];
            NSString *palabra=[attributeDict valueForKey:word];
            if (palabra!=nil) {
                [sublevel anadirPalabra:palabra];
            }
          //  NSLog(@"SubLevel %@ con palabras count %lu", sublevel.num, (unsigned long)sublevel.palabras.count);
        }
    }else if ([elementName isEqual:@"pieza"]) {
        Pieza *pieza=[[Pieza alloc]init];
        pieza.name = [attributeDict valueForKey:@"nombre"];
        NSString *posx = [attributeDict valueForKey:@"posx"];
        NSString *posy = [attributeDict valueForKey:@"posy"];
        pieza.correctPosition = CGPointMake([posx floatValue], [posy floatValue]);
        NSString *xini = [attributeDict valueForKey:@"xini"];
        NSString *yini = [attributeDict valueForKey:@"yini"];
        pieza.iniPosition = CGPointMake([xini floatValue], [yini floatValue]);
        [(NSMutableArray *)self->puzzle addObject:pieza];
    //        NSLog(@"añade pieza");
        
   //     NSLog(@"Pasa por Data.xme puzzle");
            
    }else if ([elementName isEqual:@"posicion"]) {
        NSString *x = [attributeDict valueForKey:@"x"];
        NSString *y = [attributeDict valueForKey:@"y"];
        CGPoint posicion = CGPointMake([x floatValue], [y floatValue]);
        [(NSMutableArray *)self->memory addObject:[NSValue valueWithCGPoint:posicion]];
    }else if ([elementName isEqual:@"aguja"]){
        Aguja *aguja=[[Aguja alloc] init];
        NSString *num = [attributeDict valueForKey:@"num"];
        CGFloat gradoR = [[attributeDict valueForKey:@"gradoR"] floatValue];
        CGFloat grado = [[attributeDict valueForKey:@"grado"] floatValue];
        CGFloat posx = [[attributeDict valueForKey:@"posx"] floatValue];
        CGFloat posy = [[attributeDict valueForKey:@"posy"] floatValue];
        CGFloat zRotate = [[attributeDict valueForKey:@"zrotate"] floatValue];
        aguja.num = num;
        aguja.angleR = gradoR;
        aguja.angle = grado;
        aguja.position = CGPointMake(posx, posy);
        aguja.zRotate = zRotate;
        [(NSMutableArray *)self->agujas addObject:aguja];
    }
}

@end
