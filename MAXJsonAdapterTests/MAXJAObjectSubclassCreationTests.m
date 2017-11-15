//
//  MAXJAObjectSubclassCreationTests.m
//  MAXJsonAdapterTests
//
//  Created by Mathieu Skulason on 15/11/2017.
//  Copyright © 2017 Konta ehf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MAXJsonAdapter.h"
#import "MAXJASubclassedProperty.h"
#import "MAXJsonAdapterPropertyMapInfo.h"

@interface MAXSingleContainedObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *merchantName;

@property (nonatomic, strong) NSNumber *amount;

@end

@implementation MAXSingleContainedObject

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"merchantName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"merchant" nextPropertyMap: nil]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"amount" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"transactionAmount" nextPropertyMap: nil]]
             ];
}

@end

#pragma mark Normal Subclassed Objects

@interface MAXNormalRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) MAXSingleContainedObject *transaction;
           
@end

@implementation MAXNormalRootObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"transaction" class: [MAXSingleContainedObject class] delegate: nil]];
}

@end

@interface MAXNormalRootObjectWithDelegate : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) MAXSingleContainedObject *transaction;

@end

@implementation MAXNormalRootObjectWithDelegate

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"transaction" class: [MAXSingleContainedObject class] delegate: [MAXSingleContainedObject new]]];
}

@end

@interface MAXNormalArrayRootObject: NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray <MAXSingleContainedObject *> *transactions;

@end

@implementation MAXNormalArrayRootObject

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"transactions" class: [MAXSingleContainedObject class] delegate: nil]];
}

@end

@interface MAXNormalArrayRootObjectWithDelegate: NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray <MAXSingleContainedObject *> *transactions;

@end

@implementation MAXNormalArrayRootObjectWithDelegate

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"transactions" class: [MAXSingleContainedObject class] delegate: [MAXSingleContainedObject new]]];
}

@end

#pragma mark - Mapped Subclassed Objects

/*
 @discussion An object which contains a sub property which is mapped to a new key not index.
 */
@interface MAXKeyMappedRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *mappedName;

@property (nonatomic, strong) MAXSingleContainedObject *containedObject;

@end

@implementation MAXKeyMappedRootObject

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"containedObject" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"transaction" nextPropertyMap: nil]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"mappedName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]
             ];
}

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"containedObject" class: [MAXSingleContainedObject class] delegate: nil]];
}

@end

@interface MAXKeyMappedRootObjectWithDelegate : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *mappedName;

@property (nonatomic, strong) MAXSingleContainedObject *containedObject;

@end

@implementation MAXKeyMappedRootObjectWithDelegate

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"containedObject" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"transaction" nextPropertyMap: nil]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"mappedName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]
             ];
}

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"containedObject" class: [MAXSingleContainedObject class] delegate: [MAXSingleContainedObject new]]];
}

@end

@interface MAXKeyMappedArrayRootObject : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *mappedName;

@property (nonatomic, strong) NSArray <MAXSingleContainedObject *> *containedObjects;

@end

@implementation MAXKeyMappedArrayRootObject

-(NSArray <MAXJsonAdapterPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
    
    return @[
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"containedObjects" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"transactions" nextPropertyMap: nil]],
             [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"mappedName" nextPropertyMap: [MAXJsonAdapterPropertyMap MAXJACreateMapWithNewKey: @"name" nextPropertyMap: nil]]
             ];
}

-(NSArray <MAXJASubclassedProperty *> *)MAXJASubclassedProperties {
    
    return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"containedObjects" class: [MAXSingleContainedObject class] delegate: nil]];
}

@end

@interface MAXJAObjectSubclassCreationTests : XCTestCase

@end

@implementation MAXJAObjectSubclassCreationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Normal Object Subclass No Mapping Without Sub-Delegate

-(void)testNormalContainedObjectSubclassWithoutDelegate {
    
    NSDictionary *dict = @{ @"name": @"Marius", @"transaction" : @{ @"merchantName" : @"Hagkaup", @"amount" : @3000 } };
    
    MAXNormalRootObject *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXNormalRootObject class] delegate: [MAXNormalRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.name, @"Marius");
    XCTAssertEqualObjects( rootObj.transaction.merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.transaction.amount, @3000);
    
}

