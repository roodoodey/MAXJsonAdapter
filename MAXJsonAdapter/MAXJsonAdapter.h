//
//  MAXJsonAdapter.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MAXJsonAdapterDelegate <NSObject>

@optional

#pragma mark - Ignoring Properties
/**
 @description When populating a properties of an object you can specify which properties should be ignored for the initialization or update of the model object.
 */
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation;

/**
 @description When serializing a Json NSDictionary you can specify which properties to ignore for the dictionary creation.
 */
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation;

@end


@interface MAXJsonAdapter : NSObject

#pragma mark - Methods For Model Object Creation From NSDictionary

/**
 @description Create on object of type Class from an NSDictionary by mapping and matching property names of the model and the values in NSDictionary. By default, if no delegate method is implemented, the property names of the model and those in the dictionary would need to match, case-sensitive. The delegate allows you to map values of a specific property to a new name, or to the same name nested within the json. For more information on different ways you can modify parameters, name, their values and their mappings visit the MAXJsonAdapterDelegate declaration.
 */
+(id)MAXJACreateObjectOfClass:(Class)aClass delegate:(id <MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary;

#pragma mark - Methods For Dictionary Creation From Model Objects

+(NSDictionary <NSString *, NSObject *> *)MAXJADictFromObject:(id)object delegate:(id <MAXJsonAdapterDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
