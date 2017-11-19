//
//  MAXJASubclassedProperty.h
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 14/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAXJsonAdapterDelegate;

/*
 @description A class which takes a property which needs to be serialized and deserialized separately. This can be used for any custom object that subclasses NSObject and has its own properties to be serialized and deserialized.
 */
@interface MAXJASubclassedProperty : NSObject

@property (nonatomic, strong, nonnull) NSString *propertyKey;


+(nonnull instancetype)MAXJAPropertyKey:(nonnull NSString *)propertyKey class:(nonnull Class)aClass delegate:(nullable id <MAXJsonAdapterDelegate>)delegate;

-(nonnull id)initPropertyKey:(nonnull NSString *)propertyKey class:(nonnull Class)aClass delegate:(nullable id <MAXJsonAdapterDelegate>)delegate;


-(nullable id)JSONObjectFromValue:(nonnull id)value;


-(nullable id)objectFromValue:(nonnull id)value;

@end
