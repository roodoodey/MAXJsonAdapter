//
//  MAXJsonAdapterValueTransformer.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/9/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAXJAValueTransformer : NSObject

@property (nonatomic, strong) NSString *propertyKey;

/**
 @description The transformation of the value of a given property from json format to object format.
 */
-(nullable id)MAXJAObjectCreationFormat:(id)value;

/**
 @description The transformation of the value of a given property from object format to json format.
 */
-(nullable id)MAXJAJsonFormat:(id)value;

/**
 */
+(instancetype)MAXJACreateValueTransformerWithProperyKey:(NSString *)propertyKey;

/**
 @description Instantiates a value transformer with the given property key name. If the property key name does not match any property in the object or dictionary, depending on the way you are serializing, it will be ignored.
 
 @param propertyKey This is property key you want to transform the value of before it is serialized to json format or deserialized from json to an objective c object.
 
 @warning The property key for the value transformer is not a mapped property name instead its the original name of the property which will be later on mapped with the value transformer attached to it and then applied when the dictionary or object is being created.
 
 */
-(instancetype)initValueTransformerWithPropertyKey:(NSString *)propertyKey;

@end

NS_ASSUME_NONNULL_END
