//
//  MAXJADictionaryCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJsonAdapter.h>
#import <MAXJsonAdapter/MAXJAPropertyMap.h>

#import "MAXNumberToStringTransformer.h"

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
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJADictionaryIgnoredProprties

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
    
    return @[@"firstName", @"stringAge"];
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
}

@end

#pragma mark - Dictionary Specified Properties

@interface MAXJADictionarySpecifiedProperties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJADictionarySpecifiedProperties

-(NSArray <NSString *> *)MAXJAPropertiesForDictionaryCreation {
    
    return @[@"firstName", @"stringAge"];
}

// should be ignored as the other method takes priority
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
    
    return @[@"firstName"];
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
}

@end

@interface MAXJADictionaryPropertyMapObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJADictionaryPropertyMapObject

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey:@"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: nil]]],
              [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey:@"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey:@"age" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJACreateMapWithNewKey:@"stringAge" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"actualAge" nextPropertyMap:nil]]]
             ];
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
}

@end

@interface MAXJADictionaryPropertyKeyThenArray : NSObject <MAXJsonAdapterDelegate>

@end

@interface MAXJADictionaryPropertyArrayMapObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJADictionaryPropertyArrayMapObject

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"middleName" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"lastName" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"stringAge" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]]
             ];
    
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
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
    object.stringAge = @"36";
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: object delegate: [[MAXJADictionaryIgnoredProprties alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects([dictionary objectForKey: @"firstName"], nil);
    XCTAssertEqualObjects([dictionary objectForKey: @"stringAge"], nil);
    XCTAssertEqualObjects([dictionary objectForKey: @"lastName"], object.lastName);
    XCTAssertEqualObjects([dictionary objectForKey: @"age"], @34);
    
}


#pragma mark - Object Creation Specified Properties

-(void)testDictionaryCreationWithSpecifiedProperties {
    
    MAXJADictionarySpecifiedProperties *object = [[MAXJADictionarySpecifiedProperties alloc] init];
    object.firstName = @"Bruce";
    object.lastName = @"Wayne";
    object.age = @34;
    object.stringAge = @"24";
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: object delegate: [[MAXJADictionarySpecifiedProperties alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects([dictionary objectForKey: @"firstName"], object.firstName);
    XCTAssertEqualObjects([dictionary objectForKey: @"stringAge"], @24);
    XCTAssertEqualObjects([dictionary objectForKey: @"lastName"], nil);
    XCTAssertEqualObjects([dictionary objectForKey: @"age"], nil);
    
}

#pragma mark - Dictionary Mapping

-(void)testDictionaryPropertyKeyMaps {
    
    MAXJADictionaryPropertyMapObject *propertyMap = [[MAXJADictionaryPropertyMapObject alloc] init];
    propertyMap.firstName = @"Bruce";
    propertyMap.lastName = @"Wayne";
    propertyMap.age = @34;
    propertyMap.stringAge = @"24";
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: propertyMap delegate: [[MAXJADictionaryPropertyMapObject alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects( [dictionary objectForKey: @"lastName"],  @"Wayne");
    
    NSDictionary *personDictionary = [dictionary objectForKey:@"person"];
    XCTAssertEqualObjects( @(personDictionary.allKeys.count), @3);
    XCTAssertEqualObjects( [personDictionary objectForKey: @"firstName"],  @"Bruce");
    XCTAssertEqualObjects( [personDictionary objectForKey: @"age"],  @34);
    XCTAssertEqualObjects( [personDictionary objectForKey: @"actualAge"], @24);
    
}

-(void)testDictionaryPropertyKeysArrayMap {
    
    MAXJADictionaryPropertyArrayMapObject *propertyMap = [[MAXJADictionaryPropertyArrayMapObject alloc] init];
    propertyMap.firstName = @"Bruce";
    propertyMap.middleName = @"Batman";
    propertyMap.lastName = @"Wayne";
    propertyMap.stringAge = @"24";
    
    NSDictionary *dictionary = [MAXJsonAdapter MAXJADictFromObject: propertyMap delegate: [[MAXJADictionaryPropertyArrayMapObject alloc] init] ];
    
    XCTAssertNotNil( dictionary );
    XCTAssertEqualObjects( @(dictionary.allKeys.count), @1);
    
    NSDictionary *personDictionary = [dictionary objectForKey: @"person"];
    XCTAssertEqualObjects( @(personDictionary.allKeys.count), @1);
    
    NSArray <NSString *> *names = [personDictionary objectForKey: @"name"];
    XCTAssertEqualObjects( @(names.count), @4);
    
    XCTAssertEqualObjects( [names objectAtIndex: 0], @"Bruce");
    XCTAssertEqualObjects( [names objectAtIndex: 1],  @"Batman");
    XCTAssertEqualObjects( [names objectAtIndex: 2], @"Wayne");
    XCTAssertEqualObjects( [names objectAtIndex: 3], @24);
    
}

#pragma mark Array Methods

@end
