//
//  MAXJADictionarySubclassCreationTests.m
//  MAXJsonAdapterTests
//
//  Created by Mathieu Skulason on 16/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJsonAdapter.h>
#import <MAXJsonAdapter/MAXJASubclassedProperty.h>
#import <MAXJsonAdapter/MAXJAPropertyMap.h>

@interface MAXJASingleContainedObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJASingleContainedObject

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[
             [MAXJAPropertyMap MAXJAMapWithKey: @"age" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"ageNumber" nextPropertyMap: nil]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"name" nextPropertyMap: nil]]
             ];
}


@end

@interface MAXPersonObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *personIdentifier;

@property (nonatomic, strong) MAXJASingleContainedObject *person;

@end

@implementation MAXPersonObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"person" class: [MAXJASingleContainedObject class] delegate: nil]];
}

@end

@interface MAXPersonObjectWithMapping : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *personIdentifier;

@property (nonatomic, strong) MAXJASingleContainedObject *person;

@end

@implementation MAXPersonObjectWithMapping

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"person" class: [MAXJASingleContainedObject class] delegate: [MAXJASingleContainedObject new]]];
}

@end

@interface MAXArrayPersonObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *personIdentifier;

@property (nonatomic, strong) NSArray <MAXJASingleContainedObject *> *persons;

@end

@implementation MAXArrayPersonObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"persons" class: [MAXJASingleContainedObject class] delegate: nil]];
}

@end

@interface MAXArrayPersonObjectWithMapping : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *personIdentifier;

@property (nonatomic, strong) NSArray <MAXJASingleContainedObject *> *persons;

@end

@implementation MAXArrayPersonObjectWithMapping

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"persons" class: [MAXJASingleContainedObject class] delegate: [MAXJASingleContainedObject new]]];
}

@end

@interface MAXMapPersonNameDelegate : NSObject <MAXJsonAdapterDelegate>

@end

@implementation MAXMapPersonNameDelegate

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"person" class: [MAXJASingleContainedObject class] delegate: nil]];
}

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[[MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personData" nextPropertyMap: nil]]];
}

@end

@interface MAXMapArrayPersonNameDelegate : NSObject <MAXJsonAdapterDelegate>

@end

@implementation MAXMapArrayPersonNameDelegate

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"persons" class: [MAXJASingleContainedObject class] delegate: nil]];
}

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
    
    return @[[MAXJAPropertyMap MAXJAMapWithKey: @"persons" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personsData" nextPropertyMap: nil]]];
}

@end

@interface MAXJADictionarySubclassCreationTests : XCTestCase

@end

@implementation MAXJADictionarySubclassCreationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testDictFromOneLevelNestedObject {
    
    MAXPersonObject *person = [[MAXPersonObject alloc] init];
    person.personIdentifier = @"123";
    
    MAXJASingleContainedObject *containedObj = [[MAXJASingleContainedObject alloc] init];
    containedObj.firstName = @"Julian";
    containedObj.lastName = @"Delphiki";
    containedObj.age = @23;
    
    person.person = containedObj;
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXPersonObject new]];
    
    XCTAssertEqualObjects([dict objectForKey: @"personIdentifier"], @"123");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"firstName"], @"Julian");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"lastName"], @"Delphiki");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"age"], @23);
    
}

-(void)testDictFromOneLEvelNestedObjectWithTopLevelMapping {
    
    MAXPersonObject *person = [[MAXPersonObject alloc] init];
    person.personIdentifier = @"123";
    
    MAXJASingleContainedObject *containedObj = [[MAXJASingleContainedObject alloc] init];
    containedObj.firstName = @"Julian";
    containedObj.lastName = @"Delphiki";
    containedObj.age = @23;
    
    person.person = containedObj;
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXMapPersonNameDelegate new]];
    
    XCTAssertEqualObjects([dict objectForKey: @"personIdentifier"], @"123");
    XCTAssertEqualObjects([[dict objectForKey: @"personData"] objectForKey: @"firstName"], @"Julian");
    XCTAssertEqualObjects([[dict objectForKey: @"personData"] objectForKey: @"lastName"], @"Delphiki");
    XCTAssertEqualObjects([[dict objectForKey: @"personData"] objectForKey: @"age"], @23);
    
}

-(void)testDictFromOneLevelNestedObjectWithSecondLevelMapping {
    
    MAXPersonObjectWithMapping *person = [[MAXPersonObjectWithMapping alloc] init];
    person.personIdentifier = @"123";
    
    MAXJASingleContainedObject *containedObj = [[MAXJASingleContainedObject alloc] init];
    containedObj.firstName = @"Julian";
    containedObj.lastName = @"Delphiki";
    containedObj.age = @23;
    
    person.person = containedObj;
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXPersonObjectWithMapping new]];
    
    XCTAssertEqualObjects([dict objectForKey: @"personIdentifier"], @"123");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"name"], @"Julian");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"lastName"], @"Delphiki");
    XCTAssertEqualObjects([[dict objectForKey: @"person"] objectForKey: @"ageNumber"], @23);
    
}

