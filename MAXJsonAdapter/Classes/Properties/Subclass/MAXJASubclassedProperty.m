//
//  MAXJASubclassedProperty.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 14/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXJASubclassedProperty.h"
#import "MAXJsonAdapter.h"

@interface MAXJASubclassedProperty ()

@property (nonatomic, strong, nonnull) Class aClass;

@property (nonatomic, strong, nullable) id <MAXJsonAdapterDelegate> delegate;

@end

@implementation MAXJASubclassedProperty

+(instancetype)MAXJAPropertyKey:(NSString *)propertyKey class:(Class)aClass delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    MAXJASubclassedProperty *subclassedProperty = [[MAXJASubclassedProperty alloc] initPropertyKey: propertyKey class: aClass delegate: delegate];
    
    return subclassedProperty;
}

-(id)initPropertyKey:(NSString *)propertyKey class:(Class)aClass delegate:(id<MAXJsonAdapterDelegate>)delegate {
    
    if (self = [super init]) {
        
        _propertyKey = propertyKey;
        _aClass = aClass;
        _delegate = delegate;
        
    }
    
    return self;
}

-(id)JSONObjectFromValue:(id)value {
    
    if ([value isKindOfClass: [NSArray class]]) {
        
        // if the array has no values we can just return an empty one.
        if ([(NSArray *)value count] == 0) {
            
            return @[];
        }
        else {
            
            NSAssert([[(NSArray *)value firstObject] isKindOfClass: _aClass], @"Cannot create a subclasses property with classes that do not match");
            
            // The objects in the array need to be of correct value
            if ([[(NSArray *)value firstObject] isKindOfClass: _aClass]) {
                return [MAXJsonAdapter MAXJAArrayFromArray: (NSArray *)value delegate: _delegate];
            }
            
        }
        
        
        
        return nil;
    }
    else if([value isKindOfClass: _aClass]) {
        
        return [MAXJsonAdapter MAXJADictFromObject: value delegate: _delegate];
    }
    
    // no valid class found
    
    return nil;
    
}

-(id)objectFromValue:(id)value {
    
    if ([value isKindOfClass: [NSArray class]]) {
        
        // if the array is empty we can simply return an empty array
        if ([(NSArray *)value count] == 0) {
            
            return  @[];
        }
        else {
            
            // in order to be able to create an object from a list it must contain an NSDictionary to map unless in edge cases
            // which will not be supported in object subclassing.
            NSAssert([[(NSArray *)value firstObject] isKindOfClass:[NSDictionary class]], @"Cannot create a an object from a list which does not contain an NSDictionary when a property is subclassed.");
            
            if ([[(NSArray *)value firstObject] isKindOfClass:[NSDictionary class]]) {
                return [MAXJsonAdapter MAXJAObjectsOfClass: _aClass delegate: _delegate fromArray: (NSArray *)value];
            }
        }
        
        return nil;
        
    }
    else if([value isKindOfClass: [NSDictionary class]]) {
        
        return [MAXJsonAdapter MAXJAObjectOfClass: _aClass delegate: _delegate fromDictionary: (NSDictionary *)value];
        
    }
    
    return nil;
    
}

@end
