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

+(id)MAXJAJsonObjectForProperties:(NSArray <MAXJAProperty *> *)properties;

+(NSDictionary *)MAXJADictionaryForProperties:(NSArray <MAXJAProperty *> *)properties;

+(NSArray *)MAXJAArrayOfDictionariesForProperties:(NSArray <MAXJAProperty *> *)properties;

@end
