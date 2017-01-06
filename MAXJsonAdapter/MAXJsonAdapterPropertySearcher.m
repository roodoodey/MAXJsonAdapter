//
//  MAXJsonAdapterPropertySearcher.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/5/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterPropertySearcher.h"
#import "MAXJsonAdapterPropertyMapInfo.h"

@implementation MAXJsonAdapterPropertySearcher

+(nullable id)MAXJASearchForProperty:(MAXJsonAdapterPropertyMap *)propertyMap inDictionary:(NSDictionary *)dictionary {
    
    
    return [self p_findValueForPropertyMap: propertyMap inCollection: dictionary];
}

+(nullable id)p_findValueForPropertyMap:(MAXJsonAdapterPropertyMap *)propertyMap inCollection:(id)collection {
    
    id value = [self p_valueForProperty: propertyMap inCollection: collection];
    
    
    if (propertyMap.nextPropertyMap != nil) {
        
        if (value == nil) {
            // Should not occur unless the implementee has caused an error. Should probably throw an error here.
            
            return nil;
        }
        
        return [self p_findValueForPropertyMap: propertyMap.nextPropertyMap inCollection: value];
        
    }
    
    return value;
}

+(nullable id)p_valueForProperty:(MAXJsonAdapterPropertyMap *)propertyMap inCollection:(id)collection {
    
    if (propertyMap.key != nil && [collection isKindOfClass: [NSDictionary class] ] == YES) {
        
        id value = [(NSDictionary *)collection objectForKey: propertyMap.key];
        
        return value;
        
    }
    else if(propertyMap.index != nil && [collection isKindOfClass: [NSArray class] ] == YES) {
        
        id value = [(NSArray *)collection objectAtIndex: propertyMap.index.unsignedIntegerValue];
        
        return value;
    }
    
    // should never occur
    return nil;
}

@end
