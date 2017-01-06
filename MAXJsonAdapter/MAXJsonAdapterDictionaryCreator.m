//
//  MAXJsonAdapterDictionaryCreator.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterDictionaryCreator.h"

@implementation MAXJsonAdapterDictionaryCreator

+(NSDictionary *)MAXJACreateDictionaryForProperties:(NSArray<MAXJsonAdapterProperty *> *)properties {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
    
        if (currentProperty.propertyMap != nil && currentProperty.value != nil) {
            [self p_updateDictionary: dictionary withValue: currentProperty.value propertyMap: currentProperty.propertyMap];
        }
        else if(currentProperty.value != nil) {
            [dictionary setObject: currentProperty.value forKey: currentProperty.propertyKey];
        }
    }
    
    return dictionary;
}

+(void)p_updateDictionary:(NSMutableDictionary *)dictionary withValue:(id)value propertyMap:(MAXJsonAdapterPropertyMap *)propertyMap {
    
    [self p_mapValue: value propertyMap: propertyMap object: dictionary];
    
}

+(id)p_mapValue:(id)value propertyMap:(MAXJsonAdapterPropertyMap *)propertyMap object:(id)object {
    
    if (propertyMap.nextPropertyMap != nil) {
        
        if (propertyMap.key != nil) {
            
            id valueForProperty = [(NSDictionary *)object objectForKey: propertyMap.key];
            
            if (valueForProperty == nil) {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: dictionary];
                [(NSMutableDictionary *)object setObject: dictionary forKey: propertyMap.key ];
                
            }
            else {
                
                if ([object isKindOfClass: [NSMutableArray class] ] == YES) {
                    
                    
                    
                }
                else if([object isKindOfClass: [NSMutableDictionary class] ] == YES) {
                    
                    [(NSMutableDictionary *)object setObject:[self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: valueForProperty] forKey: propertyMap.key];
                    
                }
                
            }
            
            
        }
        else if(propertyMap.index != nil) {
            
            if ([object isKindOfClass: [NSMutableArray class] ] == NO) {
                NSLog(@"this should never happen and is an implementation error from the coder, throw an error here in the future.");
            }
            else {
                
            }
            
        }
        
        
    }
    else {
        
        if (propertyMap.key != nil) {
            
            id valueForProperty = [object objectForKey: propertyMap.key];
            
            if (valueForProperty == nil) {
                
                [(NSMutableDictionary *)object setObject: value forKey: propertyMap.key];
                
            }
            else {
                
                NSAssert( [valueForProperty isKindOfClass: [NSDictionary class] ] == NO, @"A property that should be made an array contains a dictionary, there is a problem in the mapping or value transforming of objects.");
                
                if ( [valueForProperty isKindOfClass: [NSMutableArray class] ] == YES ) {
                    
                    [(NSMutableArray *)valueForProperty addObject: value];
                    
                }
                else {
                    
                    NSMutableArray *array = [NSMutableArray array];
                    
                    [array addObject: valueForProperty];
                    [array addObject: value];
                    
                    
                    [(NSMutableDictionary *)object setObject: array forKey: propertyMap.key];
                }
                
            }
            
            
            return object;
        }
        
        /*
        else if(propertyMap.index != nil) {
            
            [(NSMutableArray *)object addObject: value];
            
            return object;
        }
        */
        
    }
    
    return object;
}
@end
