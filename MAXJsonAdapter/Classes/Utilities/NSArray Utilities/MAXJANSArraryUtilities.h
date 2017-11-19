//
//  MAXJsonAdapterNSArraryUtilities.h
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 12/29/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAXJANSArraryUtilities : NSObject

+(NSArray <NSString *> *)removeStrings:(NSArray <NSString *> *)strings fromArray:(NSArray <NSString *> *)array;

+(BOOL)array:(NSArray <NSString *> *)array containsString:(NSString *)string;

@end
