//
//  MAXJsonAdapterObjectCreator.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJAProperty;

@interface MAXJAObjectCreator : NSObject

+(instancetype)MAXJAObjectOfClass:(Class)aClass properties:(NSArray <MAXJAProperty *> *)properties;

+(void)MAXJAPopulateObject:(NSObject *)object properties:(NSArray <MAXJAProperty *> *)properties;

@end
