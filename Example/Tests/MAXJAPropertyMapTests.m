//
//  MAXJAPropertyMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MAXJsonAdapter/MAXJsonAdapter.h>
#import <MAXJsonAdapter/MAXJAPropertyMap.h>
#import <MAXJsonAdapter/MAXJARuntimeUtilities.h>
#import <MAXJsonAdapter/MAXJAPropertyMapper.h>
#import <MAXJsonAdapter/MAXJANSArraryUtilities.h>


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

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    MAXJAPropertyMap *firstMap = [MAXJAPropertyMap MAXJAMapWithKey: @"age" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"fullAge" propertyMap: nil] ];
    
    MAXJAPropertyMap *secondMap = [MAXJAPropertyMap MAXJAMapWithKey: @"title" propertyMap: nil];
    
    
    return @[firstMap, secondMap];
}

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    MAXJAPropertyMap *firstMap = [MAXJAPropertyMap MAXJAMapWithKey: @"name" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 2 propertyMap: nil]];
    
    return @[firstMap];
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

-(void)testPropertyMapSingleLevelObjectCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAPropertyMapObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForObjectCreation: propertyList delegate: [[MAXJAPropertyMapObject alloc] init] ];
    
    XCTAssertNotNil( properties );
    XCTAssertEqualObjects( @(properties.count), @3);
    XCTAssertNil( [self findPropertyWithKey: @"title" inProperties: properties].propertyMap );
    XCTAssertNil( [self findPropertyWithKey: @"name" inProperties: properties].propertyMap );
    XCTAssertEqualObjects( [self findPropertyWithKey: @"age" inProperties: properties].propertyMap.key , @"fullAge");
    
}

-(void)testPropertyMapSingleLevelDictionaryCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAPropertyMapObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForDictionaryCreation: propertyList delegate: [[MAXJAPropertyMapObject alloc] init] ];
    
    XCTAssertNotNil( properties );
    XCTAssertEqualObjects( @(properties.count), @3);
    XCTAssertEqualObjects( [self findPropertyWithKey: @"name" inProperties: properties].propertyMap.index, @2);
    
}

#pragma mark - Without delegate

-(void)testPropertyMapWithoutDelegate {
    
    MAXJAProperty *propertyOne = [[MAXJAProperty alloc] init];
    propertyOne.propertyKey = @"age";
    
    MAXJAProperty *propertyTwo = [[MAXJAProperty alloc] init];
    propertyTwo.propertyKey = @"title";
    
    NSArray <MAXJAProperty *> *properties = @[propertyOne, propertyTwo];
    
    MAXJAPropertyMap *mapOne = [MAXJAPropertyMap MAXJAMapWithKey: @"age" propertyMap: nil];
    MAXJAPropertyMap *mapTwo = [MAXJAPropertyMap MAXJAMapWithKey: @"title" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"fullName" propertyMap: nil] ];
    
    NSArray <MAXJAPropertyMap *> *propertyMaps = @[mapOne, mapTwo];
    
    NSArray <MAXJAProperty *> *mappedProperties = [MAXJAPropertyMapper MAXJAMapPropertyList: properties propertyMaps: propertyMaps];
    
    XCTAssertNotNil( mappedProperties );
    XCTAssertEqualObjects( @(mappedProperties.count), @2);
    XCTAssertNil( [self findPropertyWithKey: @"age" inProperties: mappedProperties].propertyMap );
    XCTAssertEqualObjects( [self findPropertyWithKey: @"title" inProperties: mappedProperties].propertyMap.key, @"fullName");
    
}


#pragma mark - PROPERTY CREATION

-(void)testSinglePropertyCreation {
    
    NSString *singleProperty = @"singleProperty";
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreatePropertyForPropertyList: @[singleProperty] ];
    
    XCTAssertNotNil(properties);
    XCTAssertEqualObjects(@(properties.count), @1);
    XCTAssertEqualObjects(properties.firstObject.propertyKey, @"singleProperty");
    XCTAssertFalse( [self properties: properties containKey: @"doubleProperty"] );
}

-(void)testMultiplePropertyCreation {
    
    NSArray <NSString *> *multipleProperties = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJACreatePropertyForPropertyList: multipleProperties];
    
    XCTAssertTrue(multipleProperties != nil);
    XCTAssertEqualObjects(@(multipleProperties.count) , @3);
    XCTAssertTrue( [self properties: properties containKey: @"title"] );
    XCTAssertTrue( [self properties: properties containKey: @"name"] );
    XCTAssertTrue( [self properties: properties containKey: @"age"] );
    XCTAssertFalse( [self properties: properties containKey: @"doubleProperty"] );

    
}

#pragma mark - EXPLICITLY USED PROPERTIES

#pragma mark - With delegate

-(void)testExplicitPropertiesObjectCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAExplicitPropertiesObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForObjectCreation: propertyList delegate: [[MAXJAExplicitPropertiesObject alloc] init] ];
    
    XCTAssertTrue( properties.count == 2 );
    XCTAssertTrue( [self properties: properties containKey: @"title"] );
    XCTAssertTrue( [self properties: properties containKey: @"balance"] );
    XCTAssertFalse( [self properties: properties containKey: @"name"] );
    XCTAssertFalse( [self properties: properties containKey: @"timeStamp"] );
    XCTAssertFalse( [self properties: properties containKey: @"birthYear"] );
    
}

-(void)testExplicitPropertiesDictionaryCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAExplicitPropertiesObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForDictionaryCreation: propertyList delegate: [[MAXJAExplicitPropertiesObject alloc] init] ];
    
    XCTAssertTrue( properties.count == 2 );
    XCTAssertTrue( [self properties: properties containKey: @"name"] );
    XCTAssertTrue( [self properties: properties containKey: @"timeStamp"] );
    XCTAssertFalse( [self properties: properties containKey: @"title"] );
    XCTAssertFalse( [self properties: properties containKey: @"balance"] );
    XCTAssertFalse( [self properties: properties containKey: @"birthYear"] );

    
}

#pragma mark - Without delegate

-(void)testExplicitSingleProperty {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <NSString *> *propertyListWithExplicitProperties = [MAXJAPropertyMapper MAXJAPropertiesToUseFromPropertyList: propertyList propertiesToUse: @[@"title"]];
    
    XCTAssertNotNil( propertyListWithExplicitProperties );
    XCTAssertTrue( propertyListWithExplicitProperties.count == 1 );
    XCTAssertTrue( [MAXJANSArraryUtilities array: propertyListWithExplicitProperties containsString: @"title"] );
    XCTAssertFalse( [MAXJANSArraryUtilities array: propertyListWithExplicitProperties containsString: @"age"] );
    XCTAssertFalse( [MAXJANSArraryUtilities array: propertyListWithExplicitProperties containsString: @"name"] );

    
}

#pragma mark - IGNORED PROPERTIES

#pragma mark - Remove Ignored Properties With Delegate

-(void)testRemoveIgnoredPropertiesObjectCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForObjectCreation: propertyList delegate: [[MAXJAIgnoredPropertiesObject alloc] init] ];
    
    XCTAssertTrue( properties.count == 2 );
    XCTAssertTrue( [self properties: properties containKey: @"title"] );
    XCTAssertTrue( [self properties: properties containKey: @"age"] );
    XCTAssertFalse( [self properties: properties containKey: @"name"] );
    
}

-(void)testRemoveIgnoredPropertiesDictionaryCreation {
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <MAXJAProperty *> *properties = [MAXJAPropertyMapper MAXJAMapPropertyListForDictionaryCreation: propertyList delegate: [[MAXJAIgnoredPropertiesObject alloc] init] ];
    
    XCTAssertTrue( properties.count == 2 );
    XCTAssertTrue( [self properties: properties containKey: @"name"] );
    XCTAssertTrue( [self properties: properties containKey: @"age"] );
    XCTAssertFalse( [self properties: properties containKey: @"title"] );
    
    
}

#pragma mark - Remove Ignored Properties Without Delegate

-(void)testRemoveSingleIgnoredProperty {
    
    NSArray <NSString *> *ignoredProperties = @[@"title"];
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <NSString *> *propertyListWithRemovedProperties = [MAXJAPropertyMapper MAXJARemoveIgnoredPropertiesFromPropertyList: propertyList ignoredProperties: ignoredProperties];
    
    XCTAssertTrue( propertyListWithRemovedProperties.count == 2 );
    XCTAssertTrue( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"name"] );
    XCTAssertTrue( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"age"] );
    XCTAssertFalse( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"title"] );
    
}

-(void)testRemoveTwoIngoredProperties {
    
    NSArray <NSString *> *ignoredProperties = @[@"title", @"age"];
    
    NSArray <NSString *> *propertyList = [MAXJARuntimeUtilities MAXJAPropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJAIgnoredPropertiesObject class] ];
    
    NSArray <NSString *> *propertyListWithRemovedProperties = [MAXJAPropertyMapper MAXJARemoveIgnoredPropertiesFromPropertyList: propertyList ignoredProperties: ignoredProperties];
    
    XCTAssertTrue( propertyListWithRemovedProperties.count == 1 );
    XCTAssertTrue( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"name"] );
    XCTAssertFalse( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"title"] );
    XCTAssertFalse( [MAXJANSArraryUtilities array: propertyListWithRemovedProperties containsString: @"age"] );
    
}

#pragma mark - Helpers

-(BOOL)properties:(NSArray <MAXJAProperty *> *)properties containKey:(NSString *)key {
    
    for (MAXJAProperty *currentProperty in properties) {
        
        if ([currentProperty.propertyKey isEqualToString: key] == YES) {
            
            return YES;
        }
        
    }
    
    return NO;
}

-(nullable MAXJAProperty *)findPropertyWithKey:(NSString *)key inProperties:(NSArray <MAXJAProperty *> *)properties {
    
    for (MAXJAProperty *currentProperty in properties) {
        
        if ([currentProperty.propertyKey isEqualToString: key] == YES) {
            
            return currentProperty;
        }
        
    }
    
    return nil;
}

@end
