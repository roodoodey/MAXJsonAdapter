//
//  MAXJsonAdapterObjectCreator.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAXJsonAdapterProperty;

@interface MAXJAObjectCreator : NSObject

+(instancetype)MAXJACreateObjectOfClass:(Class)aClass withProperties:(NSArray <MAXJsonAdapterProperty *> *)properties;

@end
