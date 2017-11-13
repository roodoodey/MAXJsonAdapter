//
//  MAXJARuntimeUtilitiesTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Skulason on 27/12/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAXJsonAdapterRuntimeUtilities.h"

#pragma mark - Runtime Utilities Test Class

@interface MAXJARuntimeUtilitiesTestClass : NSObject

@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSDictionary *anotherProperty;
@property (nonatomic, strong) NSNumber *lastProperty;

@end

@implementation MAXJARuntimeUtilitiesTestClass

@end

#pragma mark - Runtime Utilities Interface

@interface MAXJARuntimeUtilitiesTests : XCTestCase

@end

@implementation MAXJARuntimeUtilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Property Dict Creation From Class

- (void)testCreatePropertyDictForMAXJARuntimeUtilTestClass {
    
    NSArray <NSString *> *propertyList = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameListWithClass: [MAXJARuntimeUtilitiesTestClass class] ];
    
    XCTAssertNotNil( propertyList );
    
    for (NSString *NSObjectKey in [self NSObjectPropertyNames]) {
        
        XCTAssertTrue( [self array: propertyList containsKey: NSObjectKey] );
        
    }
    
    XCTAssertTrue( [self array: propertyList containsKey: @"propertyName"] );
    XCTAssertTrue( [self array: propertyList containsKey: @"anotherProperty"] );
    XCTAssertTrue( [self array: propertyList containsKey: @"lastProperty"] );
    XCTAssertFalse( [self array: propertyList containsKey: @"nonexistentproperty"] );
    
}

- (void)testCreatePropertyDictForMAXJARuntimeUtilTestClassWithoutNSObjectProperties {
    
    NSArray <NSString *> *propertyList = [MAXJsonAdapterRuntimeUtilities MAXJACreatePropertyNameListWithouthNSObjectPropertiesWithClass: [MAXJARuntimeUtilitiesTestClass class] ];
    
    XCTAssertNotNil( propertyList );
    
    for (NSString *NSObjectKey in [self NSObjectPropertyNames]) {
        
        XCTAssertFalse( [self array: propertyList containsKey: NSObjectKey] );
        
    }
    
    XCTAssertTrue( [self array: propertyList containsKey: @"propertyName"] );
    XCTAssertTrue( [self array: propertyList containsKey: @"anotherProperty"] );
    XCTAssertTrue( [self array: propertyList containsKey: @"lastProperty"] );
    XCTAssertTrue( propertyList.count == 3 );
    XCTAssertFalse( [self array: propertyList containsKey: @"nonexistentproperty"] );
    XCTAssertFalse( [self array: propertyList containsKey: @"description"] );
    
}

#pragma mark - Property Enumeration

- (void)testPropertyEnumerationForNSObject {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [MAXJsonAdapterRuntimeUtilities MAXJAEnumeratePropertiesWithClass: [NSObject class] iterationBlock:^(objc_property_t property, NSNumber *stopIteration) {
        
        NSString *propertyName = @(property_getName( property ));
        XCTAssertNotNil( propertyName );
        
    }];
    
}

#pragma mark - Helpers

-(NSArray <NSString *> *)NSObjectPropertyNames {
    return @[@"accessibilityActivationPoint", @"accessibilityCustomActions", @"accessibilityCustomRotors", @"accessibilityElements", @"accessibilityElementsHidden", @"accessibilityFrame", @"accessibilityHeaderElements", @"accessibilityHint", @"accessibilityIdentifier", @"accessibilityLabel", @"accessibilityLanguage", @"accessibilityNavigationStyle", @"accessibilityPath", @"accessibilityTraits", @"accessibilityValue", @"accessibilityViewIsModal", @"autoContentAccessingProxy", @"classForKeyedArchiver", @"debugDescription", @"description", @"hash", @"isAccessibilityElement", @"observationInfo", @"shouldGroupAccessibilityChildren", @"superclass", @"traitStorageList"];
}

-(BOOL)NSObjectContaintsPropertyName:(NSString *)propertyName {
    
    for (NSString *currentString in [self NSObjectPropertyNames]) {
        
        if ([currentString isEqualToString: propertyName] == YES) {
            
            return YES;
        }
        
    }
    
    return NO;
}

-(void)assertAllKeysAreNSObjectPropertyNames:(NSArray <NSString *> *)propertyList file:(NSString *)file line:(int)line {
    
    for (NSString *currentKey in propertyList) {

        if ([self NSObjectContaintsPropertyName: currentKey] == false) {
            NSLog(@"false property Key is: %@", currentKey);
        }
        
        XCTAssertTrue( [self NSObjectContaintsPropertyName: currentKey] );
        
    }
    
}

-(void)assertAllKeysAreNotNSObjectPropertyNames:(NSDictionary <NSString *, NSString *> *)propertyNamesDict {
    
    for (NSString *currentKey in propertyNamesDict.allKeys) {
        
        XCTAssertFalse( [self NSObjectContaintsPropertyName: currentKey] );
        
    }
    
}

-(BOOL)array:(NSArray <NSString *> *)array containsKey:(NSString *)key {
    
    for (NSString *currentKey in array) {
        
        if ([currentKey isEqualToString: key] == YES) {
            
            return YES;
        }
        
    }
    
    return NO;
}

@end
