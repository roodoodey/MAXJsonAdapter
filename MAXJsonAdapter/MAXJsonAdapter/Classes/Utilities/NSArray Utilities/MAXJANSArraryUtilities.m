//
//  MAXJsonAdapterNSArraryUtilities.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/29/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXJANSArraryUtilities.h"

@implementation MAXJANSArraryUtilities

+(NSArray <NSString *> *)removeStrings:(NSArray<NSString *> *)strings fromArray:(NSArray<NSString *> *)array {
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (NSString *currentString in array) {
        
        if ([MAXJANSArraryUtilities array: strings containsString: currentString] == NO) {
            
            [newArray addObject: currentString];
            
        }
        
    }
    
    return newArray;
}

+(BOOL)array:(NSArray<NSString *> *)array containsString:(NSString *)string {
    
    for (NSString *currentString in array) {
        
        if ([currentString isEqualToString: string] == YES) {
            
            return YES;
        }
        
    }
    
    return NO;
}

@end
