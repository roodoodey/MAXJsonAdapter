//
//  MAXJsonAdapterPropertyMapInfo.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/28/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterPropertyMapInfo.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MAXJsonAdapterPropertyMapInfo

+(instancetype)MAXJACreateMapWithNewKey:(NSString *)key nextPropertyMap:(nullable MAXJsonAdapterPropertyMapInfo *)propertyMap {
    
    MAXJsonAdapterPropertyMapInfo *map = [[MAXJsonAdapterPropertyMapInfo alloc] initWithKey: key index: nil nextProperty: propertyMap];
    
    return map;
}

+(instancetype)MAXJACreateMapWithIndex:(int)index nextPropertyMap:(nullable MAXJsonAdapterPropertyMapInfo *)propertyMap {
 
    MAXJsonAdapterPropertyMapInfo *map = [[MAXJsonAdapterPropertyMapInfo alloc] initWithKey: nil index: [NSNumber numberWithInt: index] nextProperty: propertyMap];
    
    return map;
}

-(id)initWithKey:(nullable NSString *)key index:(nullable NSNumber *)index nextProperty:(nullable MAXJsonAdapterPropertyMapInfo *)nextProperty {
    
    if (self = [super init]) {
        _key = key;
        _index = index;
        _nextPropertyMap = nextProperty;
    }
    
    return self;
}

@end

NS_ASSUME_NONNULL_END