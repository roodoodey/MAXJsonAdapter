//
//  MAXJAPropertySearcherTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/5/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJAPropertyMap.h>
#import <MAXJsonAdapter/MAXJAPropertySearcher.h>

@interface MAXJAPropertySearcherTests : XCTestCase

@end

@implementation MAXJAPropertySearcherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testSearchPropertyKeyOneLevel {
    
    NSDictionary *singlePropertyDictionary = @{ @"name" : @"Batman" };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: singlePropertyDictionary];
    
    XCTAssertEqualObjects(value, @"Batman");
    
}

-(void)testSearchPropertyKeyThenPropertyKey {
    
    NSDictionary *dictionary = @{ @"person" : @{ @"name" : @"Superman" }
     };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Superman");
}

-(void)testSearchPropertyKeyThenIndex {
    
    NSDictionary *dictionary = @{ @"person" : @[ @"firstPerson", @"secondPerson", @"thirdPerson"] };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithIndex: 1 nextPropertyMap:nil] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"secondPerson");
    
}

-(void)testSearchPropertyKeyThenIndexThenPropertyKey {
    
    NSDictionary *dictionary = @{ @"person" : @[ @{@"name": @"Thor"}, @{@"name" : @"Ant Man"}, @{@"name" : @"Black Widow"}] };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithIndex: 2 nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"name"  nextPropertyMap: nil] ] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Black Widow");
    
}

-(void)testSearchPropertyKeyThenPropertyKeyThenIndex {
    
    NSDictionary *dictionary = @{ @"countries" : @{ @"persons" : @[@"Hulk", @"Iron Man", @"Hawkeye"] } };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"countries" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithNewKey: @"persons" nextPropertyMap: [MAXJAPropertyMap MAXJACreateMapWithIndex: 1 nextPropertyMap: nil] ] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Iron Man");
    
}

@end
