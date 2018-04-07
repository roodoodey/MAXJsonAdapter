//
//  MAXJsonAdapterValueTransformer.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/9/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJAValueTransformer.h"

@implementation MAXJAValueTransformer

#pragma mark - Private Initializers

-(BOOL)containsKey:(NSString *)key {
    
    for (NSString *currentKey in _propertyKeys) {
        if ([currentKey isEqualToString: key]) {
            return YES;
        }
    }
    
    return NO;
}

-(id)MAXJAJsonFormat:(id)value {
    
    return value;
}

-(id)MAXJAObjectCreationFormat:(id)value {
    
    return value;
}

#pragma mark - Initialization

+(instancetype)MAXJAValueTransformerWithProperyKey:(NSString *)propertyKey {
    
    return [[[self class] alloc] initValueTransformerWithPropertyKeys: @[propertyKey]];
}

+(instancetype)MAXJAValueTransofmerWithPropertyKeys:(NSArray<NSString *> *)propertyKeys {
    return [[[self class] alloc] initValueTransformerWithPropertyKeys: propertyKeys];
}

-(instancetype)initValueTransformerWithPropertyKeys:(NSArray <NSString *>  *)propertyKeys {
    if (self = [super init]) {
        _propertyKeys = propertyKeys;
    }
    
    return self;
}

-(instancetype)initValueTransformerWithPropertyKey:(NSString *)propertyKey {
    return [self initValueTransformerWithPropertyKeys: @[propertyKey]];
}

@end
