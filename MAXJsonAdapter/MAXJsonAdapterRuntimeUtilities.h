//
//  MAXJsonAdapterRuntimeUtilities.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAXJsonAdapterRuntimeUtilities : NSObject

/**
 @abstract Creates an NSDictionary with the property names for the given class as the key and value and all of its subclasses property names.
 
 @property aClass The class type of the object to create the NSDictionary from.
 */
+(NSDictionary <NSString *, NSString *> *)MAXJACreatePropertyNameDictionaryWithClass:(Class)aClass;

/**
 @abstract Creates an NSDictionary with the property names for the tiven class as the key and value and all of its subclasses property names except for NSObject which has a lot of restricted properties.
 */
+(NSDictionary <NSString *, NSString *> *)MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass:(Class)aClass;

/**
 @abstract Enumerates through all of the properties for the given class. By changing the value of the stop iteration variable the enumeration for the class will be stopped.
 */
+(void)MAXJAEnumeratePropertiesWithClass:(Class)aClass iterationBlock:(void (^)(objc_property_t property, NSNumber *stopIteration))block;

@end

NS_ASSUME_NONNULL_END