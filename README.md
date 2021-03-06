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

If you have a model object and want to create a dictionary from it to send back to a server, or for some other reason, you can use the following method:

```objective-c
NSDictionary *objectDict = [MAXJsonAdapter MAXJADictFromObject: object delegate: nil];
```

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
    "personInfo" : {
        "firstName" : "Bruce",
        "middleName" : null,
        "lastName" : "Wayne"
    },
    "phoneNumber" : "7728282737"
    "userEmail" : "batman@batman.com",
    "aliases" : ["KillTheJoker", "RobinIsMyPet101", "TheRiddlerRiddlesTheRiddle"]
}
```

Now the name properties are embedded in another field called person info and the email and usernames have been renamed userEmail and aliases. In order to make sure that we serialize the properties correctly we need too add new property mappers to the implementation of the User file.

```objective-c
@implementation User


-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapObjectCreation {
return @[[MAXJAPropertyMap MAXJAMapWithKey: @"firstName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"firstName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"middleName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"middleName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"lastName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"lastName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"email" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"userEmail" propertyMap: nil]],
[MAXJAPropertyMap MAXJAMapWithKey: @"usernames" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"aliases" propertyMap: nil]]
];
}

@end
```

In the array of MAXJAPropertyMap objects we first assign the name of the key we want to map the values of, such as firstName, and then declare the next key we want to drill linto in the json, which is personInfo, and then we declare the next key to get the value from which is firstName. When the MAXJsonAdapter has to drill down json fields to find the values for some keys it will check if the there is a property map declared. For the email property we simply declared a new mapping to userEmail as the name just changed and the only mapping is the name, no need to map it further down the json.

In order to make this work we just have to pass an instance of the object which contains the delegate to the MAXJsonAdapter in the following manner:

```objective-c
User *user = [MAXJsonAdapter MAXJAObjectOfClass: [User class] delegate: [[User alloc] init] fromDictionary: jsonDict];
```

You can make any NSObject conform to the MAXJsonAdapterDelegate to map values, transform them, and do many other runtime tasks. As a conveniece we placed it on the user class.

If you need to create an NSDictionary to send back to the server as json with mappings, the json adapter also supports mapping values when creating a NSDictionary from the object. Again, we use the MAXJsonAdapterDelegate protocol and we impelement the method MAXJAPropertiesToMapDictionaryCreation:.

```objective-c

@implementation User

-(NSArray <MAXJAPropertyMap *> *)MAXJAPropertiesToMapDictionaryCreation {
return @[[MAXJAPropertyMap MAXJAMapWithKey: @"firstName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"firstName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"middleName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"middleName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"lastName" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"personInfo" propertyMap: [MAXJAMapWithKey: @"lastName" propertyMap: nil]]],
[MAXJAPropertyMap MAXJAMapWithKey: @"email" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"userEmail" propertyMap: nil]],
[MAXJAPropertyMap MAXJAMapWithKey: @"usernames" propertyMap: [MAXJAPropertyMap MAXJAMapWithKey: @"aliases" propertyMap: nil]]
];
}
```

Using this mapping we will create an identic NSDictionary as we received from the server. We can create the NSDictionary from the user object by using the following method:

```objective-c
NSDictionary *userDict = [MAXJsonAdapter MAXJADictFromObject: user delegate: user];
```

This assumes the User object conforms to the MAXJsonAdapterDelegate protocol. Which will create a json in the following format:

The new user json data format:

```json
{
"personInfo" : {
"firstName" : "Bruce",
"middleName" : null,
"lastName" : "Wayne"
},
"phoneNumber" : "7728282737"
"userEmail" : "batman@batman.com",
"aliases" : ["KillTheJoker", "RobinIsMyPet101", "TheRiddlerRiddlesTheRiddle"]
}
```

### Ignoring or Specifying Values

What if you want to ignore a property when creating an object or dictionary from an object? You can use the MAXJAPropertiesToIgnoreObjectCreation: method or MAXJAPropertiesToIgnoreDictionaryCreation: method in the MAXJsonAdapterDelegate protocol to list the properties you want to ignore.

Here is an example implementation on the User model which would ignore the email property on the user model when creating its json:

```objective-c
@implementation User

-(NSArray <NSString *> *)MAXJAPropertiesToIgnoreDictionaryCreation {
return @[@"email"];
}

