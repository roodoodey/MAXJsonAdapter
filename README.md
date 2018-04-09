# MAXJsonAdapter

[![CI Status](http://img.shields.io/travis/roodoodey/MAXJsonAdapter.svg?style=flat)](https://travis-ci.org/roodoodey/MAXJsonAdapter)
[![Version](https://img.shields.io/cocoapods/v/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)
[![License](https://img.shields.io/cocoapods/l/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)
[![Platform](https://img.shields.io/cocoapods/p/MAXJsonAdapter.svg?style=flat)](http://cocoapods.org/pods/MAXJsonAdapter)

## Model Objects - JSON Serialization/Deserialization

The burden of serializing model objects from, or into, JSON in Objective-C requires a lot of boilerplate code. MAXJsonAdapter takes care of serializing and deserializing model objects without needing a specific subclass other than the NSObject which is the default base level object class.

Let us consider the following simple interface and implementation for a user model :

```objective-c
@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSArray <NSString *> *usernames;

-(id)initWithJsonDict:(NSDictionary *)dict;

@end
```
```objective-c
@implementation User

-(id)initWithJsonDict:(NSDictionary *)dict {

    if(self = [super init]) {
    
     _email = [dict objectForKey:@"email"];
     _firstName = [dict objectForKey:@"firstName"];
     _middleName = [dict objectForKey:@"middleName"];
     _lastName = [dict objectForKey:@"lastName"];
     _phoneNumber = [dict objectForKey:@"phoneNumber"];
     
     _usernames = [dict objectForKey:@"usernames"];
     
    }
    
    return self;
}

@end
```

The user model is initialized with a dictionary which was serialized from the following json data:

```json
{
    "email" : "batman@batman.com",
    "firstName" : "Bruce",
    "lastName" : "Wayne",
    "middleName": null,
    "phoneNumber" : "0018008608889",
    "usernames" : ["KillTheJoker", "RobinIsMyPet101", "TheRiddlerRiddlesTheRiddle"]
}
```

This is a simplified model where we do not have any dates or other values that need to be transformed at runtime. For such behavior checkout the chapter on value transformers.

Instead of having to initialize and manually declare which properties we should load from the dictionary in the initWithJsonDict: we can instead use the MAXJsonAdapter to do it for us, by using the following method:

```objective-c
User *user = [MAXJsonAdapter MAXJAObjectOfClass:[User class] delegate: nil fromDictionary: dict];
```

If you already have a model object and want to update it with a dictionary the json adapter can do that as well:

```objective-c
[MAXJsonAdapter refreshObject: object delegate: nil fromDictionary: dict]
```

These methods will read the name of all of the properties on the User model and match them with the values from the dictionary. All of the properties from the user will be appropriately populated. Making the initWithJsonDict: method redundant, which can be removed. We can also easily update models with the same set of information.

When the names of the properties in the model and the properties in the dictionary are not the same, or are located in different fields, we can use property mappers to load their data from different fields, or export them into json into different fields. More on property mapping in the chapter Mapping Values below. You can map these values by conforming to the MAXJsonAdapterDelegate protocol and passing a delegate argument to the MAXJsonAdapter.

Often times we receive data in different formats from APIs in our dictionaries, a good example of that are dates, which need to be changed from type NSString to NSDate, in order to do so you can use Value Transformers by conforming to the MAXJsonAdapterDelegate protocol and passing a delegate argument to the MAXJsonAdapter. More on value transformers in the chapter below.

### Mapping Values

Let us reuse the User class interface we implemented before. But this time the JSON we got sent from the server has changed its format and the property names do not match anymore. In this case we make the class conform to the MAXJsonAdapterDelegate protocol and implement the MAJAPropertiesToMapObjectCreation and MAXJApropertiesToMapDictionaryCreation so that we can map properties differently if we are creating a json dictionary from the object or creating on object from a json dictionary.

```objective-c
@interface User : NSObject <MAXJsonAdapterDelegate>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSArray <NSString *> *usernames;

@end
```

The new user json data format:

```json
{

}
```

### Ignoring or Specifying Values

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
