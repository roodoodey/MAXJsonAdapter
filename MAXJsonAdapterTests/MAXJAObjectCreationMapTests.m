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


@end
