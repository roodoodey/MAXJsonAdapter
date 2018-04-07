//
//  MAXJsonAdapterProperty.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/29/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJAProperty.h"

@implementation MAXJAProperty

-(nullable id)value {
    
    if (_value == nil) {
        return [NSNull null]
    }
    
    return _value;
}

@end
