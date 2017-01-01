//
//  MAXJsonAdapterPropertyMapper.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAXJsonAdapter.h"
#import "MAXJsonAdapterPropertyMapInfo.h"
#import "MAXJsonAdapterProperty.h"

@interface MAXJsonAdapterPropertyMapper : NSObject

#pragma mark - Property Name Map For Object Creation

+(NSArray <MAXJsonAdapterProperty *> *)MAXJAMapPropertyListForObjectCreation:(NSArray <NSString *> *)propertyList delegate:(id <MAXJsonAdapterDelegate>)delegate;

#pragma mark - Property Name Map For Dictionary Creation

+(NSArray <MAXJsonAdapterProperty *> *)MAXJAMapPropertyListForDictionaryCreation:(NSArray <NSString *> *)propertyList delegate:(id <MAXJsonAdapterDelegate>)delegate;

#pragma mark - Helper Methods

/**
 @description This method takes the property dictionary of the model object and matches the strings in the ignored properties dictionary and the keys that are in the mode dictionary which match the ignored properties are removed.
 */
+(NSArray <NSString *> *)MAXJARemoveIgnoredPropertiesFromPropertyList:(NSArray <NSString *> *)propertyList ignoredProperties:(NSArray <NSString *> *)ignoredProperties;

/**
 @description Takes the propertyDictionary and the propertiesToUse dictionary and for the keys that are included in both are kept for the new property dictionary as the user explicitly states which properties he wants to use and we only use properties that match that of the actual object.
 */
+(NSArray <NSString *> *)MAXJAPropertiesToUseFromPropertyList:(NSArray <NSString *> *)propertyList propertiesToUse:(NSArray <NSString *> *)propertiesToUse;

/**
 @description This method check whether the keys in the property maps match a key in the property dictionary, if the key matches it checks if the 
 */
+(NSArray <MAXJsonAdapterProperty *> *)MAXJAMapPropertyList:(NSArray <MAXJsonAdapterProperty *> *)propertyList propertyMaps:(NSArray <MAXJsonAdapterPropertyMap *> *)propertyMaps;

/**
 @description This method creates a MAXJsonAdapterProperty from a property list of strings.
 */
+(NSArray <MAXJsonAdapterProperty *> *)MAXJACreatePropertyForPropertyList:(NSArray <NSString *> *)propertyList;

@end
