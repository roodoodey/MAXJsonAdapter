//
//  MAXJsonAdapterProperty.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/29/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAXJsonAdapterPropertyMapInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAXJsonAdapterProperty : NSObject

@property (nonatomic, strong) NSString *propertyKey;

/**
 @description The value of the property.
 */
@property (nonatomic, strong, nullable) id value;

/**
 
 */
@property (nonatomic, strong, nullable) MAXJsonAdapterPropertyMap *propertyMap;


@end

NS_ASSUME_NONNULL_END
