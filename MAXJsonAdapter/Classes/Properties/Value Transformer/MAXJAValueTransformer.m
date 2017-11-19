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

-(id)MAXJAJsonFormat:(id)value {
    
    return value;
}

-(id)MAXJAObjectCreationFormat:(id)value {
    
    return value;
}

#pragma mark - Initialization

+(instancetype)MAXJAValueTransformerWithProperyKey:(NSString *)propertyKey {
    
    return [[[self class] alloc] initValueTransformerWithPropertyKey: propertyKey];
}

-(instancetype)initValueTransformerWithPropertyKey:(NSString *)propertyKey {
    if (self = [super init]) {
        _propertyKey = propertyKey;
    }
    
    return self;
}

@end
