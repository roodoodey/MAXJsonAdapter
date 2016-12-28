//
//  MAXJsonAdapter.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJsonAdapter.h"

@implementation MAXJsonAdapter

#pragma mark - Object Creation From Dictionary

+(id)MAXJACreateObjectOfClass:(Class)aClass delegate:(id<MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary {
    
    MAXJsonAdapter *adapter = [[MAXJsonAdapter alloc] init];
    
    return [adapter p_createInstanceOfClass: aClass delegate: delegate fromDictionary: dictionary];
}

-(id)p_createInstanceOfClass:(Class)aClass delegate:(id <MAXJsonAdapterDelegate>)delegate fromDictionary:(NSDictionary *)dictionary {
    
    return nil;
}

@end