@end
```

By supplying an array of strings of the property names you want to ignore to the appropriate method in the json adapter delegate, you can ignore any property you want.


Sometimes you have a lot of properties on a model of which you only want several properties to create the dictionary. For example you want to update the use and your backend only supports updating the first, middle and last name of the user. In these cases it can be more useful to declare which properties you want to use when creating an object or dictionary from that object. You can do this by implementing the MAXJAPropertiesForDictionaryCreation: or MAXJAPropertiesForObjectCreation: methods in the MAXJsonAdapterDelegate protocol.

Here is an example implementation on the User model where we only want to create a dictionary with the names of the user and no other properties.

```objective-c
@implementation User

-(NSArray <NSString *> *)MAXJAPropertiesForDictionaryCreation {
return @[@"firstName", @"lastName", @"middleName"];
}

@end
```

If a user isntance is passed as a delegate to create the json dictionary, the json will look like the following:

```json
{
    "firstName" : "Bruce",
    "middleName" : null,
    "lastName" : "Wayne"
}
```

With this approach you can dramatically shorten the number of properties you need to declare in the list to ignore.

Do note that if you implement both properties to ignore and the properties you declare, the properties which are declared will take priority over the properties to ignore. The will not both be used, just one of them can be used.

### Value Transformers

Often when creating model objects you want to transform a property, for example a String to a date, which is a very common use case. In order to transform a value you first need to declare which transformer you want to use by using the MAXJAPropertyValueTransformers: protocol method. You also need to sublcass the MAXJAValueTransformer with its appropriate methods to transform the value.

Example implementation of MAXJAValueTransformer subclass which changes String to Date, and then Date back to String when creating a NSDictionary from the object.

```objective-c

static NSDateFormatter *_formatter = nil;

@implementation DateValueTransformer

+(NSDateFormatter *)formatter {

    if(_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    return _formatter;
}

-(id)MAXJAObjectCreationFormat:(id)value {

    if(value == nil) {
    return nil;
    }
    
    if([value isKindOfClass: [NSString class]]) {
        NSDate *date = [_formatter dateFromString: (NSString *)value];
        return date;
    }
    
    return nil;

}

-(id)MAXJsonFormat:(id)value {

    if(value == nil) {
    return nil;
    }
    
    if([value isKindOfClass: [NSDate class]]) {
        NSString *dateString = [_formatter stringFromDate: (NSDate*)value];
        return dateString;
    }
    
    return nil;
}

@end
```

There are two methods to implement, the value to transform when you are creating an object MAXJAObjectCreationFormat: and the value to transform when you are creating a dictionary which is the MAXJsonFormat: method.

Once these methods are implemented you need to add them to the MAXJsonAdapterDelegate in the method MAXJAPropertyValueTransformers, where you declare which properties the value transformers should be used on. In the model below we have two date properties which need to have value transformer associated to it.

```objective-c
@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSArray <NSString *> *usernames;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

@end
```

```objective-c
@implementation User

-(NSArray <MAXJAValueTransformer *> *)MAXJAPropertyValueTransformers {
return @[[DateValueTransformer MAXJAValueTransformerWithPropertyKeys: @[@"createdAt", @"updatedAt"]];
}

@end
```

In the implementation above the properties createdAt and updatedAt will use the class we implemented above to transform the value from string to date, and then from date back to string. If the properties have a mapping they just need to be declared in the mapping methods, and the json adapter will take care of the rest.

### Subclassing

Often you have your own classes as properties on a class. Serializing and deserializing subclassed properties is easy with the MAXJsonAdapter. Just impelement the MAXJASubclassedProperties: method in the MAXJsonAdapterDelegate conforming object. You can also add an instance as delegate for the subclassed property so that it may use the appropriate runtime transformations.

Adding a subclassed property is as easy as implementing the following:

```objecitve-c
@implementation User

-(NSArray <MAXJASublcassedProperty *> *)MAXJASubclassedProperties {
return @[[MAXJASubclassedProperty MAXJAPropertyKey: @"userInfo" class: [UserInfo class] delegate: nil];
}

@end
```

That is all there is to adding subclassed properties. Just like the value transformers subclassed properties support property mapping out of the box with the property mapping methods in the delegate.

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
