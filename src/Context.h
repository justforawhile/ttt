#ifndef _Context_H
#define _Context_H

#import <string.h>

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



// learnt from NativeGATracker
#define DECLARE_ANE_FUNCTION(prefix, fn) FREObject (prefix ## _ ## fn)(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
#define ANE_FUNCTION_ENTRY(prefix, fn, data) { (const uint8_t *)(#fn), (data), &(prefix ## _ ## fn) }



void Context_Dummy_Initialize (void *extData, const FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet);

//====================================================

void ThrowExceptionByFREResult (FREResult errorResult);

uint        FREObject_ExtractBoolean (FREObject object);
int         FREObject_ExtractInt32 (FREObject object);
double      FREObject_ExtractDouble (FREObject object);
int FREObject_ExtractString (FREObject object, char *returnChars, int maxLength); // length as input for max length, as output for extracted string length.

//FREObject FREObject_CreateError (const char* message, int id);
FREObject FREObject_CreateError (const char* message);
FREObject FREObject_CreateBoolean (uint value);
FREObject FREObject_CreateInt32 (int value);
FREObject FREObject_CreateDouble (double value);
FREObject FREObject_CreateString (const char* value);
FREObject FREObject_CreateArray (int count);
void FREObject_SetArrayElement (FREObject array, int index, FREObject element);

//====================================================

@interface Context : NSObject

@property(nonatomic, assign) FREContext freContext;

- (void)dispose;

- (void)dispatchStatusEventAsyncWithCode:(const NSString*)code AndLevel:(const NSString*)level;

@end

#endif
