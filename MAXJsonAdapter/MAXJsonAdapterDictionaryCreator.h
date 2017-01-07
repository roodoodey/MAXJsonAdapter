//
//  MAXJsonAdapterDictionaryCreator.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAXJsonAdapterProperty.h"

@interface MAXJsonAdapterDictionaryCreator : NSObject

+(id)MAXJACreateJsonObjectForProperties:(NSArray <MAXJsonAdapterProperty *> *)properties;

+(NSDictionary *)MAXJACreateDictionaryForProperties:(NSArray <MAXJsonAdapterProperty *> *)properties;

+(NSArray *)MAXJACreateArrayOfDictionariesForProperties:(NSArray <MAXJsonAdapterProperty *> *)properties;

@end