-(void)testArrayFromOneLevelNestedObject {
    
    MAXArrayPersonObject *person = [[MAXArrayPersonObject alloc] init];
    person.personIdentifier = @"123456";
    
    MAXJASingleContainedObject *containedObjOne = [[MAXJASingleContainedObject alloc] init];
    containedObjOne.firstName = @"Ender";
    containedObjOne.lastName = @"Wiggin";
    containedObjOne.age = @34;
    
    MAXJASingleContainedObject *containedObjTwo = [[MAXJASingleContainedObject alloc] init];
    containedObjTwo.firstName = @"Valentine";
    containedObjTwo.lastName = @"Wiggin";
    containedObjTwo.age = @24;
    
    person.persons = @[containedObjOne, containedObjTwo];
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXArrayPersonObject new]];
    
    XCTAssertEqualObjects([dict objectForKey:@"personIdentifier"], @"123456");
    
    NSDictionary *firstObj = [[dict objectForKey:@"persons"] objectAtIndex: 0];
    XCTAssertEqualObjects([firstObj objectForKey:@"firstName"], @"Ender");
    XCTAssertEqualObjects([firstObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([firstObj objectForKey:@"age"], @34);
    
    NSDictionary *secondObj = [[dict objectForKey:@"persons"] objectAtIndex: 1];
    XCTAssertEqualObjects([secondObj objectForKey:@"firstName"], @"Valentine");
    XCTAssertEqualObjects([secondObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([secondObj objectForKey:@"age"], @24);
    
}

-(void)testArrayFromOneLevelNestedObjectWithTopLevelMapping {
    
    MAXArrayPersonObject *person = [[MAXArrayPersonObject alloc] init];
    person.personIdentifier = @"123456";
    
    MAXJASingleContainedObject *containedObjOne = [[MAXJASingleContainedObject alloc] init];
    containedObjOne.firstName = @"Ender";
    containedObjOne.lastName = @"Wiggin";
    containedObjOne.age = @34;
    
    MAXJASingleContainedObject *containedObjTwo = [[MAXJASingleContainedObject alloc] init];
    containedObjTwo.firstName = @"Valentine";
    containedObjTwo.lastName = @"Wiggin";
    containedObjTwo.age = @24;
    
    person.persons = @[containedObjOne, containedObjTwo];
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXMapArrayPersonNameDelegate new]];
    
    XCTAssertEqualObjects([dict objectForKey:@"personIdentifier"], @"123456");
    
    NSDictionary *firstObj = [[dict objectForKey:@"personsData"] objectAtIndex: 0];
    XCTAssertEqualObjects([firstObj objectForKey:@"firstName"], @"Ender");
    XCTAssertEqualObjects([firstObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([firstObj objectForKey:@"age"], @34);
    
    NSDictionary *secondObj = [[dict objectForKey:@"personsData"] objectAtIndex: 1];
    XCTAssertEqualObjects([secondObj objectForKey:@"firstName"], @"Valentine");
    XCTAssertEqualObjects([secondObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([secondObj objectForKey:@"age"], @24);
    
}

-(void)testArrayFromOneLevelNestedObjectWithSecondLevelMapping {
    
    MAXArrayPersonObjectWithMapping *person = [[MAXArrayPersonObjectWithMapping alloc] init];
    person.personIdentifier = @"123456";
    
    MAXJASingleContainedObject *containedObjOne = [[MAXJASingleContainedObject alloc] init];
    containedObjOne.firstName = @"Ender";
    containedObjOne.lastName = @"Wiggin";
    containedObjOne.age = @34;
    
    MAXJASingleContainedObject *containedObjTwo = [[MAXJASingleContainedObject alloc] init];
    containedObjTwo.firstName = @"Valentine";
    containedObjTwo.lastName = @"Wiggin";
    containedObjTwo.age = @24;
    
    person.persons = @[containedObjOne, containedObjTwo];
    
    NSDictionary *dict = [MAXJsonAdapter MAXJADictFromObject: person delegate: [MAXArrayPersonObjectWithMapping new]];
    
    XCTAssertEqualObjects([dict objectForKey:@"personIdentifier"], @"123456");
    
    NSDictionary *firstObj = [[dict objectForKey:@"persons"] objectAtIndex: 0];
    XCTAssertEqualObjects([firstObj objectForKey:@"name"], @"Ender");
    XCTAssertEqualObjects([firstObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([firstObj objectForKey:@"ageNumber"], @34);
    
    NSDictionary *secondObj = [[dict objectForKey:@"persons"] objectAtIndex: 1];
    XCTAssertEqualObjects([secondObj objectForKey:@"name"], @"Valentine");
    XCTAssertEqualObjects([secondObj objectForKey:@"lastName"], @"Wiggin");
    XCTAssertEqualObjects([secondObj objectForKey:@"ageNumber"], @24);
    
}

@end
