//
//  MAXJsonAdapterValueTransformer.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/9/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAXJsonAdapterValueTransformer : NSObject

@property (nonatomic, strong) NSString *propertyKey;

-(nullable id)MAXJAObjectCreationFormat:(id)object;

-(nullable id)MAXJAJsonFormat:(id)object;

/**
 */
+(instancetype)MAXJACreateValueTransformerWithProperyKey:(NSString *)propertyKey;

/**
 */
-(instancetype)MAXJACreateValueTransformerWithPropertyKey:(NSString *)propertyKey;

@end

NS_ASSUME_NONNULL_END
