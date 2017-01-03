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
    
        [dictionary setObject: currentProperty.value forKey: currentProperty.propertyKey];
        
    }
    
    return dictionary;
}

@end
