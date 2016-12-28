//
//  MAXJsonAdapterPropertyMapper.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAXJsonAdapter.h"

@interface MAXJsonAdapterPropertyMapper : NSObject

#pragma mark - Property Name Map For Object Creation

+(NSDictionary *)MAXJAMapPropertyDictionaryForObjectCreation:(NSDictionary *)propertyDictionary delegate:(id <MAXJsonAdapterDelegate>)delegate;

#pragma mark - Property Name Map For Dictionary Creation

+(NSDictionary *)MAXJAMapPropertyDictionaryForDictionaryCreation:(NSDictionary *)propertyDictionary delegate:(id<MAXJsonAdapterDelegate>)delegate;

#pragma mark - Helper Methods

+(NSDictionary *)MAXJARemoveIgnoredPropertyFromPropertyDictionary:(NSDictionary *)propertyDictionary ignoredProperties:(NSArray <NSString *> *)ignoredProperties;

@end
