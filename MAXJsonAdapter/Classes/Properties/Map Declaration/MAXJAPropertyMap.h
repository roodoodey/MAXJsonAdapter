//
//  MAXJsonAdapterPropertyMapInfo.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/28/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAXJAPropertyMap : NSObject

/**
 @description When mapping through the json we need a key or position within the array. We get the value of the key or position, as appropriate, and if there is no next property we use that value to populate the property. If there is a another property map we keepd drilling down the hierarchy of the dictionary / json.
 
 @warning Either they key or the position variable have a value, never both. Use the convenience initializer to create json adapter map information.
 
 @note We always start at the root of the dictionary / json provided.
 */
@property (nonatomic, readonly, nullable, strong) NSString *key;

/**
 @description When mapping through the json we need a key or position within the array. We get the value of the key or position, as appropriate, and if there is no next property we use that value to populate the property. If there is a another property map we keepd drilling down the hierarchy of the json.
 
 @warning Either they key or the position variable have a value, never both. Use the convenience initializer to create json adapter map information.
 
 @note We always start at the root of the dictionary / json provided.
 */
@property (nonatomic, readonly, nullable, strong) NSNumber *index;

/**
 @description If you want to further drill down the json you simply create a new property map. When being processed it will go through the hierarchy until no next property exists.
 */
@property (nonatomic, nullable, strong) MAXJAPropertyMap *nextPropertyMap;


+(instancetype)MAXJAMapWithKey:(NSString *)key propertyMap:(nullable MAXJAPropertyMap *)propertyMap;

+(instancetype)MAXJAMapWithIndex:(int)index propertyMap:(nullable MAXJAPropertyMap *)propertyMap;

@end

NS_ASSUME_NONNULL_END
