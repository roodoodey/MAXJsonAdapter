//
//  MAXJsonAdapterPropertySearcher.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/5/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJsonAdapterPropertyMap;

NS_ASSUME_NONNULL_BEGIN;

@interface MAXJsonAdapterPropertySearcher : NSObject

+(nullable id)MAXJASearchForProperty:(MAXJsonAdapterPropertyMap *)propertyMap inDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END;
