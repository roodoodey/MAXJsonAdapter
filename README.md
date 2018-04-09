# MAXJsonAdapter

[![CI Status](http://img.shields.io/travis/roodoodey/MAXJsonAdapter.svg?style=flat)](https://travis-ci.org/roodoodey/MAXJsonAdapter)
[![Version](https://img.shields.io/cocoapods/v/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)
[![License](https://img.shields.io/cocoapods/l/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)
[![Platform](https://img.shields.io/cocoapods/p/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)

## Model Objects - JSON Serialization/Deserialization

The burden of serializing model objects from, or into, JSON in Objective-C requires a lot of boilerplate code. MAXJsonAdapter takes care of serializing and deserializing model objects without needing a specific subclass other than the NSObject which is the default base level object class.

Let us consider the following interface and implementation for a user model :

```objective-c
@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic) BOOL isEmailVerified;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@property (nonatomic, strong) NSArray <NSString *> *usernames;
@property (nonatomic, strong) User *parentUser;

-(id)initWithJsonDict:(NSDictionary *)dict;

@end
```
```objective-c
@implementation User

-(id)initWithJsonDict:(NSDictionary *)dict {

    if(self = [super init]) {
    
     _email = [dict objectForKey:@"userEmail"];
     _firstName = [dict objectForKey:@"firstName"];
     _middleName = [dict objectForKey:@"middleName"];
     _lastName = [dict objectForKey:@"lastName"];
     _phoneNumber = [dict objectForKey:@"phoneNumber"];
     _isEmailVerified = [[dict objectForKey:@"emailVerified"] boolValue];
     
     _usernames = [dict objectForKey:@"usernames"];
     _parentUser = [[User alloc] initWithJsonDict: [dict objectForKey:@"parent"];
     
    }
    
    return self;
}

@end
```




### Example Json Serialization

### Mapping Values

### Value Transformers

### Subclassing

## Requirements

The MAXJsonAdapter requires that the model objects that are passed to it are subclasses of type NSObject or other object types that are key value coding compliant.

Unlike many other json adapters that serialize model objects require subclassing, this adapter on the other hand requires no specific subclassing so that other libraries which require subclassing can be easily used.

## Installation

MAXJsonAdapter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MAXJsonAdapter'
```

## Author

roodoodey, Mathieu Grettir Skúlason.

## License

MAXJsonAdapter is available under the MIT license. See the LICENSE file for more info.
