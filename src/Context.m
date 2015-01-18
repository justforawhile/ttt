
#import "Context.h"



void Context_Dummy_Initialize (void *extData, const FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet)
{
   // must be static here
   static FRENamedFunction functions [] = {};
   
   numFunctionsToSet = 0;
   *functionsToSet = functions; // NULL; // may be NULL is also ok.

   Context* context = [[Context alloc] init];
   [context setFreContext:ctx];
   FRESetContextNativeData (ctx, (__bridge void *)(context));
}

//====================================================

void ThrowExceptionByFREResult (FREResult errorResult)
{
   NSString* exceptionName;
   switch (errorResult)
   {
      case FRE_OK:
         return; // do nothing
      case FRE_NO_SUCH_NAME:
         exceptionName = @"FRE_NO_SUCH_NAME";
         break;
      case FRE_INVALID_OBJECT:
         exceptionName = @"FRE_INVALID_OBJECT";
         break;
      case FRE_TYPE_MISMATCH:
         exceptionName = @"FRE_TYPE_MISMATCH";
         break;
      case FRE_ACTIONSCRIPT_ERROR:
         exceptionName = @"FRE_ACTIONSCRIPT_ERROR";
         break;
      case FRE_INVALID_ARGUMENT:
         exceptionName = @"FRE_INVALID_ARGUMENT";
         break;
      case FRE_READ_ONLY:
         exceptionName = @"FRE_READ_ONLY";
         break;
      case FRE_WRONG_THREAD:
         exceptionName = @"FRE_WRONG_THREAD";
         break;
      case FRE_ILLEGAL_STATE:
         exceptionName = @"FRE_ILLEGAL_STATE";
         break;
      case FRE_INSUFFICIENT_MEMORY:
         exceptionName = @"FRE_INSUFFICIENT_MEMORY";
         break;
      default:
      {
         exceptionName = @"UNKNOWN_ERROR";
         break;
      }
   }
   
   NSException *exception = [NSException exceptionWithName:exceptionName reason:@"" userInfo:NULL];
   @throw exception;
}

FREObject ThrowExceptionOrReturnValidFREObject (FREResult result, FREObject okObject)
{
   if (result != FRE_OK)
   {
      ThrowExceptionByFREResult (result);
   }
   
   return okObject;
}

uint FREObject_ExtractBoolean (FREObject object)
{
   uint32_t value = 0;
   FREResult result = FREGetObjectAsBool (object, &value);
   ThrowExceptionByFREResult (result);
   return (uint) value;
}

int FREObject_ExtractInt32 (FREObject object)
{
   int32_t value = 0;
   FREResult result = FREGetObjectAsInt32 (object, &value);
   ThrowExceptionByFREResult (result);
   return (int) value;
}

double FREObject_ExtractDouble (FREObject object)
{
   double value = 0;
   FREResult result = FREGetObjectAsDouble (object, &value);
   ThrowExceptionByFREResult (result);
   return value;
}

// length as input for max length, as output for extracted string length.
// the returned char* should be copied to other variable immediately (before calling other FRE apis).
const char* FREObject_ExtractString (FREObject object, int* length)
{
   uint32_t str_len;
   const uint8_t *str;

   FREResult result = FREGetObjectAsUTF8(object, &str_len, &str);
   
   if (str_len > *length)
   {
      NSException *exception = [NSException exceptionWithName:@"INOUT_STRING_TOO_LONG" reason:@"" userInfo:NULL];
      @throw exception;
   }
   
   *length = str_len;
   return (const char*)str;
}

//FREObject FREObject_CreateError (const char* message, int id)
// make sure message contians only ascii chars so that it is a UTF8 string.
FREObject FREObject_CreateError (const char* message)
{
   FREObject errorMessage;
   if (message == NULL)
      FRENewObjectFromUTF8(1, (const uint8_t*)"", &errorMessage);
   else
   {
      FRENewObjectFromUTF8(strlen (message) + 1, (const uint8_t*)message, &errorMessage);
         // strelen + 1 for including the null char at the end.
         // we don't care about the result here, if it is not ok, the following FRENewObject will return an valid exception.
   }
   
   uint32_t argc = 1;
   FREObject argv[argc];
   argv[0] = errorMessage;

   // either one of the following two is valid. (right? maybe.)
   FREObject errorObject; 
   FREObject exceptionObject; // also an Error in as3.
   
   FREResult result = FRENewObject((uint8_t *) "Error", argc, argv, &errorObject, &exceptionObject);
      // the ANE api is werid, someplaces need stelen, someplaces needn't. (but a little better than ANE java api.)

   if (result == FRE_OK) {
      return errorObject;
   } else {
      return exceptionObject;
   }
}

FREObject FREObject_CreateBoolean (uint value)
{
   FREObject booleanObject;
   FREResult result = FRENewObjectFromBool (value, &booleanObject);
   return ThrowExceptionOrReturnValidFREObject (result, booleanObject);
}

FREObject FREObject_CreateInt32 (int value)
{
   FREObject intObject;
   FREResult result = FRENewObjectFromInt32 (value, &intObject);
   return ThrowExceptionOrReturnValidFREObject (result, intObject);
}

FREObject FREObject_CreateDouble (double value)
{
   FREObject numberObject;
   FREResult result = FRENewObjectFromDouble (value, &numberObject);
   return ThrowExceptionOrReturnValidFREObject (result, numberObject);
}

FREObject FREObject_CreateString (const char* value)
{
   if (value == NULL)
   {
      // shit, no ways to create null FREObject with ANE c++ API.
      //value = "";
      
      return NULL;
   }
   
   FREObject stringObject;
   FREResult result = FRENewObjectFromUTF8 (strlen (value) + 1, (const uint8_t*)value, &stringObject);
   return ThrowExceptionOrReturnValidFREObject (result, stringObject);
}

FREObject FREObject_CreateArray (int count)
{
   FREObject array;
   FREResult result = FRENewObject((const uint8_t*)"Array", 0, NULL, &array, NULL);
   array = ThrowExceptionOrReturnValidFREObject (result, array);
   result = FRESetArrayLength(array, (uint32_t) count);

   return ThrowExceptionOrReturnValidFREObject (result, array);
}

void FREObject_SetArrayElement (FREObject array, int index, FREObject element)
{
   FREResult result = FRESetArrayElementAt(array, (uint32_t) index, element);
   ThrowExceptionByFREResult (result);
}


//====================================================

@implementation Context

- (void)dealloc {
   [self dispose];
   
   // xcode: ARC forbids explicit message send of 'dealloc'
   //[super dealloc];
}

- (void)dispose
{
}

- (void)dispatchStatusEventAsyncWithCode:(const NSString*)code AndLevel:(const NSString*)level
{
   FREDispatchStatusEventAsync(_freContext, (uint8_t*)[code UTF8String], (uint8_t*)[level UTF8String]);
}

 
@end