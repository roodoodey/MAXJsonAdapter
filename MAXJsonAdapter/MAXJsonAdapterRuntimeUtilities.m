//
//  MAXJsonAdapterRuntimeUtilities.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterRuntimeUtilities.h"

@implementation MAXJsonAdapterRuntimeUtilities

+(NSDictionary <NSString *, NSString *> *)MAXJACreatePropertyNameDictionaryWithClass:(Class)aClass {
    
    return nil;
}

+(void)MAXJAEnumeratePropertiesWithClass:(Class)aClass iterationBlock:(void (^)(objc_property_t _Nonnull, NSNumber * _Nonnull))block {
    
    NSNumber *stopIteration = @( NO );
    Class currentClass = aClass;
    
    // Iterate through all subclasses and get their properties.
    while ([stopIteration boolValue] == NO && currentClass != nil) {
        
        unsigned int numProperties = 0;
        objc_property_t *properties = class_copyPropertyList(currentClass, &numProperties);
        
        for (int index = 0; index < numProperties && [stopIteration boolValue] == NO; index += 1) {
            
            objc_property_t currentProperty = properties[index];
            
            block(currentProperty, stopIteration);
            
        }
        
        currentClass = [currentClass superclass];
    }
    
}

@end
