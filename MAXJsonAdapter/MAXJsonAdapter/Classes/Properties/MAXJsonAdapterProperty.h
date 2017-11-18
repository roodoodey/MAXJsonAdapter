//
//  MAXJsonAdapterProperty.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/29/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAXJsonAdapterPropertyMapInfo.h"
#import "MAXJsonAdapterValueTransformer.h"
#import "MAXJASubclassedProperty.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAXJsonAdapterProperty : NSObject

/**
 @description The name of the property key.
 */
@property (nonatomic, strong) NSString *propertyKey;

/**
 @description The value of the property.
 */
@property (nonatomic, strong, nullable) id value;

/**
 @description The property map object which contains the property mapping based on a property key or index in a list.
 */
@property (nonatomic, strong, nullable) MAXJsonAdapterPropertyMap *propertyMap;

/**
 @description The value transformer for the property
 */
@property (nonatomic, strong, nullable) MAXJsonAdapterValueTransformer *valueTransformer;

/**
 @description The subclassed proeprty convert object
 */
@property (nonatomic, strong, nullable) MAXJASubclassedProperty *subclassedProperty;

@end

NS_ASSUME_NONNULL_END
