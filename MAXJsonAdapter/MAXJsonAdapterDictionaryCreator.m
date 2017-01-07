//
//  MAXJsonAdapterDictionaryCreator.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterDictionaryCreator.h"

@implementation MAXJsonAdapterDictionaryCreator

+(id)MAXJACreateJsonObjectForProperties:(NSArray<MAXJsonAdapterProperty *> *)properties {
    
    id object = nil;
    
    NSAssert([self p_isMixedArrayAndDictionaryFirstLevelForArray: properties] == YES, @"Cannot expect to return a dictionary and array based on mapping of properties.");
    
    if ([self p_areAllPropertiesForArray: properties] == YES) {
        object = [self MAXJACreateArrayOfDictionariesForProperties: properties];
    }
    else {
        object = [self MAXJACreateDictionaryForProperties: properties];
    }
    
    return object;
}

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

+(NSArray *)MAXJACreateArrayOfDictionariesForProperties:(NSArray<MAXJsonAdapterProperty *> *)properties {
    
    NSAssert([self p_areAllPropertiesForArray: properties] == YES, @"Not all properties are mapped to an array of properties this is usually due to an error in the property map.");
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
        
        if (currentProperty.propertyMap != nil && currentProperty.value != nil) {
            [self p_mapValue: currentProperty.value propertyMap: currentProperty.propertyMap object: array];
        }
        
    }
    
    return array;
}

+(BOOL)p_areAllPropertiesForArray:(NSArray <MAXJsonAdapterProperty *> *)properties {
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
        
        if (currentProperty.propertyMap == nil) {
            
            return NO;
        }
        else if(currentProperty.propertyMap.index == nil) {
            
            return NO;
        }
        
    }
    
    
    return YES;
}

/**
 Used to determine whether we should start with an array as the root object or a dictionary when creating the json object as users can map the values so that they are an array instead of a dictionary.
*/
+(BOOL)p_isMixedArrayAndDictionaryFirstLevelForArray:(NSArray <MAXJsonAdapterProperty *> *)properties {
    
    BOOL isArray = NO;
    BOOL isDictionary = NO;
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
        
        if (currentProperty.propertyMap == nil) {
            isDictionary = YES;
        }
        else {
            
            if (currentProperty.propertyMap.key != nil) {
                isDictionary = YES;
            }
            else if (currentProperty.propertyMap.index != nil) {
                isArray = YES;
            }
            
        }
        
        if (isArray == YES && isDictionary == YES) {
            
            return YES;
        }
        
    }
    
    return NO;
}

#pragma mark - Private Helpers

+(void)p_updateDictionary:(NSMutableDictionary *)dictionary withValue:(id)value propertyMap:(MAXJsonAdapterPropertyMap *)propertyMap {
    
    [self p_mapValue: value propertyMap: propertyMap object: dictionary];
    
}

+(id)p_mapValue:(id)value propertyMap:(MAXJsonAdapterPropertyMap *)propertyMap object:(id)object {
    
    if (propertyMap.nextPropertyMap != nil) {
        
        if (propertyMap.key != nil) {
            
            id valueForProperty = [(NSDictionary *)object objectForKey: propertyMap.key];
            
            if (valueForProperty == nil) {
                
                if (propertyMap.nextPropertyMap.key != nil) {
                    
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                    [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: dictionary];
                    [(NSMutableDictionary *)object setObject: dictionary forKey: propertyMap.key ];
                    
                }
                else if(propertyMap.nextPropertyMap.index != nil) {
                    
                    NSMutableArray *array = [NSMutableArray array];
                    [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: array];
                    [(NSMutableDictionary *)object setObject: array forKey: propertyMap.key];
                    
                }
                
                
            }
            else {
                
                if ([object isKindOfClass: [NSMutableArray class] ] == YES) {
                    
                    // should this happen?
                    [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: object];
                    
                }
                else if([object isKindOfClass: [NSMutableDictionary class] ] == YES) {
                    
                    [(NSMutableDictionary *)object setObject:[self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: valueForProperty] forKey: propertyMap.key];
                    
                }
                
            }
            
            
        }
        else if(propertyMap.index != nil) {
            
            NSAssert([object isKindOfClass: [NSMutableArray class] ] == NO, @"this should never happen and is an implementation error from the coder, throw an error here in the future.");
            
            id nextObject = nil;
            
            if (propertyMap.nextPropertyMap.key != nil) {
                
                nextObject = [NSMutableDictionary dictionary];
                
            }
            else if(propertyMap.nextPropertyMap.index != nil) {
                
                nextObject = [NSMutableArray array];
                
            }
            
            [(NSMutableArray *)object addObject: [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: nextObject] ];
            
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
        
        else if(propertyMap.index != nil) {
            
            [(NSMutableArray *)object addObject: value];
            
            return object;
        }
        
        
    }
    
    return object;
}
@end
