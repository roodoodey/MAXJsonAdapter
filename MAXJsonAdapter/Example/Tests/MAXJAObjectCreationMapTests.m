//
//  MAXJAObjectCreationMapTests.m
//  MAXJsonAdapter
//
//  Created by Mathieu Grettir Skulason on 1/3/17.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <MAXJsonAdapter/MAXJAPropertyMapper.h>

#import "MAXNumberToStringTransformer.h"

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
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJAObjectIgnoredProprties

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation {
    
    return @[@"firstName"];
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey: @"stringAge"]];
}

@end

#pragma mark - Object Specified Properties

@interface MAXJAObjectSpecifiedProperties : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJAObjectSpecifiedProperties

-(NSArray <NSString *> *)MAXJAPropertiesForObjectCreation {
    
    return @[@"firstName"];
}

// should be ignored as the other method takes priority
-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreObjectCreation {
    
    return @[@"firstName"];
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
}

@end

@interface MAXJAObjectPropertyMap : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJAObjectPropertyMap

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" nextPropertyMap: nil]]],
              [MAXJAPropertyMap MAXJAMapWithKey: @"lastName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"familyName" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"age" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"age" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"stringAge" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey:@"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey:@"stringifiedAge" nextPropertyMap:nil]]]
              ];
    
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
}

@end

@interface MAXJAObjectPropertyIndexMap : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *stringAge;

@end

@implementation MAXJAObjectPropertyIndexMap

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJAPropertyMap MAXJAMapWithKey: @"firstName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey:@"name" nextPropertyMap:[MAXJAPropertyMap MAXJAMapWithIndex: 0 nextPropertyMap: nil]]]],
              [MAXJAPropertyMap MAXJAMapWithKey: @"middleName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"name" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 1 nextPropertyMap: nil]]]],
              [MAXJAPropertyMap MAXJAMapWithKey: @"lastName" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"name" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithIndex: 2 nextPropertyMap: nil]]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"age" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"age" nextPropertyMap: nil]]],
             [MAXJAPropertyMap MAXJAMapWithKey: @"stringAge" nextPropertyMap:[MAXJAPropertyMap MAXJAMapWithKey: @"person" nextPropertyMap:[MAXJAPropertyMap MAXJAMapWithKey: @"differentAges" nextPropertyMap:[MAXJAPropertyMap MAXJAMapWithIndex: 1 nextPropertyMap: nil]]]]
              ];
    
}

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
    
    return @[[MAXNumberToStringTransformer MAXJACreateValueTransformerWithProperyKey:@"stringAge"]];
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
    
    MAXJAObjectNoDelegate *object = [MAXJsonAdapter MAXJAObjectOfClass: [MAXJAObjectNoDelegate class] delegate: nil fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, @"Bruce");
    XCTAssertEqualObjects(object.lastName, @"Wayne");
    XCTAssertEqualObjects(object.age, @34);
    
}

-(void)testArrayObjectCreationWithNoDelegate {
    
    NSDictionary *dictOne = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34 };
    
    NSDictionary *dictTwo = @{ @"firstName" : @"Peter", @"lastName" : @"Parker", @"age" : @18 };
    
    NSArray <MAXJAObjectNoDelegate *> *objects = [MAXJsonAdapter MAXJAObjectsOfClass: [MAXJAObjectNoDelegate class] delegate: nil fromArray: @[dictOne, dictTwo] ];
    
    XCTAssertEqualObjects( @(objects.count),  @2);
    
    MAXJAObjectNoDelegate *objectOne = objects.firstObject;
    MAXJAObjectNoDelegate *objectTwo = [objects objectAtIndex: 1];
    
    XCTAssertEqualObjects( objectOne.firstName, @"Bruce");
    XCTAssertEqualObjects( objectOne.lastName, @"Wayne");
    XCTAssertEqualObjects( objectOne.age, @34);
    
    XCTAssertEqualObjects( objectTwo.firstName,  @"Peter");
    XCTAssertEqualObjects( objectTwo.lastName,  @"Parker");
    XCTAssertEqualObjects( objectTwo.age, @18);
    
}

#pragma mark - Object Creation Ignored Properties

-(void)testObjectCreationWithIgnoredProperty {
    
    NSDictionary *dict = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34, @"stringAge" : @52 };
    
    MAXJAObjectIgnoredProprties *object = [MAXJsonAdapter MAXJAObjectOfClass: [MAXJAObjectIgnoredProprties class] delegate: [[MAXJAObjectIgnoredProprties alloc] init] fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, nil);
    XCTAssertEqualObjects(object.lastName, @"Wayne");
    XCTAssertEqualObjects(object.age, @34);
    XCTAssertEqualObjects(object.stringAge, @"52");
    
}

