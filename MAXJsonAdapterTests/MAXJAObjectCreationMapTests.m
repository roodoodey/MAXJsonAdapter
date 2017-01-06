//
//  MAXJAObjectCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAXJsonAdapterPropertyMapper.h"

@interface MAXJAObjectCreationMapTests : XCTestCase

@end

#pragma mark - Objects No Delegate

@interface MAXJAObjectNoDelegate : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAObjectNoDelegate


@end

#pragma mark - Object Ignored Keys

@interface MAXJAObjectIgnoredProprties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAObjectIgnoredProprties

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation {
    
    return @[@"firstName"];
}

@end

#pragma mark - Object Specified Properties

@interface MAXJAObjectSpecifiedProperties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAObjectSpecifiedProperties

-(NSArray <NSString *> *)MAXJAPropertiesForObjectCreation {
    
    return @[@"firstName"];
}

// should be ignored as the other method takes priority
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation {
    
    return @[@"firstName"];
}

@end

@interface MAXJAObjectPropertyMap : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAObjectPropertyMap

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: nil]]],
              [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"lastName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"familyName" nextPropertyMap: nil]]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: nil]]]
              ];
    
}

@end

@interface MAXJAObjectPropertyIndexMap : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;

@end

@implementation MAXJAObjectPropertyIndexMap

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"firstName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey:@"name" nextPropertyMap:[MAXJsonAdapterPropertyMap MAXJACreateMapWithIndex: 0 nextPropertyMap: nil]]]],
              [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"middleName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithIndex: 1 nextPropertyMap: nil]]]],
              [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"lastName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithIndex: 2 nextPropertyMap: nil]]]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"person" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"age" nextPropertyMap: nil]]]
              ];
    
}

@end

@implementation MAXJAObjectCreationMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark OBJECT CREATION

#pragma mark - Object Creation Without Delegate

-(void)testObjectCreationWithNoDelegate {
    
    NSDictionary *dict = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34 };
    
    MAXJAObjectNoDelegate *object = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXJAObjectNoDelegate class] delegate: nil fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, @"Bruce");
    XCTAssertEqualObjects(object.lastName, @"Wayne");
    XCTAssertEqualObjects(object.age, @34);
    
}

#pragma mark - Object Creation Ignored Properties

-(void)testObjectCreationWithIgnoredProperty {
    
    NSDictionary *dict = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34 };
    
    MAXJAObjectNoDelegate *object = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXJAObjectIgnoredProprties class] delegate: [[MAXJAObjectIgnoredProprties alloc] init] fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, nil);
    XCTAssertEqualObjects(object.lastName, @"Wayne");
    XCTAssertEqualObjects(object.age, @34);
    
}

#pragma mark - Object Creation Specified Properties

-(void)testObjectCreationWithSpecifiedProperties {
    
    NSDictionary *dict = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34 };
    
    MAXJAObjectNoDelegate *object = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXJAObjectSpecifiedProperties class] delegate: [[MAXJAObjectSpecifiedProperties alloc] init] fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, @"Bruce");
    XCTAssertEqualObjects(object.lastName, nil);
    XCTAssertEqualObjects(object.age, nil);
    
}

#pragma mark - Object Creation Map

-(void)testObjectPropertyKeyMaps {
    
    NSDictionary *dictionary = @{ @"person" : @{ @"firstName" : @"Bruce", @"familyName" : @"Wayne", @"age" : @34 }
                                  };
    
    MAXJAObjectPropertyMap *propertyMapObject = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXJAObjectPropertyMap class] delegate: [[MAXJAObjectPropertyMap alloc] init]  fromDictionary: dictionary];
    
    XCTAssertNotNil( propertyMapObject );
    XCTAssertEqualObjects( propertyMapObject.firstName, @"Bruce");
    XCTAssertEqualObjects( propertyMapObject.lastName, @"Wayne");
    XCTAssertEqualObjects( propertyMapObject.age, @34);
    
}

-(void)testObjectPropertyKeyIndexMaps {
    
    NSDictionary *dictionary = @{ @"person" :
                                      @{ @"name" : @[@"Bruce", @"Batman", @"Wayne" ],
                                         @"age" : @34 }
                                  };
    MAXJAObjectPropertyIndexMap *indexMap = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXJAObjectPropertyIndexMap class] delegate: [MAXJAObjectPropertyIndexMap new] fromDictionary: dictionary];
    
    XCTAssertNotNil( indexMap );
    XCTAssertEqualObjects( indexMap.firstName, @"Bruce");
    XCTAssertEqualObjects( indexMap.middleName, @"Batman");
    XCTAssertEqualObjects( indexMap.lastName, @"Wayne");
    XCTAssertEqualObjects( indexMap.age, @34);
    
}

@end
