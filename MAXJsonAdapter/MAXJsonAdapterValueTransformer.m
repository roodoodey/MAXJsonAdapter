//
//  MAXJsonAdapterValueTransformer.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/9/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapterValueTransformer.h"

@implementation MAXJsonAdapterValueTransformer

#pragma mark - Private Initializers

-(id)MAXJAJsonFormat:(id)value {
    
    return value;
}

-(id)MAXJAObjectCreationFormat:(id)value {
    
    return value;
}

#pragma mark - Initialization

+(instancetype)MAXJACreateValueTransformerWithProperyKey:(NSString *)propertyKey {
    
    MAXJsonAdapterValueTransformer *valueTransformer = [[MAXJsonAdapterValueTransformer alloc] MAXJACreateValueTransformerWithPropertyKey: propertyKey];
    
    return valueTransformer;
}

-(instancetype)MAXJACreateValueTransformerWithPropertyKey:(NSString *)propertyKey {
    
    MAXJsonAdapterValueTransformer *valueTransformer = [[MAXJsonAdapterValueTransformer alloc] init];
    valueTransformer.propertyKey = propertyKey;
    
    return valueTransformer;
}

@end
