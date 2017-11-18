//
//  MAXJsonAdapterRuntimeUtilities.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterRuntimeUtilities.h"

@implementation MAXJARuntimeUtilities

+(NSArray <NSString *> *)MAXJACreatePropertyNameListWithClass:(Class)aClass {
    
    NSMutableArray <NSString *> *propertyList = [NSMutableArray array];
    
    [MAXJARuntimeUtilities MAXJAEnumeratePropertiesWithClass: aClass iterationBlock:^(objc_property_t currentProperty, NSNumber *stopIteration) {
        
        NSString *propertyName = @(property_getName( currentProperty ));
        
        [propertyList addObject: propertyName];
        
    }];
    
    return propertyList;
}

+(NSArray <NSString *> *)MAXJACreatePropertyNameListWithouthNSObjectPropertiesWithClass:(Class)aClass {
    
    NSMutableArray *propertyListForClass = [[self MAXJACreatePropertyNameListWithClass: aClass] mutableCopy];
    
    NSArray *propertyListForNSObject = [self MAXJACreatePropertyNameListWithClass: [NSObject class] ];
    
    for (NSString *currentNSObjectPropertyName in propertyListForNSObject) {
        
        for (int index = 0; index < propertyListForClass.count; index += 1) {
            
            NSString *currentClassPropertyName = [propertyListForClass objectAtIndex: index];
            
            if ([currentClassPropertyName isEqualToString: currentNSObjectPropertyName] == YES) {
                [propertyListForClass removeObjectAtIndex: index];
                index -= 1;
            }
            
        }
        
    }
    
    return propertyListForClass;
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
