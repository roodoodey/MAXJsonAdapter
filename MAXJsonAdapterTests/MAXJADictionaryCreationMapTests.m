//
//  MAXJADictionaryCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MAXJsonAdapter.h"
#import "MAXJsonAdapterPropertyMapInfo.h"

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

@interface MAXJADictionaryPropertyMapObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJADictionaryPropertyMapObject

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey:@"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: nil]]],
              [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey:@"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey:@"age" nextPropertyMap: nil]]]
             ];
}

@end

@interface MAXJADictionaryPropertyKeyThenArray : NSObject <MAXJsonAdapterDelegate>

@end

@interface MAXJADictionaryPropertyArrayMapObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;

@end

@implementation MAXJADictionaryPropertyArrayMapObject

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"middleName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"lastName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]]
             ];
    
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

#pragma mark - Dictionary Mapping

-(void)testDictionaryPropertyKeyMaps {
    
    MAXJADictionaryPropertyMapObject *propertyMap = [[MAXJADictionaryPropertyMapObject alloc] init];
    propertyMap.firstName = @"Bruce";
    propertyMap.lastName = @"Wayne";
    propertyMap.age = @34;
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: propertyMap delegate: [[MAXJADictionaryPropertyMapObject alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects( [dictionary objectForKey: @"lastName"],  @"Wayne");
    
    NSDictionary *personDictionary = [dictionary objectForKey:@"person"];
    XCTAssertEqualObjects( @(personDictionary.allKeys.count), @2);
    XCTAssertEqualObjects( [personDictionary objectForKey: @"firstName"],  @"Bruce");
    XCTAssertEqualObjects( [personDictionary objectForKey: @"age"],  @34);
    
}

-(void)testDictionaryPropertyKeysArrayMap {
    
    MAXJADictionaryPropertyArrayMapObject *propertyMap = [[MAXJADictionaryPropertyArrayMapObject alloc] init];
    propertyMap.firstName = @"Bruce";
    propertyMap.middleName = @"Batman";
    propertyMap.lastName = @"Wayne";
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: propertyMap delegate: [[MAXJADictionaryPropertyArrayMapObject alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects( @(dictionary.allKeys.count), @1);
    
    NSDictionary *personDictionary = [dictionary objectForKey: @"person"];
    XCTAssertEqualObjects( @(personDictionary.allKeys.count), @1);
    
    NSArray <NSString *> *names = [personDictionary objectForKey: @"name"];
    XCTAssertEqualObjects( @(names.count), @3);
    
}

-(void)testDictionaryPropertyKeyArrayPropertyKeyMap {
    
    
    
}

@end
