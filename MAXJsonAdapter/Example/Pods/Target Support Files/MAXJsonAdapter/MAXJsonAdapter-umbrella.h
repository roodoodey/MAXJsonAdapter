#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MAXJADictionaryCreator.h"
#import "MAXJAObjectCreator.h"
#import "MAXJsonAdapter.h"
#import "MAXJAPropertyMap.h"
#import "MAXJAPropertyMapper.h"
#import "MAXJAProperty.h"
#import "MAXJAPropertySearcher.h"
#import "MAXJASubclassedProperty.h"
#import "MAXJAValueTransformer.h"
#import "MAXJANSArraryUtilities.h"
#import "MAXJARuntimeUtilities.h"

FOUNDATION_EXPORT double MAXJsonAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char MAXJsonAdapterVersionString[];

