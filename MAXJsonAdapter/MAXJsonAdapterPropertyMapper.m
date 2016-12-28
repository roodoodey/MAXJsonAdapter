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
    
    if ([delegate respondsToSelector: @selector(MAXJAPropertiesToIgnoreObjectCreation)] == YES) {
        
        NSArray <NSString *> *ignoredProperties = [delegate MAXJAPropertiesToIgnoreObjectCreation];
        
        mappedPropertyDict = [self MAXJARemoveIgnoredPropertyFromPropertyDictionary: mappedPropertyDict ignoredProperties: ignoredProperties];
        
    }
    
    return mappedPropertyDict;
}

#pragma mark - Property Name Map For Dictionary Creation

+(NSDictionary *)MAXJAMapPropertyDictionaryForDictionaryCreation:(NSDictionary *)propertyDictionary delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    NSDictionary *mappedPropertyDict = [NSDictionary dictionaryWithDictionary: propertyDictionary];
    
    if ([delegate respondsToSelector: @selector(MAXJAPropertiesToIgnoreDictionaryCreation)] == YES) {
        
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

@end
