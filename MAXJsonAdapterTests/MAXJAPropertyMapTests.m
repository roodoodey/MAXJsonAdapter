//
//  MAXJAPropertyMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAXJsonAdapterPropertyMapper.h"
#import "MAXJsonAdapterRuntimeUtilities.h"
#import "MAXJsonAdapterPropertyMapInfo.h"

#pragma mark - Ignored Properties Object

@interface MAXJAIgnoredPropertiesObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAIgnoredPropertiesObject

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation {
    
    return @[@"name"];
}

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
    
    return @[@"title"];
}

@end

#pragma mark - Explicit Properties Object

@interface MAXJAExplicitPropertiesObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *birthYear;
@property (nonatomic, strong) NSNumber *balance;

@end

@implementation MAXJAExplicitPropertiesObject

-(NSArray <NSString *> *)MAXJAPropertiesForObjectCreation {
    
    return @[@"title", @"balance"];
}

-(NSArray <NSString *> *)MAXJAPropertiesForDictionaryCreation {
    
    return @[@"name", @"timeStamp"];
}

@end

#pragma mark - Property Map Object

@interface MAXJAPropertyMapObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAPropertyMapObject

-(NSDictionary <NSString *, MAXJsonAdapterPropertyMapInfo *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @{
             @"title" : [MAXJsonAdapterPropertyMapInfo MAXJACreateMapWithNewKey: @"updatedTitle" nextPropertyMap:nil]
             };
    
}

@end

@interface MAXJAPropertyMapTests : XCTestCase

@end

@implementation MAXJAPropertyMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - PROPERTY MAP

#pragma mark - Without delegate

-(void)testSinglePropertyMapWithoutNesting {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAPropertyMapObject class] ];
    
    NSDictionary *map = @{
      @"title" : [MAXJsonAdapterPropertyMapInfo MAXJACreateMapWithNewKey: @"updatedTitle" nextPropertyMap:nil]
      };
    
    NSDictionary *mappedPropertyDictionary = [MAXJsonAdapterPropertyMapper MAXJAMapPropertyDictionary: propertyDict propertyMaps: map];
    
    XCTAssertTrue( mappedPropertyDictionary.count == 3 );
}

#pragma mark - EXPLICITLY USED PROPERTIES

#pragma mark - With delegate

-(void)testExplicitPropertiesObjectCreation {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAExplicitPropertiesObject class] ];
    
    NSDictionary *propertyDictWithExplicitProperties = [MAXJsonAdapterPropertyMapper MAXJAMapPropertyDictionaryForObjectCreation: propertyDict delegate: [[MAXJAExplicitPropertiesObject alloc] init] ];
    
    XCTAssertTrue( propertyDictWithExplicitProperties.count == 2 );
    XCTAssertNotNil( [propertyDictWithExplicitProperties objectForKey: @"title"] );
    XCTAssertNotNil( [propertyDictWithExplicitProperties objectForKey: @"balance"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"name"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"timeStamp"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"birthYear"] );
    
}

-(void)testExplicitPropertiesDictionaryCreation {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAExplicitPropertiesObject class] ];
    
    NSDictionary *propertyDictWithExplicitProperties = [MAXJsonAdapterPropertyMapper MAXJAMapPropertyDictionaryForDictionaryCreation: propertyDict delegate: [[MAXJAExplicitPropertiesObject alloc] init] ];
    
    XCTAssertTrue( propertyDictWithExplicitProperties.count == 2 );
    XCTAssertNotNil( [propertyDictWithExplicitProperties objectForKey: @"name"] );
    XCTAssertNotNil( [propertyDictWithExplicitProperties objectForKey: @"timeStamp"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"title"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"balance"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"birthYear"] );
    
}

#pragma mark - Without delegate

-(void)testExplicitSingleProperty {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSDictionary *propertyDictWithExplicitProperties = [MAXJsonAdapterPropertyMapper MAXJAPropertiesToUseFromPropertyDictionary: propertyDict propertiesToUse: @[@"title"]];
    
    XCTAssertNotNil( propertyDictWithExplicitProperties );
    XCTAssertTrue( propertyDictWithExplicitProperties.count == 1 );
    XCTAssertNotNil( [propertyDictWithExplicitProperties objectForKey: @"title"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"age"] );
    XCTAssertNil( [propertyDictWithExplicitProperties objectForKey: @"name"] );
    
}

#pragma mark - IGNORED PROPERTIES

#pragma mark - Remove Ignored Properties With Delegate

-(void)testRemoveIgnoredPropertiesObjectCreation {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSDictionary *propertyDictWithRemovedProperties = [MAXJsonAdapterPropertyMapper MAXJAMapPropertyDictionaryForObjectCreation: propertyDict delegate: [[MAXJAIgnoredPropertiesObject alloc] init] ];
    
    XCTAssertTrue( propertyDictWithRemovedProperties.count == 2 );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"title"] );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"age"] );
    XCTAssertNil( [propertyDictWithRemovedProperties objectForKey: @"name"] );
    
}

-(void)testRemoveIgnoredPropertiesDictionaryCreation {
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSDictionary *propertyDictWithRemovedProperties = [MAXJsonAdapterPropertyMapper MAXJAMapPropertyDictionaryForDictionaryCreation: propertyDict delegate: [[MAXJAIgnoredPropertiesObject alloc] init] ];
    
    XCTAssertTrue( propertyDictWithRemovedProperties.count == 2 );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"name"] );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"age"] );
    XCTAssertNil( [propertyDictWithRemovedProperties objectForKey: @"title"] );
    
    
}

#pragma mark - Remove Ignored Properties Without Delegate

-(void)testRemoveSingleIgnoredProperty {
    
    NSArray <NSString *> *ignoredProperties = @[@"title"];
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSDictionary *propertyDictWithRemovedProperties = [MAXJsonAdapterPropertyMapper MAXJARemoveIgnoredPropertyFromPropertyDictionary: propertyDict ignoredProperties: ignoredProperties];
    
    XCTAssertTrue( propertyDictWithRemovedProperties.count == 2 );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"name"] );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"age"] );
    XCTAssertNil( [propertyDictWithRemovedProperties objectForKey: @"title"] );
    
}

-(void)testRemoveTwoIngoredProperties {
    
    NSArray <NSString *> *ignoredProperties = @[@"title", @"age"];
    
    NSDictionary *propertyDict = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameDictionaryWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSDictionary *propertyDictWithRemovedProperties = [MAXJsonAdapterPropertyMapper MAXJARemoveIgnoredPropertyFromPropertyDictionary: propertyDict ignoredProperties: ignoredProperties];
    
    XCTAssertTrue( propertyDictWithRemovedProperties.count == 1 );
    XCTAssertNotNil( [propertyDictWithRemovedProperties objectForKey: @"name"] );
    XCTAssertNil( [propertyDictWithRemovedProperties objectForKey: @"title"] );
    XCTAssertNil( [propertyDictWithRemovedProperties objectForKey: @"age"] );
    
}

@end