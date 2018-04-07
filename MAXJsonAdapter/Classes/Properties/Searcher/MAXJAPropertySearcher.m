//
//  MAXJsonAdapterPropertySearcher.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/5/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJAPropertySearcher.h"
#import "MAXJAPropertyMap.h"

@implementation MAXJAPropertySearcher

+(nullable id)MAXJASearchForProperty:(MAXJAPropertyMap *)propertyMap inDictionary:(NSDictionary *)dictionary {
    
    
    return [self p_findValueForPropertyMap: propertyMap inCollection: dictionary];
}

+(nullable id)p_findValueForPropertyMap:(MAXJAPropertyMap *)propertyMap inCollection:(id)collection {
    
    id value = [self p_valueForProperty: propertyMap inCollection: collection];
    
    // if we have a mapping of the property we need to keep drilling and searching for the value
    if (propertyMap.nextPropertyMap != nil) {
        
        if (value == nil) {
            
            // MARK: Should probably throw an error here as this property does not exist
            // Should not occur unless the implementee has caused an error. Should probably throw an error here.
            
            return nil;
        }
        
        return [self p_findValueForPropertyMap: propertyMap.nextPropertyMap inCollection: value];
        
    }
    
    return value;
}

+(nullable id)p_valueForProperty:(MAXJAPropertyMap *)propertyMap inCollection:(id)collection {
    
    if (propertyMap.key != nil && [collection isKindOfClass: [NSDictionary class] ] == YES) {
        
        id value = [(NSDictionary *)collection objectForKey: propertyMap.key];
        
        return value;
        
    }
    else if(propertyMap.index != nil && [collection isKindOfClass: [NSArray class] ] == YES) {
        
        NSArray *arrayCollection = (NSArray *)collection;
        NSInteger index = propertyMap.index.integerValue;
        if (index >= 0 && index < arrayCollection.count) {
            
            id value = [(NSArray *)collection objectAtIndex: index];
            
            return value;
        }
        
        // trying to search for a property out of bounds of the array.
        return nil;
    }
    
    // should never occur
    return nil;
}

@end
