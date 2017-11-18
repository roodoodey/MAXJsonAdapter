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
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJAMapWithKey: @"name" propertyMap: nil];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: singlePropertyDictionary];
    
    XCTAssertEqualObjects(value, @"Batman");
    
}

-(void)testSearchPropertyKeyThenPropertyKey {
    
    NSDictionary *dictionary = @{ @"person" : @{ @"name" : @"Superman" }
     };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"name" propertyMap: nil] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Superman");
}

-(void)testSearchPropertyKeyThenIndex {
    
    NSDictionary *dictionary = @{ @"person" : @[ @"firstPerson", @"secondPerson", @"thirdPerson"] };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 1 propertyMap:nil] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"secondPerson");
    
}

-(void)testSearchPropertyKeyThenIndexThenPropertyKey {
    
    NSDictionary *dictionary = @{ @"person" : @[ @{@"name": @"Thor"}, @{@"name" : @"Ant Man"}, @{@"name" : @"Black Widow"}] };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 2 propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"name"  propertyMap: nil] ] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Black Widow");
    
}

-(void)testSearchPropertyKeyThenPropertyKeyThenIndex {
    
    NSDictionary *dictionary = @{ @"countries" : @{ @"persons" : @[@"Hulk", @"Iron Man", @"Hawkeye"] } };
    
    MAXJAPropertyMap *propertyMap = [MAXJAPropertyMap MAXJAMapWithKey: @"countries" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"persons" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 1 propertyMap: nil] ] ];
    
    id value = [MAXJAPropertySearcher MAXJASearchForProperty: propertyMap inDictionary: dictionary];
    
    XCTAssertEqualObjects(value, @"Iron Man");
    
}

@end
