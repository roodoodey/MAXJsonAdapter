//
//  MAXJsonAdapterPropertyMapInfo.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/28/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJAPropertyMap.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MAXJAPropertyMap

+(instancetype)MAXJAMapWithKey:(NSString *)key nextPropertyMap:(nullable MAXJAPropertyMap *)propertyMap {
    
    MAXJAPropertyMap *map = [[MAXJAPropertyMap alloc] initWithKey: key index: nil nextProperty: propertyMap];
    
    return map;
}

+(instancetype)MAXJAMapWithIndex:(int)index nextPropertyMap:(nullable MAXJAPropertyMap *)propertyMap {
 
    MAXJAPropertyMap *map = [[MAXJAPropertyMap alloc] initWithKey: nil index: [NSNumber numberWithInt: index] nextProperty: propertyMap];
    
    return map;
}

-(id)initWithKey:(nullable NSString *)key index:(nullable NSNumber *)index nextProperty:(nullable MAXJAPropertyMap *)nextProperty {
    
    if (self = [super init]) {
        _key = key;
        _index = index;
        _nextPropertyMap = nextProperty;
    }
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
