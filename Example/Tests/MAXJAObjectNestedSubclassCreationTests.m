//
//  MAXJAObjectNestedSubclassCreationTests.m
//  MAXJsonAdapterTests
//
//  Created by Mathieu Skulason on 15/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJsonAdapter.h>
#import <MAXJsonAdapter/MAXJASubclassedProperty.h>
#import <MAXJsonAdapter/MAXJAPropertyMap.h>

@interface MAXContainedObjectLevelTwoWithSubclass : NSObject

@property (nonatomic, strong) NSNumber *personAge;
@property (nonatomic, strong) NSString *streetName;

@end

@implementation MAXContainedObjectLevelTwoWithSubclass
@end

@interface MAXContainedObjectLeveLOneWithSubclass : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) MAXContainedObjectLevelTwoWithSubclass *personInfo;

@end

@implementation MAXContainedObjectLeveLOneWithSubclass

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"personInfo"  class: [MAXContainedObjectLevelTwoWithSubclass class] delegate: nil]];
}

@end

#pragma mark -

@interface MAXNestedNormalRootObjectWithoutDelegate : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) MAXContainedObjectLeveLOneWithSubclass *person;

@end

@implementation MAXNestedNormalRootObjectWithoutDelegate

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"person"  class: [MAXContainedObjectLeveLOneWithSubclass class] delegate: [MAXContainedObjectLeveLOneWithSubclass new]]];
}

@end

@interface MAXContainedLevelOneArrayObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray <MAXContainedObjectLevelTwoWithSubclass *> *personInfos;

@end

@implementation MAXContainedLevelOneArrayObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"personInfos" class: [MAXContainedObjectLevelTwoWithSubclass class] delegate: nil]];
}

@end

@interface MAXNestedRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) MAXContainedLevelOneArrayObject *person;

@end

@implementation MAXNestedRootObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"person" class: [MAXContainedLevelOneArrayObject class] delegate: [MAXContainedLevelOneArrayObject new]]];
}

@end

@interface MAXArrayNestedRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSArray <MAXContainedObjectLeveLOneWithSubclass *> *persons;

@end

@implementation MAXArrayNestedRootObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"persons" class: [MAXContainedObjectLeveLOneWithSubclass class] delegate: [MAXContainedObjectLeveLOneWithSubclass new]]];
}

@end

@interface MAXDoubleArrayNestedRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSArray <MAXContainedLevelOneArrayObject *> *persons;

@end

@implementation MAXDoubleArrayNestedRootObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"persons" class: [MAXContainedLevelOneArrayObject class] delegate: [MAXContainedLevelOneArrayObject new]]];
}

@end

@interface MAXJAObjectNestedSubclassCreationTests : XCTestCase

@end

@implementation MAXJAObjectNestedSubclassCreationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testSecondLayerSubclassedProperty {
    
    NSDictionary *dict = @{ @"person" : @{ @"name" : @"Maximus Aurelius", @"personInfo" : @{ @"personAge" : @20, @"streetName" : @"44th Washington Street" } } };
    
    MAXNestedNormalRootObjectWithoutDelegate *rootObj = [MAXJsonAdapter MAXJAObjectOfClass: [MAXNestedNormalRootObjectWithoutDelegate class] delegate: [MAXNestedNormalRootObjectWithoutDelegate new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.person.name, @"Maximus Aurelius");
    XCTAssertEqualObjects( rootObj.person.personInfo.personAge, @20);
    XCTAssertEqualObjects( rootObj.person.personInfo.streetName, @"44th Washington Street");
    
}

-(void)testArrayRootObjectWithTwoLevelSubclassdProperties {
    
    NSDictionary *dict = @{ @"persons" : @[ @{ @"name" : @"Julian Delphiki", @"personInfo" : @{ @"personAge" : @42, @"streetName" : @"Garðsendi" } }, @{ @"name" : @"Petra Arkanian", @"personInfo" : @{ @"personAge" : @33, @"streetName" : @"Tunguvegur" } } ] };
    
    MAXArrayNestedRootObject *rootObj = [MAXJsonAdapter MAXJAObjectOfClass: [MAXArrayNestedRootObject class] delegate: [MAXArrayNestedRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( @(rootObj.persons.count), @2);
    XCTAssertEqualObjects( rootObj.persons[0].name, @"Julian Delphiki");
    XCTAssertEqualObjects( rootObj.persons[0].personInfo.personAge, @42);
    XCTAssertEqualObjects( rootObj.persons[0].personInfo.streetName, @"Garðsendi");
    XCTAssertEqualObjects( rootObj.persons[1].name, @"Petra Arkanian");
    XCTAssertEqualObjects( rootObj.persons[1].personInfo.personAge, @33);
    XCTAssertEqualObjects( rootObj.persons[1].personInfo.streetName, @"Tunguvegur");
    
}

-(void)testSecondLayerArraySubclassedProperty {
    
    NSDictionary *dict = @{ @"person" : @{ @"name" : @"Gengis Khan", @"personInfos" : @[ @{ @"personAge" : @24, @"streetName" : @"Rue Faubourg" }, @{ @"personAge" : @43 } ] } };
    
    MAXNestedRootObject *rootObj = [MAXJsonAdapter MAXJAObjectOfClass: [MAXNestedRootObject class] delegate: [MAXNestedRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.person.name, @"Gengis Khan");
    XCTAssertEqualObjects( rootObj.person.personInfos[0].personAge, @24);
    XCTAssertEqualObjects( rootObj.person.personInfos[0].streetName, @"Rue Faubourg");
    XCTAssertEqualObjects( rootObj.person.personInfos[1].personAge, @43);
    XCTAssertEqualObjects( rootObj.person.personInfos[1].streetName, nil);
    
}

-(void)testDoubleArrayNestedSubclassedProperties {
    
    NSDictionary *dict = @{ @"persons" : @[
                                    @{ @"name" : @"Bonzo Madrid", @"personInfos" : @[ @{ @"personAge" : @14, @"streetName" : @"Greensboro" } ] },
                                    @{ @"name" : @"Peter Wiggin", @"personInfos" : @[ @{ @"personAge" : @16, @"streetName" : @"Carolina" }, @{ @"personAge" : @21,  @"streetName" : @"5th Street" } ] }
                                    ] };
    
    MAXDoubleArrayNestedRootObject *rootObj = [MAXJsonAdapter MAXJAObjectOfClass: [MAXDoubleArrayNestedRootObject class] delegate: [MAXDoubleArrayNestedRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.persons[0].name, @"Bonzo Madrid");
    XCTAssertEqualObjects( @(rootObj.persons[0].personInfos.count), @1);
    XCTAssertEqualObjects( rootObj.persons[0].personInfos[0].personAge, @14);
    XCTAssertEqualObjects( rootObj.persons[0].personInfos[0].streetName, @"Greensboro");
    XCTAssertEqualObjects( @(rootObj.persons[1].personInfos.count), @2);
    XCTAssertEqualObjects( rootObj.persons[1].personInfos[0].personAge, @16);
    XCTAssertEqualObjects( rootObj.persons[1].personInfos[0].streetName, @"Carolina");
    XCTAssertEqualObjects( rootObj.persons[1].personInfos[1].personAge, @21);
    XCTAssertEqualObjects( rootObj.persons[1].personInfos[1].streetName, @"5th Street");
    
}

@end
