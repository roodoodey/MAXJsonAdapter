//
//  MAXJADictionaryCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MAXJsonAdapter.h"

#pragma mark - Dictionary No Delegate

@interface MAXJADictionaryNoDelegate : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJADictionaryNoDelegate


@end

#pragma mark - Dictionary Ignored Keys

@interface MAXJADictionaryIgnoredProprties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJADictionaryIgnoredProprties

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
    
    return @[@"firstName"];
}

@end

#pragma mark - Dictionary Specified Properties

@interface MAXJADictionarySpecifiedProperties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJADictionarySpecifiedProperties

-(NSArray <NSString *> *)MAXJAPropertiesForDictionaryCreation {
    
    return @[@"firstName"];
}

// should be ignored as the other method takes priority
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
    
    return @[@"firstName"];
}

@end

@interface MAXJADictionaryCreationMapTests : XCTestCase

@end

@implementation MAXJADictionaryCreationMapTests


#pragma mark Dictionary CREATION

#pragma mark - Dictionary Creation Without Delegate

-(void)testDictionaryCreationWithNoDelegate {
    
    MAXJADictionaryNoDelegate *object = [[MAXJADictionaryNoDelegate alloc] init];
    object.firstName = @"Bruce";
    object.lastName = @"Wayne";
    object.age = @34;
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: object delegate: nil];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects([dictionary objectForKey: @"firstName"], object.firstName);
    XCTAssertEqualObjects([dictionary objectForKey: @"lastName"], object.lastName);
    XCTAssertEqualObjects([dictionary objectForKey: @"age"], object.age);
}


#pragma mark - Dictionary Creation Ignored Properties

-(void)testDictionaryCreationWithIgnoredProperty {
    
    MAXJADictionaryIgnoredProprties *object = [[MAXJADictionaryIgnoredProprties alloc] init];
    object.firstName = @"Bruce";
    object.lastName = @"Wayne";
    object.age = @34;
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: object delegate: [[MAXJADictionaryIgnoredProprties alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects([dictionary objectForKey: @"firstName"], nil);
    XCTAssertEqualObjects([dictionary objectForKey: @"lastName"], object.lastName);
    XCTAssertEqualObjects([dictionary objectForKey: @"age"], @34);
    
}


#pragma mark - Object Creation Specified Properties

-(void)testDictionaryCreationWithSpecifiedProperties {
    
    MAXJADictionarySpecifiedProperties *object = [[MAXJADictionarySpecifiedProperties alloc] init];
    object.firstName = @"Bruce";
    object.lastName = @"Wayne";
    object.age = @34;
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: object delegate: [[MAXJADictionarySpecifiedProperties alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects([dictionary objectForKey: @"firstName"], object.firstName);
    XCTAssertEqualObjects([dictionary objectForKey: @"lastName"], nil);
    XCTAssertEqualObjects([dictionary objectForKey: @"age"], nil);
    
}


@end