-(void)testArrayObjectCreationWithIgnoredProperty {
    
    NSDictionary *dictOne = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34, @"stringAge" : @17 };
    
    NSDictionary *dictTwo = @{ @"firstName" : @"Peter", @"lastName" : @"Parker", @"age" : @18, @"stringAge" : @21 };
    
    NSArray *objects = [MAXJsonAdapter MAXJAObjectsOfClass: [MAXJAObjectIgnoredProprties class] delegate: [[MAXJAObjectIgnoredProprties alloc] init] fromArray: @[dictOne, dictTwo] ];
    
    XCTAssertEqualObjects( @(objects.count), @2);
    
    MAXJAObjectIgnoredProprties *firstObject = objects.firstObject;
    
    XCTAssertEqualObjects( firstObject.firstName, nil);
    XCTAssertEqualObjects( firstObject.lastName, @"Wayne");
    XCTAssertEqualObjects( firstObject.age, @34);
    XCTAssertEqualObjects( firstObject.stringAge, @"17");
    
    MAXJAObjectIgnoredProprties *secondObject = [objects objectAtIndex: 1];
    
    XCTAssertEqualObjects( secondObject.firstName, nil);
    XCTAssertEqualObjects( secondObject.lastName, @"Parker");
    XCTAssertEqualObjects( secondObject.age, @18);
    XCTAssertEqualObjects( secondObject.stringAge, @"21");
    
}

#pragma mark - Object Creation Specified Properties

-(void)testObjectCreationWithSpecifiedProperties {
    
    NSDictionary *dict = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34, @"stringAge" : @21 };
    
    MAXJAObjectSpecifiedProperties *object = [MAXJsonAdapter MAXJAObjectOfClass: [MAXJAObjectSpecifiedProperties class] delegate: [[MAXJAObjectSpecifiedProperties alloc] init] fromDictionary: dict];
    
    XCTAssertNotNil( object );
    XCTAssertEqualObjects(object.firstName, @"Bruce");
    XCTAssertEqualObjects(object.lastName, nil);
    XCTAssertEqualObjects(object.age, nil);
    XCTAssertEqualObjects(object.stringAge, nil);
    
}

-(void)testArrayObjectCreationWithSpecifiedProperties {
    
    NSDictionary *dictOne = @{ @"firstName" : @"Bruce", @"lastName" : @"Wayne", @"age" : @34, @"stringAge" : @21 };

    NSDictionary *dictTwo = @{ @"firstName" : @"Peter", @"lastName" : @"Parker", @"age" : @18, @"stringAge" : @23 };

    NSArray *objects = [MAXJsonAdapter MAXJAObjectsOfClass:  [MAXJAObjectSpecifiedProperties class] delegate: [[MAXJAObjectSpecifiedProperties alloc] init] fromArray: @[dictOne, dictTwo] ];
    
    XCTAssertEqualObjects( @(objects.count), @2);
    
    MAXJAObjectSpecifiedProperties *firstObject = objects.firstObject;
    
    XCTAssertEqualObjects( firstObject.firstName, @"Bruce");
    XCTAssertEqualObjects( firstObject.lastName, nil);
    XCTAssertEqualObjects( firstObject.age, nil);
    XCTAssertEqualObjects( firstObject.stringAge, nil);
    
    MAXJAObjectSpecifiedProperties *secondObject = [objects objectAtIndex: 1];
    
    XCTAssertEqualObjects( secondObject.firstName, @"Peter");
    XCTAssertEqualObjects( secondObject.lastName, nil);
    XCTAssertEqualObjects( secondObject.age, nil);
    XCTAssertEqualObjects( secondObject.stringAge, nil);
    
}

#pragma mark - Object Creation Map

-(void)testObjectPropertyKeyMaps {
    
    NSDictionary *dictionary = @{ @"person" : @{ @"firstName" : @"Bruce", @"familyName" : @"Wayne", @"age" : @34, @"stringifiedAge" : @24 }
                                  };
    
    MAXJAObjectPropertyMap *propertyMapObject = [MAXJsonAdapter MAXJAObjectOfClass: [MAXJAObjectPropertyMap class] delegate: [[MAXJAObjectPropertyMap alloc] init]  fromDictionary: dictionary];
    
    XCTAssertNotNil( propertyMapObject );
    XCTAssertEqualObjects( propertyMapObject.firstName, @"Bruce");
    XCTAssertEqualObjects( propertyMapObject.lastName, @"Wayne");
    XCTAssertEqualObjects( propertyMapObject.age, @34);
    XCTAssertEqualObjects( propertyMapObject.stringAge, @"24");
    
}

