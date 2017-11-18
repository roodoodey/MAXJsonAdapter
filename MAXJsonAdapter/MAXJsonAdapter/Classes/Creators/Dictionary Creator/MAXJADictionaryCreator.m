//
//  MAXJsonAdapterDictionaryCreator.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJADictionaryCreator.h"
#import "MAXJsonAdapterProperty.h"

@implementation MAXJADictionaryCreator

+(id)MAXJACreateJsonObjectForProperties:(NSArray <MAXJAProperty *> *)properties {
    
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

+(NSDictionary *)MAXJACreateDictionaryForProperties:(NSArray <MAXJAProperty *> *)properties {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (MAXJAProperty *currentProperty in properties) {
        
        id value = currentProperty.value;
        
        // if we have a value transformer we want to transformer the value to json format.
        if (currentProperty.valueTransformer != nil) {
            value = [currentProperty.valueTransformer MAXJAJsonFormat: value];
        }
        
        // if we have a subclassed property we want to serialize it.
        if (currentProperty.subclassedProperty != nil) {
            value = [currentProperty.subclassedProperty JSONObjectFromValue: value];
        }
    
        // if the property has a mapper we need to map it appropriately.
        if (currentProperty.propertyMap != nil && value != nil) {
            [self p_updateDictionary: dictionary withValue: value propertyMap: currentProperty.propertyMap];
        }
        // if the property has no property map and has a value we should add it to the dictionary.
        else if(value != nil) {
            [dictionary setObject: value forKey: currentProperty.propertyKey];
        }
    }
    
    return dictionary;
}

+(NSArray *)MAXJACreateArrayOfDictionariesForProperties:(NSArray <MAXJAProperty *> *)properties {
    
    NSAssert([self p_areAllPropertiesForArray: properties] == YES, @"Not all properties are mapped to an array of properties this is usually due to an error in the property map.");
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (MAXJAProperty *currentProperty in properties) {
        
        id value = currentProperty.value;
        if (currentProperty.valueTransformer != nil) {
            value = [currentProperty.valueTransformer MAXJAJsonFormat: value];
        }
        
        if (currentProperty.subclassedProperty != nil) {
            value = [currentProperty.subclassedProperty JSONObjectFromValue: value];
        }
        
        // we are creating an array of values from a single object so we know we will need to map the values in order to get an array from an object.
        if (currentProperty.propertyMap != nil && value != nil) {
            [self p_mapValue: value propertyMap: currentProperty.propertyMap object: array];
        }
        
    }
    
    return array;
}

+(BOOL)p_areAllPropertiesForArray:(NSArray <MAXJAProperty *> *)properties {
    
    for (MAXJAProperty *currentProperty in properties) {
        
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
+(BOOL)p_isMixedArrayAndDictionaryFirstLevelForArray:(NSArray <MAXJAProperty *> *)properties {
    
    BOOL isArray = NO;
    BOOL isDictionary = NO;
    
    for (MAXJAProperty *currentProperty in properties) {
        
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
    
    // if the property map has another mapper we have to handle it
    if (propertyMap.nextPropertyMap != nil) {
        
        // if the property map has a key we know its a dictionary
        if (propertyMap.key != nil) {
            
            // check if we have created the hierarchy for the dictionary map.
            id valueForProperty = [(NSDictionary *)object objectForKey: propertyMap.key];
            
            // if we have not created the hierarcy we need to create a dictionary or array based on the type of property we are working with.
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
                //
                if ([object isKindOfClass: [NSMutableArray class] ] == YES) {
                    
                    // when you drill through an array we have to check the index.
                    [self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: object];
                    
                }
                else if([object isKindOfClass: [NSMutableDictionary class] ] == YES) {
                    
                    [(NSMutableDictionary *)object setObject:[self p_mapValue: value propertyMap: propertyMap.nextPropertyMap object: valueForProperty] forKey: propertyMap.key];
                    
                }
                
            }
            
            
        }
        // if the property map does not have a key it is an array based property which needs to be handled correctly
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
        // if has no property mapper  we need to handle it.
        if (propertyMap.key != nil) {
            
            id valueForProperty = [object objectForKey: propertyMap.key];
            
            if (valueForProperty == nil) {
                
                [(NSMutableDictionary *)object setObject: value forKey: propertyMap.key];
                
            }
            else {
                
                NSAssert( [valueForProperty isKindOfClass: [NSDictionary class] ] == NO, @"A property that should be made an array contains a dictionary, there is a problem in the mapping or value transforming of objects.");
                
                // if we find an array it means this property is supposed to behave like an array.
                if ( [valueForProperty isKindOfClass: [NSMutableArray class] ] == YES ) {
                    
                    [(NSMutableArray *)valueForProperty addObject: value];
                    
                }
                else {
                    
                    // if the object is not an array, and not an NSDictionary, we know we are dealing with a foundation object which is being added to the same key so we treat it as a list. Question becomes if this is expected behavior or not.
                    
                    NSMutableArray *array = [NSMutableArray array];
                    
                    [array addObject: valueForProperty];
                    [array addObject: value];
                    
                    // switches out the property with a new one for the key.
                    [(NSMutableDictionary *)object setObject: array forKey: propertyMap.key];
                }
                
            }
            
            
            return object;
        }
        // if it is an index based property we know it is an array so we have to add it to the array.
        else if(propertyMap.index != nil) {
            
            [(NSMutableArray *)object addObject: value];
            
            return object;
        }
        
        
    }
    
    return object;
}
@end
