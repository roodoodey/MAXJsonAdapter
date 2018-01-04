//
//  MAXJsonAdapter.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapter.h"
#import "MAXJAProperty.h"
#import "MAXJAPropertyMap.h"
#import "MAXJAPropertyMapper.h"
#import "MAXJAObjectCreator.h"
#import "MAXJADictionaryCreator.h"
#import "MAXJAPropertySearcher.h"


@implementation MAXJsonAdapter

#pragma mark - Object Creation From Dictionary

+(id)MAXJAObjectOfClass:(Class)aClass delegate:(id<MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary {
    
    MAXJsonAdapter *adapter = [[MAXJsonAdapter alloc] init];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreateMappedPropertyListForObjectCreation: aClass delegate: delegate];
    
    properties = [adapter p_populateProperties: properties withDictionary: dictionary];
    
    return [adapter p_createInstanceOfClass: aClass delegate: delegate fromDictionary: dictionary properties: properties];
}

-(id)p_createInstanceOfClass:(Class)aClass delegate:(id <MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary properties:(NSArray <MAXJAProperty *> *)properties {
    
    id object = [MAXJAObjectCreator MAXJAObjectOfClass: aClass properties: properties];
    
    return object;
}


#pragma mark - List of objects creations for array

+(NSArray *)MAXJAObjectsOfClass:(Class)aClass delegate:(id<MAXJsonAdapterDelegate>)delegate fromArray:(NSArray<NSDictionary *> *)array {
    
    NSMutableArray *arrayToReturn = [NSMutableArray array];
    
    for (NSDictionary *currentDictionary in array) {
        
        id object = [MAXJsonAdapter MAXJAObjectOfClass: aClass delegate: delegate fromDictionary: currentDictionary];
        
        [arrayToReturn addObject: object];
        
    }
    
    return arrayToReturn;
}

#pragma mark - Object Refresh

+(void)MAXJARefreshObject:(NSObject *)object delegate:(id<MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary {
    
    MAXJsonAdapter *adapter = [[MAXJsonAdapter alloc] init];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreateMappedPropertyListForObjectCreation: [object class] delegate: delegate];
    
    properties = [adapter p_populateProperties: properties withObject: object];
    
    [MAXJAObjectCreator MAXJAPopulateObject: object properties: properties];
}

#pragma mark - Object Creation Populating Property Values

-(NSArray <MAXJAProperty *> *)p_populateProperties:(NSArray <MAXJAProperty *> *)properties withDictionary:(NSDictionary *)dictionary {
    
    for (MAXJAProperty *currentProperty in properties) {
        
        // if we have no property mapping on the property we simply fetch the value of the key
        if (currentProperty.propertyMap == nil) {
            
            id value = [dictionary objectForKey: currentProperty.propertyKey];
            
            if (value != [NSNull null] || value != nil) {
                currentProperty.value = value;
            }
            
        }
        else {
            
            // if we have a property map we want to find its value.
            id value = [MAXJAPropertySearcher MAXJASearchForProperty: currentProperty.propertyMap inDictionary: dictionary];
            
            if (value != [NSNull null] || value != nil) {
                currentProperty.value = value;
            }
            
        }
        
    }
    
    return properties;
}

#pragma mark - Dictionary Creation From Object

+(NSDictionary <NSString *, NSObject *> *)MAXJADictFromObject:(id)object delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    MAXJsonAdapter *adapter = [[MAXJsonAdapter alloc] init];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreateMappedPropertyListForDictionaryCreation: [object class] delegate: delegate];
    
    properties = [adapter p_populateProperties: properties withObject: object];
    
    NSDictionary *dictionary = [MAXJADictionaryCreator MAXJADictionaryForProperties: properties];
    
    return dictionary;
}

+(NSArray <NSObject *> *)MAXJAArrayFromObject:(id)object delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    MAXJsonAdapter *adapter = [[MAXJsonAdapter alloc] init];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreateMappedPropertyListForDictionaryCreation: [object class] delegate: delegate];
    
    // Populates the value of property from the objects property keys which will be used later
    // to populate the mapped or non mapped property.
    properties = [adapter p_populateProperties: properties withObject: object];
    
    // creates objects and adds them to an array
    NSArray *array = [MAXJADictionaryCreator MAXJAArrayOfDictionariesForProperties: properties];
    
    return array;
}

+(NSArray <NSObject *> *)MAXJAArrayFromArray:(NSArray<NSObject *> *)objects delegate:(id<MAXJsonAdapterDelegate>)delegate {
        
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSObject *currentObject in objects) {
        NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: currentObject delegate: delegate];
        [array addObject: dict];
    }
    
    return array;
}

-(NSArray <MAXJAProperty *> *)p_populateProperties:(NSArray <MAXJAProperty *> *)properties withObject:(id)object {
    
    for (MAXJAProperty *currentProperty in properties) {
        
        id value = [object valueForKey: currentProperty.propertyKey];
        
        if (value != nil || value != [NSNull null]) {
            currentProperty.value = value;
        }
        
    }
    
    return properties;
}

@end