-(void)testArrayObjectsPropertyKeyMaps {
    
    NSDictionary *dictOne = @{ @"person" : @{ @"firstName" : @"Bruce", @"familyName" : @"Wayne", @"age" : @34, @"stringifiedAge" : @21 }
                                  };
    
    NSDictionary *dictTwo = @{ @"person" : @{ @"firstName" : @"Peter", @"familyName" : @"Parker", @"age" : @18, @"stringifiedAge" : @22 }
                               };
    
    NSArray *objects = [MAXJsonAdapter MAXJAObjectsOfClass: [MAXJAObjectPropertyMap class] delegate: [[MAXJAObjectPropertyMap alloc] init] fromArray: @[dictOne, dictTwo] ];
    
    XCTAssertEqualObjects( @(objects.count), @2);
    
    MAXJAObjectPropertyMap *firstObject = objects.firstObject;
    
    XCTAssertEqualObjects( firstObject.firstName, @"Bruce");
    XCTAssertEqualObjects( firstObject.lastName, @"Wayne");
    XCTAssertEqualObjects( firstObject.age, @34);
    XCTAssertEqualObjects( firstObject.stringAge, @"21");
    
    MAXJAObjectPropertyMap *secondObject = [objects objectAtIndex: 1];
    
    XCTAssertEqualObjects( secondObject.firstName, @"Peter");
    XCTAssertEqualObjects( secondObject.lastName, @"Parker");
    XCTAssertEqualObjects( secondObject.age, @18);
    XCTAssertEqualObjects( secondObject.stringAge, @"22");
    
}

-(void)testObjectPropertyKeyIndexMaps {
    
    NSDictionary *dictionary = @{ @"person" :
                                      @{ @"name" : @[@"Bruce", @"Batman", @"Wayne" ],
                                         @"age" : @34,
                                         @"differentAges" : @[@10, @15, @20]
                                         }
                                  };
    
    MAXJAObjectPropertyIndexMap *indexMap = [MAXJsonAdapter MAXJAObjectOfClass: [MAXJAObjectPropertyIndexMap class] delegate: [MAXJAObjectPropertyIndexMap new] fromDictionary: dictionary];
    
    XCTAssertNotNil( indexMap );
    XCTAssertEqualObjects( indexMap.firstName, @"Bruce");
    XCTAssertEqualObjects( indexMap.middleName, @"Batman");
    XCTAssertEqualObjects( indexMap.lastName, @"Wayne");
    XCTAssertEqualObjects( indexMap.age, @34);
    XCTAssertEqualObjects( indexMap.stringAge, @"15");
    
}

-(void)testArrayObjectsPropertyKeyIndexMaps {
    
    NSDictionary *dictOne = @{ @"person" :
                                      @{ @"name" : @[@"Bruce", @"Batman", @"Wayne" ],
                                         @"age" : @34,
                                         @"differentAges" : @[@10, @20, @30]
                                         }
                                  };
    
    NSDictionary *dictTwo = @{ @"person" :
                                   @{ @"name" : @[@"Peter", @"Spider-man", @"Parker" ],
                                      @"age" : @18,
                                      @"differentAges" : @[@15, @35, @55]
                                      }
                               };
    
    NSArray *objects = [MAXJsonAdapter MAXJAObjectsOfClass: [MAXJAObjectPropertyIndexMap class] delegate: [MAXJAObjectPropertyIndexMap new] fromArray: @[dictOne, dictTwo] ];
    
    XCTAssertEqualObjects( @(objects.count), @2);
    
    MAXJAObjectPropertyIndexMap *firstObject = objects.firstObject;
    
    XCTAssertEqualObjects( firstObject.firstName, @"Bruce");
    XCTAssertEqualObjects( firstObject.middleName, @"Batman");
    XCTAssertEqualObjects( firstObject.lastName, @"Wayne");
    XCTAssertEqualObjects( firstObject.stringAge, @"20");
    
    MAXJAObjectPropertyIndexMap *secondObject = [objects objectAtIndex: 1];
    
    XCTAssertEqualObjects( secondObject.firstName, @"Peter");
    XCTAssertEqualObjects( secondObject.middleName, @"Spider-man");
    XCTAssertEqualObjects( secondObject.lastName, @"Parker");
    XCTAssertEqualObjects( secondObject.stringAge, @"35");
    
}

@end
