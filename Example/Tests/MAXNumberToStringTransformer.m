//
//  MAXNumberToStringTransformer.m
//  MAXJsonAdapterTests
//
//  Created by Mathieu Skulason on 14/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import "MAXNumberToStringTransformer.h"

@implementation MAXNumberToStringTransformer

-(id)MAXJAJsonFormat:(id)value {
    
    return [NSNumber numberWithInt: [value intValue]];
}

-(id)MAXJAObjectCreationFormat:(id)value {
    
    return [value stringValue];
}

@end
