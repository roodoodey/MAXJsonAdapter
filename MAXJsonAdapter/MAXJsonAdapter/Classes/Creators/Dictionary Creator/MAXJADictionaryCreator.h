//
//  MAXJsonAdapterDictionaryCreator.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJAProperty;

@interface MAXJADictionaryCreator : NSObject

+(id)MAXJACreateJsonObjectForProperties:(NSArray <MAXJAProperty *> *)properties;

+(NSDictionary *)MAXJACreateDictionaryForProperties:(NSArray <MAXJAProperty *> *)properties;

+(NSArray *)MAXJACreateArrayOfDictionariesForProperties:(NSArray <MAXJAProperty *> *)properties;

@end
