//
//  MAXJsonAdapter.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJsonAdapterPropertyMap;

NS_ASSUME_NONNULL_BEGIN

@protocol MAXJsonAdapterDelegate <NSObject>

@optional

#pragma mark - Specified Properties

/**
 @description In some cases you want to specify which properties should be populated during creation, instead of listing which should be ignoed, you simply state those you would like populated. This is especially useful when you have a lot of properties which you want to ignore.
 */
-(NSArray <NSString *> *)MAXJAPropertiesForObjectCreation;

/**
 @description
 */
-(NSArray <NSString *> *)MAXJAPropertiesForDictionaryCreation;

#pragma mark - Ignoring Properties
/**
 @description When populating a properties of an object you can specify which properties should be ignored for the initialization or update of the model object.
 
 @warning If you define MAXJAPropertiesforObjectCreation this method will be ignored.
 */
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation;

/**
 @description When serializing a Json NSDictionary you can specify which properties to ignore for the dictionary creation.
 
 @warning If you define MAXJAPropertiesForDictionaryCreation this method will be ignored.
 */
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation;

#pragma mark - Mapped Properties

/**
 @description This method is used to rename and map a property name to a different value in the hierarchy of the json. Here you decalre the name of the property you want to map/rename and create a MAXJsonPropertyMapInfo with the required information. This object can next other property map info objects so it can drill down the hierarchy of the json.
 */
-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation;

/**
 @description This method is used to rename and map a property name to a different value in the hierarchy of the json. Here you decalre the name of the property you want to map/rename and create a MAXJsonPropertyMapInfo with the required information. This object can next other property map info objects so it can drill down the hierarchy of the json.
 */
-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation;



#pragma mark - Value Transformers



#pragma mark - Subclasses



@end


@interface MAXJsonAdapter : NSObject

#pragma mark - Methods For Model Object Creation From NSDictionary

/**
 @description Create on object of type Class from an NSDictionary by mapping and matching property names of the model and the values in NSDictionary. By default, if no delegate method is implemented, the property names of the model and those in the dictionary would need to match, case-sensitive. The delegate allows you to map values of a specific property to a new name, or to the same name nested within the json. For more information on different ways you can modify parameters, name, their values and their mappings visit the MAXJsonAdapterDelegate declaration.
 */
+(id)MAXJACreateObjectOfClass:(Class)aClass delegate:(nullable id <MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary;

#pragma mark - Methods For Dictionary Creation From Model Objects

/**
 @description Creates an NSDictionary from an object by mapping property names to a dictionary.
 */
+(NSDictionary <NSString *, NSObject *> *)MAXJADictFromObject:(id)object delegate:(nullable id <MAXJsonAdapterDelegate> )delegate;

/**
 @description In some cases you want to have a list of objects from a single object which is handle by the map delegate. In those cases you have to use this method over the dictionary alternative of the method.
 */
+(NSArray <NSObject *> *)MAXJAArrayFromObject:(id)object delegate:(nullable id <MAXJsonAdapterDelegate> )delegate;


@end

NS_ASSUME_NONNULL_END
