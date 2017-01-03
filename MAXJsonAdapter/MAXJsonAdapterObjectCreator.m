//
//  MAXJsonAdapterObjectCreator.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterObjectCreator.h"

@implementation MAXJsonAdapterObjectCreator

+(instancetype)MAXJACreateObjectOfClass:(Class)aClass withProperties:(NSArray <MAXJsonAdapterProperty *> *)properties {
    
    id object = [[aClass alloc] init];
    
    for (MAXJsonAdapterProperty *currentProperty in properties) {
        
        [object setValue: currentProperty.value forKey: currentProperty.propertyKey];
        
    }
    
    return object;
}

@end
