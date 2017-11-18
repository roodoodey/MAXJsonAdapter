//
//  MAXJsonAdapterObjectCreator.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterObjectCreator.h"
#import "MAXJsonAdapterProperty.h"

@implementation MAXJsonAdapterObjectCreator

+(instancetype)MAXJACreateObjectOfClass:(Class)aClass withProperties:(NSArray <MAXJsonAdapterProperty *> *)properties {
    
    id object = [[aClass alloc] init];
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
        
        id value = currentProperty.value;
        
        if (currentProperty.valueTransformer != nil && value != nil) {
         value = [currentProperty.valueTransformer MAXJAObjectCreationFormat: currentProperty.value];
        }
        
        if (currentProperty.subclassedProperty != nil && value != nil) {
            value = [currentProperty.subclassedProperty objectFromValue: value];
        }
       
        if (value != nil) {
            [object setValue: value forKey: currentProperty.propertyKey];
        }
        
    }
    
    return object;
}

@end