-(void)testNormalContainedArrayObjectSubclassWithoutDelegate {
    
    NSDictionary *dict =  @{ @"name": @"Marius", @"transactions" : @[ @{ @"merchantName" : @"Hagkaup", @"amount" : @3000 }, @{ @"merchantName" : @"Nói Síríus", @"amount" : @5000 } ] };
    
    MAXNormalArrayRootObject *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXNormalArrayRootObject class] delegate: [MAXNormalArrayRootObject new]  fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.name, @"Marius");
    XCTAssertEqualObjects( @(rootObj.transactions.count), @2);
    XCTAssertEqualObjects( rootObj.transactions[0].merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.transactions[0].amount, @3000);
    XCTAssertEqualObjects( rootObj.transactions[1].merchantName, @"Nói Síríus");
    XCTAssertEqualObjects( rootObj.transactions[1].amount, @5000);
    
}

#pragma mark - Normal Object Subclass No Mapping With Sub-Delegate Mapping

-(void)testNormalContainedObjectSubclassWithDelegateMapping {
    
    NSDictionary *dict = @{ @"name": @"Marius", @"transaction" : @{ @"merchant" : @"Hagkaup", @"transactionAmount" : @3000 } };
    
    MAXNormalRootObjectWithDelegate *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXNormalRootObjectWithDelegate class] delegate: [MAXNormalRootObjectWithDelegate new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.name, @"Marius");
    XCTAssertEqualObjects( rootObj.transaction.merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.transaction.amount, @3000);
    
}

-(void)testNormalContainedArrayObjectSubclassWithDelegateMapping {
    
    NSDictionary *dict =  @{ @"name": @"Marius", @"transactions" : @[ @{ @"merchant" : @"Hagkaup", @"transactionAmount" : @3000 }, @{ @"merchant" : @"Nói Síríus", @"transactionAmount" : @5000 } ] };
    
    MAXNormalArrayRootObjectWithDelegate *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXNormalArrayRootObjectWithDelegate class] delegate: [MAXNormalArrayRootObjectWithDelegate new]  fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.name, @"Marius");
    XCTAssertEqualObjects( @(rootObj.transactions.count), @2);
    XCTAssertEqualObjects( rootObj.transactions[0].merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.transactions[0].amount, @3000);
    XCTAssertEqualObjects( rootObj.transactions[1].merchantName, @"Nói Síríus");
    XCTAssertEqualObjects( rootObj.transactions[1].amount, @5000);
    
}

#pragma mark - Normal Object Subclass With Mapping Without Sub-Delegate

-(void)testNormalContainedObjectWithKeyMappingSubclassWithoutDelegate {
    
    NSDictionary *dict = @{ @"name": @"Marius", @"transaction" : @{ @"merchantName" : @"Hagkaup", @"amount" : @3000 } };
    
    MAXKeyMappedRootObject *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXKeyMappedRootObject class] delegate: [MAXKeyMappedRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.mappedName, @"Marius");
    XCTAssertEqualObjects( rootObj.containedObject.merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.containedObject.amount, @3000);
    
}

-(void)testNormalArrayContainedObjectWithKeyMappingSubclassWithoutDelegate {
    
    NSDictionary *dict =  @{ @"name": @"Marius", @"transactions" : @[ @{ @"merchantName" : @"Hagkaup", @"amount" : @3000 }, @{ @"merchantName" : @"Nói Síríus", @"amount" : @5000 } ] };
    
    MAXKeyMappedArrayRootObject *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXKeyMappedArrayRootObject class] delegate: [MAXKeyMappedArrayRootObject new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.mappedName, @"Marius");
    XCTAssertEqualObjects( rootObj.containedObjects[0].merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.containedObjects[0].amount, @3000);
    XCTAssertEqualObjects( rootObj.containedObjects[1].merchantName, @"Nói Síríus");
    XCTAssertEqualObjects( rootObj.containedObjects[1].amount, @5000);
    
}

#pragma mark - Normal Object Subclass With Mapping and Sub-Delegate Mapping

-(void)testNormalContainedObjectWithKeyMappingSubclassWithDelegate {
    
    NSDictionary *dict = @{ @"name": @"Marius", @"transaction" : @{ @"merchant" : @"Hagkaup", @"transactionAmount" : @3000 } };
    
    MAXKeyMappedRootObjectWithDelegate *rootObj = [MAXJsonAdapter MAXJACreateObjectOfClass: [MAXKeyMappedRootObjectWithDelegate class] delegate: [MAXKeyMappedRootObjectWithDelegate new] fromDictionary: dict];
    
    XCTAssertEqualObjects( rootObj.mappedName, @"Marius");
    XCTAssertEqualObjects( rootObj.containedObject.merchantName, @"Hagkaup");
    XCTAssertEqualObjects( rootObj.containedObject.amount, @3000);
    
}

#pragma mark - Nested Object Subclass Without Sub-Delegate

@end
