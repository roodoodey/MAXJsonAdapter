//
//  MAXJsonAdapterPropertySearcher.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/5/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJAPropertyMap;

NS_ASSUME_NONNULL_BEGIN;

/**
 @description The MAXJsonAdapterPropertySearcher searcher a dictionary if the property maps exist and returns their value. If none is found it returns nil. If it finds the property mapping it will return its value.
 */
@interface MAXJsonAdapterPropertySearcher : NSObject

/**
 @description searches a dictionary for the property map. If none is found it returns nil.
 
 @param propertyMap The property mapping to check for in the dictionary.
 @param dictionary The dictionary in which you want to check for the property map.
 
 @return Returns nil or the value found by the mapping.
 */
+(nullable id)MAXJASearchForProperty:(MAXJAPropertyMap *)propertyMap inDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END;
