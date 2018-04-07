//
//  MAXJAArrayDictionaryCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/6/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJsonAdapter.h>
#import <MAXJsonAdapter/MAXJAProperty.h>
#import <MAXJsonAdapter/MAXJAPropertyMap.h>

@interface MAXJAArrayFirstLevelCreation : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;

@end

@implementation MAXJAArrayFirstLevelCreation

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: -1 propertyMap: nil]],
              [MAXJAPropertyMap MAXJAMapWithKey: @"middleName" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: -1 propertyMap: nil]],
              [MAXJAPropertyMap MAXJAMapWithKey: @"lastName" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: -1 propertyMap: nil]]
             ];
}

@end

@interface MAXJAArraySecondLevelCreation : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAArraySecondLevelCreation

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 1 propertyMap: nil]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"secondName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 0 propertyMap: nil]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"lastName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" propertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 2 propertyMap: nil]]]
              ];
}

@end

@interface MAXJAArrayDictionaryCreationMapTests : XCTestCase

@end

@implementation MAXJAArrayDictionaryCreationMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCreatingArrayOfValues {
    
    MAXJAArrayFirstLevelCreation *arrayCreationObject = [[MAXJAArrayFirstLevelCreation alloc] init];
    
    arrayCreationObject.firstName = @"Mathieu";
    arrayCreationObject.middleName = @"Grettir";
    arrayCreationObject.lastName = @"Skúlason";
    
    NSArray *array = [MAXJsonAdapter MAXJAArrayFromObject: arrayCreationObject delegate: [[MAXJAArrayFirstLevelCreation alloc] init] ];
    
    XCTAssertNotNil( array );
    XCTAssertEqualObjects( @(array.count), @3);
    
    NSString *firstName = [array objectAtIndex: 0];
    XCTAssertEqualObjects(firstName, @"Mathieu");
    
    NSString *middleName = [array objectAtIndex: 1];
    XCTAssertEqualObjects(middleName, @"Grettir");
    
    NSString *lastName = [array objectAtIndex: 2];
    XCTAssertEqualObjects(lastName, @"Skúlason");
    
}

-(void)testCreatingMappedPropertyKeyToArray {
    
    MAXJAArraySecondLevelCreation *arrayCreationObject = [[MAXJAArraySecondLevelCreation alloc] init];
    arrayCreationObject.firstName = @"Mathieu";
    arrayCreationObject.secondName = @"Grettir";
    arrayCreationObject.lastName = @"Skúlason";
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: arrayCreationObject delegate: [[MAXJAArraySecondLevelCreation alloc] init] ];
    
    XCTAssertNotNil( dict );
    XCTAssertEqualObjects( @(dict.allKeys.count), @2);
    XCTAssertEqualObjects([dict objectForKey:@"age"], [NSNull null]);
    
    NSArray <NSString *> *array = [dict objectForKey: @"person"];
    
    XCTAssertEqualObjects( @(array.count), @3);
    
}

@end
