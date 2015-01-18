
#import <string.h>

#import "FlashRuntimeExtensions.h"

#import "Context.h"
#import "Context_AdMob.h"

static const char ContextType_AdMob [] = "admob";

void PhyardAneAll_ContextInitializer (void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {
   
   if (strcmp ((const char *)ctxType, ContextType_AdMob) == 0)
   {
      Context_AdMob_Initialize (extData, ctx, numFunctionsToSet, functionsToSet);
   }
   else
   {
      Context_Dummy_Initialize (extData, ctx, numFunctionsToSet, functionsToSet);
   }
}

void PhyardAneAll_ContextFinalizer (FREContext ctx) {
   Context* context;
   FREResult result = FREGetContextNativeData (ctx, (void*) &context);
   if (result == FRE_OK && context != NULL)
   {
      [context setFreContext:NULL];
      [context dispose];
      [context release];
   }
   
   FRESetContextNativeData (ctx, NULL);
   
   return;
}

//void PhyardAneAll_ExtensionInitializer (void **extDataToSet, FREContextInitializer *ctxInitializerToSet, FREContextFinalizer *ctxFinalizerToSet) {
// shit: _ is not allowed
void PhyardAneAllExtensionInitializer (void **extDataToSet, FREContextInitializer *ctxInitializerToSet, FREContextFinalizer *ctxFinalizerToSet) {
   //*extDataToSet = NULL; // nonsense
   *ctxInitializerToSet = &PhyardAneAll_ContextInitializer;
   *ctxFinalizerToSet = &PhyardAneAll_ContextFinalizer;
}

//void PhyardAneAll_ExtensionFinalizer (void* exData) {
// shit: _ is not allowed
void PhyardAneAllExtensionFinalizer (void* exData) {
   return;
}
