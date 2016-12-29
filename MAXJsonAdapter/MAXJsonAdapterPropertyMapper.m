//
//  MAXJsonAdapterPropertyMapper.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterPropertyMapper.h"

@implementation MAXJsonAdapterPropertyMapper

#pragma mark - Property Name Map For Object Creation

+(NSDictionary *)MAXJAMapPropertyDictionaryForObjectCreation:(NSDictionary *)propertyDictionary delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    NSDictionary *mappedPropertyDict = [NSDictionary dictionaryWithDictionary: propertyDictionary];
    
    // if the properties to be used have been declared explicitly we use those over the properties to ignore
    if ([delegate respondsToSelector: @selector(MAXJAPropertiesForObjectCreation)] == YES) {
        
        NSArray <NSString *> *propertiesForObject = [delegate MAXJAPropertiesForObjectCreation];
        
        mappedPropertyDict = [self MAXJAPropertiesToUseFromPropertyDictionary: mappedPropertyDict propertiesToUse: propertiesForObject];
        
    }
    else if ([delegate respondsToSelector: @selector(MAXJAPropertiesToIgnoreObjectCreation)] == YES) {
        
        NSArray <NSString *> *ignoredProperties = [delegate MAXJAPropertiesToIgnoreObjectCreation];
        
        mappedPropertyDict = [self MAXJARemoveIgnoredPropertyFromPropertyDictionary: mappedPropertyDict ignoredProperties: ignoredProperties];
        
    }
    
    return mappedPropertyDict;
}

#pragma mark - Property Name Map For Dictionary Creation

+(NSDictionary *)MAXJAMapPropertyDictionaryForDictionaryCreation:(NSDictionary *)propertyDictionary delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    NSDictionary *mappedPropertyDict = [NSDictionary dictionaryWithDictionary: propertyDictionary];
    
    if ([delegate respondsToSelector: @selector(MAXJAPropertiesForDictionaryCreation)] == YES) {
        
        NSArray <NSString *> *propertiesForDict = [delegate MAXJAPropertiesForDictionaryCreation];
        
        mappedPropertyDict = [self MAXJAPropertiesToUseFromPropertyDictionary: mappedPropertyDict propertiesToUse: propertiesForDict];
        
    }
    else if ([delegate respondsToSelector: @selector(MAXJAPropertiesToIgnoreDictionaryCreation)] == YES) {
        
        NSArray <NSString *> *ignoredProperties = [delegate MAXJAPropertiesToIgnoreDictionaryCreation];
        
        mappedPropertyDict = [self MAXJARemoveIgnoredPropertyFromPropertyDictionary: mappedPropertyDict ignoredProperties: ignoredProperties];
        
    }
    
    return mappedPropertyDict;
}

#pragma mark - Helper Methods

+(NSDictionary *)MAXJARemoveIgnoredPropertyFromPropertyDictionary:(NSDictionary *)propertyDictionary ignoredProperties:(NSArray<NSString *> *)ignoredProperties {
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary: propertyDictionary];
    
    for (NSString *currentPropertyName in ignoredProperties) {
        
        [mutableDict removeObjectForKey: currentPropertyName];
        
    }
    
    return mutableDict;
}

+(NSDictionary *)MAXJAPropertiesToUseFromPropertyDictionary:(NSDictionary *)propertyDictionary propertiesToUse:(NSArray<NSString *> *)propertiesToUse {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    
    for (NSString *currentPropertyName in propertiesToUse) {
        
        for (NSString *currentPropertyNameOfObject in propertyDictionary.allKeys) {
            
            // if the properties which have been declared for use match those of the actualy object
            // then add it to the dictionary to be returned.
            if ([currentPropertyName isEqualToString: currentPropertyNameOfObject] == YES) {
                [properties setObject: currentPropertyName forKey: currentPropertyName];
            }
            
        }
        
    }
    
    return properties;
}

+(NSDictionary *)MAXJAMapPropertyDictionary:(NSDictionary *)propertyDictionary propertyMaps:(NSDictionary<NSString *,MAXJsonAdapterPropertyMapInfo *> *)propertyMaps {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary: propertyDictionary];
    
    for (NSString *currentMapKey in propertyMaps) {
        
        for (NSString *currentPropertyKey in propertyDictionary) {
            if ([currentMapKey isEqualToString: currentPropertyKey] == YES) {
                
                id object = [propertyMaps objectForKey: currentMapKey];
                if ([object isKindOfClass: [MAXJsonAdapterPropertyMapInfo class]] == YES) {
                    NSLog(@"is adapter property map");
                }
                else if ([object isKindOfClass: [NSDictionary class] ] == YES) {
                    NSLog(@"is dictionary not adapter property map");
                }
                
            }
        }
        
    }
    
    return properties;
}

@end
