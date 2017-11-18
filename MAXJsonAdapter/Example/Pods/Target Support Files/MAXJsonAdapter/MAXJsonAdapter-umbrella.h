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
#import "MAXJsonAdapterObjectCreator.h"
#import "MAXJsonAdapter.h"
#import "MAXJsonAdapterPropertyMapInfo.h"
#import "MAXJsonAdapterPropertyMapper.h"
#import "MAXJsonAdapterProperty.h"
#import "MAXJsonAdapterPropertySearcher.h"
#import "MAXJASubclassedProperty.h"
#import "MAXJsonAdapterValueTransformer.h"
#import "MAXJsonAdapterNSArraryUtilities.h"
#import "MAXJsonAdapterRuntimeUtilities.h"

FOUNDATION_EXPORT double MAXJsonAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char MAXJsonAdapterVersionString[];

