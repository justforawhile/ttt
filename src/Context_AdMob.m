
#import <UIKit/UIKit.h>

#import "Context_AdMob.h"

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game.

   const NSString *EventCode_AdLoaded           = @"AdLoaded";
   const NSString *EventCode_AdFailedToLoad     = @"AdFailedToLoad";
   const NSString *EventCode_AdOpened           = @"AdOpened";
   const NSString *EventCode_AdClosed           = @"AdClosed";
   const NSString *EventCode_AdLeftApplication  = @"AdLeftApplication";

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..

   const int Position_CenterOrMiddle = 0x40000000;
   const int Position_LeftOrTop      = 0x40000001;
   const int Position_RightOrBottom  = 0x40000002;
   
   // replaced by SetAppWindowPadding API
   //const int Position_Sibling_Left    = 0x40000003;
   //const int Position_Sibling_Top     = 0x40000004;
   //const int Position_Sibling_Right   = 0x40000005;  
   //const int Position_Sibling_Bottom  = 0x40000006;   

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..

   const int Gender_Unknown = 0;
   const int Gender_Male    = 1;
   const int Gender_Female  = 2;

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..

   const int AdType_Invalid           = 0;
   const int AdType_Interstitial      = 1;
   const int AdType_SmartBanner       = 2;
   const int AdType_Banner            = 3;
   const int AdType_FullBanner        = 4;
   const int AdType_LargeBanner       = 5;
   const int AdType_Leadboard         = 6;
   const int AdType_MediumRectangle   = 7;
   const int AdType_WideSkyscraper    = 8;

//=======================================================

int Is_AdMob_Supported ()
{
   return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0");
}

void Context_AdMob_Initialize (void *extData, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet)
{
   // must be static here
   static FRENamedFunction functions [] = 
   {
      ANE_FUNCTION_ENTRY (AdManager, SetAdGlobalOptions, NULL),
      ANE_FUNCTION_ENTRY (AdManager, Pause, NULL),
      ANE_FUNCTION_ENTRY (AdManager, Resume, NULL),
      ANE_FUNCTION_ENTRY (AdManager, DestroyAllAds, NULL),
      ANE_FUNCTION_ENTRY (AdManager, HideAllAds, NULL),
      ANE_FUNCTION_ENTRY (AdManager, SetAppWindowPadding, NULL),
      
      ANE_FUNCTION_ENTRY (Ad, CreateAd, NULL),
      ANE_FUNCTION_ENTRY (Ad, DestroyAd, NULL),
      ANE_FUNCTION_ENTRY (Ad, CheckAdValidity, NULL),
      ANE_FUNCTION_ENTRY (Ad, GetAdType, NULL),
      ANE_FUNCTION_ENTRY (Ad, GetAdUnitID, NULL),
      ANE_FUNCTION_ENTRY (Ad, PrepareAd, NULL),
      ANE_FUNCTION_ENTRY (Ad, IsAdReady, NULL),
      ANE_FUNCTION_ENTRY (Ad, SetAdPosition, NULL),
      ANE_FUNCTION_ENTRY (Ad, GetAdBoundsInPixels, NULL),
      ANE_FUNCTION_ENTRY (Ad, IsAdVisible, NULL),
      ANE_FUNCTION_ENTRY (Ad, ShowAd, NULL),
      ANE_FUNCTION_ENTRY (Ad, HideAd, NULL),
   };
   
   *numFunctionsToSet = sizeof (functions) / sizeof (FRENamedFunction);
   *functionsToSet = functions;
   
   Context_AdMob* context = [[Context_AdMob alloc] init]; // <=> [Context_AdMob new]
   [context setFreContext:ctx];
   FRESetContextNativeData (ctx, (__bridge void *)(context));
}

Context_AdMob* GetAdMobContextFromFREContext (FREContext ctx)
{
   Context_AdMob* admobContext;
   FREResult result = FREGetContextNativeData (ctx, (void*) &admobContext);
   if (result != FRE_OK)
   {
      ThrowExceptionByFREResult (result);
      //return NULL;
   }
   
   return admobContext;
}

//=======================================================

DECLARE_ANE_FUNCTION (AdManager, SetAdGlobalOptions)
{
   FREObject result = NULL;

   @try {
      //if (argc < 3)
      //{
      //   return FREObject_CreateError ((char *) "TOO_FEW_ARGUMENTS");
      //}
      
      int str_len;
      const char* testDeviceIDs = FREObject_ExtractString (argv [0], &str_len);
      NSString* deviceIDs = [NSString stringWithUTF8String:testDeviceIDs];
      
      uint tagForCDT = FREObject_ExtractBoolean (argv [1]);
      
      int gender = FREObject_ExtractInt32 (argv[2]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext setOptions:deviceIDs tagForCDT:tagForCDT gender:gender];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (AdManager, Pause)
{
   FREObject result = NULL;

   @try {
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext pause];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (AdManager, Resume)
{
   FREObject result = NULL;

   @try {
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext resume];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (AdManager, DestroyAllAds)
{
   FREObject result = NULL;

   @try {
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext destroyAllAds];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (AdManager, HideAllAds)
{
   FREObject result = NULL;

   @try {
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext hideAllAds];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (AdManager, SetAppWindowPadding)
{
   FREObject result = NULL;

   @try {
      double left   = FREObject_ExtractDouble (argv[0]);
      double top    = FREObject_ExtractDouble (argv[1]);
      double right  = FREObject_ExtractDouble (argv[2]);
      double bottom = FREObject_ExtractDouble (argv[3]);
      
      //>>ios only
      left   /= [[UIScreen mainScreen] scale];
      top    /= [[UIScreen mainScreen] scale];
      right  /= [[UIScreen mainScreen] scale];
      bottom /= [[UIScreen mainScreen] scale];
      //<<
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      [admobContext setAppWindowPadding:left top:top right:right bottom:bottom];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, CreateAd)
{
   FREObject result = NULL;

   @try {
      int type = FREObject_ExtractInt32 (argv[0]);
      
      int str_len;
      const char* admobUnitId = FREObject_ExtractString (argv [1], &str_len);
      NSString* unitID = [NSString stringWithUTF8String:admobUnitId];
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      int adId = [admobContext createAd:type admobUnitID:unitID];
      result = FREObject_CreateInt32 (adId);
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, DestroyAd)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      [admobContext destroyAdById:adId];
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

// UIWindow
//   CTStandaloneView
//      CTStageView
//   UIView (banners container) override oritation functions, clone from CTStandaloneView http://stackoverflow.com/questions/19905088/ios-7-change-page-orientation-only-for-one-view-controller
//      GADBannerView
//   UIView (full ad container)
/*
const char* GetDebuggString (UIView* view, int depth, int index, NSMutableString* info)
{
   if (view == nil)
   {
      info = [NSMutableString string];
      
      UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
      if (UIInterfaceOrientationIsPortrait(currentOrientation))
      {
   
         [info appendString:@"Portrait"];
      }
      else
      {
   
         [info appendString:@"Landscape"];
      }
      
      return GetDebuggString ([[[UIApplication sharedApplication] delegate] window], 0, 0, info);
   }
   
   [info appendString:@"\n"];
   int d = depth;
   while (-- d > 0) {
      [info appendString:@"--"];
   }
   [info appendFormat:@"%d> %@", index, NSStringFromClass([view class])];
   
   NSArray* subs = view.subviews;
   int n = [subs count];
   for (int i = 0; i < n; ++ i)
   {
      UIView* s = [subs objectAtIndex:i];
      GetDebuggString (s, depth + 1, i, info);
   }
   
   return [info UTF8String];
}
*/
/*
const char* GetDebuggString (Context_AdMob* admobContext)
{
   NSMutableString* info = [NSMutableString string];
   [info appendFormat:@"\nstage=%@", NSStringFromClass([[admobContext getStageView] class])];
   [info appendFormat:@"\ncontroller=%@", NSStringFromClass([[admobContext getStageViewController] class])];
   [info appendString:@"\n"];
   
   return [info UTF8String];
}
*/

DECLARE_ANE_FUNCTION (Ad, CheckAdValidity)
{
   FREObject result = NULL;

   @try {
      //result = FREObject_CreateString (GetDebuggString (nil, 0, 0, nil));
      //return result;
      //result = FREObject_CreateString (GetDebuggString (GetAdMobContextFromFREContext (ctx)));
      //return result;

      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad == nil)
      {
         if (adId > 0 && adId < [admobContext getNextAdId])
            result = FREObject_CreateString ("destroyed");
         else
            result = FREObject_CreateString ("ad not found");
      }
      else if ([ad checkValidity]  == nil)
      {
         result = FREObject_CreateString (NULL); 
      }
      else
      {
         result = FREObject_CreateString ([[ad checkValidity] UTF8String]);
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, GetAdType)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad == nil)
         result = FREObject_CreateInt32 (AdType_Invalid);
      else
         result = FREObject_CreateInt32 (ad.type);
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, GetAdUnitID)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad == nil || [ad unitID] == nil)
         result = FREObject_CreateString ("");
      else
      {
         result = FREObject_CreateString ([[ad unitID] UTF8String]);
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, PrepareAd)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad != nil)
      {
         [ad prepare];
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, IsAdReady)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad == nil)
         result = FREObject_CreateBoolean (0);
      else
         result = FREObject_CreateBoolean (ad.isReady);
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, SetAdPosition)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      double x = FREObject_ExtractDouble (argv[1]);
      double y = FREObject_ExtractDouble (argv[2]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad != nil)
      {
         [ad setPosition:x posY:y];
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, GetAdBoundsInPixels)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      
      double bounds[4];
      if (ad == nil)
         [Context_AdMob fillZeros:bounds];
      else
         [ad getBounds:bounds];
      
      //>>ios only
      bounds[0] *= [[UIScreen mainScreen] scale];
      bounds[1] *= [[UIScreen mainScreen] scale];
      bounds[2] *= [[UIScreen mainScreen] scale];
      bounds[3] *= [[UIScreen mainScreen] scale];
      //<<
      
      FREObject array = FREObject_CreateArray (4);
      FREObject_SetArrayElement (array, 0, FREObject_CreateDouble (bounds [0]));
      FREObject_SetArrayElement (array, 1, FREObject_CreateDouble (bounds [1]));
      FREObject_SetArrayElement (array, 2, FREObject_CreateDouble (bounds [2]));
      FREObject_SetArrayElement (array, 3, FREObject_CreateDouble (bounds [3]));
      
      result = array;
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, IsAdVisible)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad == nil)
         result = FREObject_CreateBoolean (0);
      else
         result = FREObject_CreateBoolean (ad.isVisible);
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, ShowAd)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad != nil)
      {
         [ad show];
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

DECLARE_ANE_FUNCTION (Ad, HideAd)
{
   FREObject result = NULL;

   @try {
      int adId = FREObject_ExtractInt32 (argv[0]);
      
      Context_AdMob* admobContext = GetAdMobContextFromFREContext (ctx);
      
      Ad_AdMob* ad = [admobContext getAdById:adId];
      if (ad != nil)
      {
         [ad hide];
      }
   }
   @catch (NSException *exception) {
      result = FREObject_CreateError ((char *) [[exception name] UTF8String]);
   }

   return result;
}

//=======================================================

@implementation Context_AdMob {
   
}


   
+ (void)fillZeros:(double[])bounds
{
   bounds [0] = 0;
   bounds [1] = 0;
   bounds [2] = 0;
   bounds [3] = 0;
}
   
+ (void)getWindowBounds:(double[])bounds
{
   CGRect screenBounds = [[UIScreen mainScreen] bounds]; // portrait bounds
   UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
   if (UIInterfaceOrientationIsPortrait(currentOrientation))
   {
      bounds [0] = 0;
      bounds [1] = [UIApplication sharedApplication].statusBarFrame.size.height;
      bounds [2] = screenBounds.size.width;
      bounds [3] = screenBounds.size.height - bounds [1];
   }
   else
   {
      bounds [0] = 0;
      bounds [1] = [UIApplication sharedApplication].statusBarFrame.size.width;
      bounds [2] = screenBounds.size.height;
      bounds [3] = screenBounds.size.width -  bounds [1];
   }
}
   
+ (void)getScreenSize:(double[])size
{
   // maybe this simaple implementation is better. (need test)
   //CGRect viewBounds = [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] bounds];
   //size [0] = viewBounds.size.width;
   //size [1] = viewBounds.size.height;
   
   CGRect screenBounds = [[UIScreen mainScreen] bounds]; // portrait bounds
   UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
   if (UIInterfaceOrientationIsPortrait(currentOrientation))
   {
      size [0] = screenBounds.size.width;
      size [1] = screenBounds.size.height;
   }
   else
   {
      size [0] = screenBounds.size.height;
      size [1] = screenBounds.size.width;
   }
}

+ (const GADAdSize *)getAdSizeByBannerType:(int)bannerType
{
   switch (bannerType) {
      case AdType_SmartBanner:
      {
         //UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
         UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
            return &kGADAdSizeSmartBannerPortrait;
         } else {
            return &kGADAdSizeSmartBannerLandscape;
         }
      }
      case AdType_Banner:
         return &kGADAdSizeBanner;
      case AdType_FullBanner:
         return &kGADAdSizeFullBanner;
      case AdType_LargeBanner:
         return &kGADAdSizeLargeBanner;
      case AdType_Leadboard:
         return &kGADAdSizeLeaderboard;
      case AdType_MediumRectangle:
         return &kGADAdSizeMediumRectangle;
      case AdType_WideSkyscraper:
         return &kGADAdSizeSkyscraper;
      default: {
         return NULL; // kGADAdSizeInvalid;
      }
   }
}

+ (int)validateGender:(int)g
{
   switch (g)
   {
      case Gender_Female:
      case Gender_Male:
         return g;
      //case Gender_Unknown:
      default:
         return Gender_Unknown;
   }
}

+ (int)getRequestGenderByGender:(int)gender
{
   switch (gender) {
      case Gender_Female:
         return kGADGenderFemale;
      case Gender_Male:
         return kGADGenderMale;
      //case Gender_Unknown:
      default:
         return kGADGenderUnknown;
   }
}

- (id)init 
{
   self = [super init];
   if (self != nil) {
      nextAdId = 1;
      allAds = [[NSMutableDictionary alloc] initWithCapacity:8];
      bannderAdContainer = nil;
      
      stageView = nil;
      stageViewController = nil;
      
      [self resetOptions];
   }
   
   return self;
}

- (void)dispose
{
   [self resetOptions];
   
   // ...
   
   [self destroyAllAds];
   
   // ...
   
   if (_testDeviceIDs != nil)
   {
      [_testDeviceIDs removeAllObjects];
      //  xcode: ARC forbids explicit message send of 'dealloc'
      //[_testDeviceIDs release];
      _testDeviceIDs = nil;
   }
   
   // ...
   
   if (allAds != nil)
   {
      [allAds removeAllObjects];
      //  xcode: ARC forbids explicit message send of 'dealloc'
      //[allAds release];
      allAds = nil;
   }
   
   // ...
   
   if (bannderAdContainer != nil)
   {
      if ([bannderAdContainer.view superview] != nil)
      {
         [bannderAdContainer.view removeFromSuperview];
      }
       
      //  xcode: ARC forbids explicit message send of 'dealloc'
      //[bannderAdContainer release];
      bannderAdContainer = nil;
   }
   
   // ...
   
   [super dispose];
}

- (void)pause
{
   // for android only
}

- (void)resume
{
   // for android only
}

- (void)resetOptions
{
   if (_testDeviceIDs == nil)
   {
      _testDeviceIDs = [[NSMutableSet alloc] initWithCapacity:8];
   }
   else
   {
      [_testDeviceIDs removeAllObjects];
   }
   _tagForChildDirectedTreatment = NO;
   _gender = Gender_Unknown;
   _birthday = nil;
}

- (void)setOptions:(NSString*)deviceIDsString tagForCDT:(uint)tag gender:(int)g
{
   [_testDeviceIDs removeAllObjects];
   
   if (deviceIDsString != nil) {
      NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@";, "];
      NSArray *deviceIDs = [deviceIDsString componentsSeparatedByCharactersInSet:charset];
      
      for (id deviceID in deviceIDs)
      {
         NSString* device = (NSString*)deviceID;
         device = [device stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         if ([device length] > 0)
         {
            [_testDeviceIDs addObject:device];
         }
      }

   }
   
   _tagForChildDirectedTreatment = tag;
   
   _gender = [Context_AdMob validateGender:g];
   if (_gender != g) {
      //log ("Invalid gender value: " + g);
   }
   
   //y = Math.max (y, 0);
   //m = Math.min (12, Math.max (m, 1));
   //d = Math.min (31, Math.max (d, 1));
   //if (y == 0 || m == 0 && d == 0) {
   //   birthday = null;
   //} else {
   //   Calendar calender = Calendar.getInstance ();
   //   calender.set (y, m - 1, d - 1);
   //   birthday = calender.getTime ();
   //}
}

- (GADRequest*)createNewAdRequest
{
   GADRequest *request = [GADRequest request];
   
   if(_testDeviceIDs != nil && [_testDeviceIDs count] > 0)
   {
      request.testDevices = [_testDeviceIDs allObjects];
   }
   
   request.gender = [Context_AdMob getRequestGenderByGender:_gender];
   
   [request tagForChildDirectedTreatment:_tagForChildDirectedTreatment];
   
   if (_birthday != nil)
   {
      // todo
      // [request setBirthdayWithMonth: day: year:];
   }
   
   return request;
}

- (int)createAd:(int)type admobUnitID:(NSString*)unitID
{
   NSNumber* key = [NSNumber numberWithInt:nextAdId];
   ++ nextAdId;
   
   Ad_AdMob* ad;
   if (type == AdType_Interstitial) {
      ad = [[Ad_AdMobInterstitial alloc] initWithKeyAndContext:key admobContext:self type:type unitID:unitID];
   } else {
      ad = [[Ad_AdMobBanner alloc] initWithKeyAndContext:key admobContext:self type:type unitID:unitID];
   }
   //  xcode: ARC forbids explicit message send of 'dealloc'
   //[ad autorelease];
   
   [allAds setObject:ad forKey:key];
   
   return [key intValue];
}

- (int)getNextAdId
{
   return nextAdId;
}

- (Ad_AdMob*) getAdById:(int)adId
{
   return [self getAd:[NSNumber numberWithInt:adId]];
}

- (Ad_AdMob*) getAd:(NSNumber*)adkey
{
   return [allAds objectForKey:adkey];
}

- (void)destroyAdById:(int)adId
{
   Ad_AdMob* ad = [self getAdById:adId];
   return [self destroyAd:ad];
}

- (void)destroyAd:(Ad_AdMob*)ad
{
   if (ad != nil)
   {
      [ad destroy];
      
      [allAds removeObjectForKey:[ad key]];
   }
}

- (void)destroyAllAds
{
   NSArray *adkeys = [allAds allKeys];
   
	for (NSNumber* adkey in adkeys)
   {
      Ad_AdMob* ad = [allAds objectForKey:adkey];
		[self destroyAd:ad];
	}
   
   [allAds removeAllObjects];
}

- (void)hideAllAds
{
   NSArray *adkeys = [allAds allKeys];
   
	for (NSNumber* adkey in adkeys)
   {
      Ad_AdMob* ad = [allAds objectForKey:adkey];
		[ad hide];
	}
}

// UIWindow
//   CTStandaloneView [CTStageViewController.view]
//      CTStageView
//   UIView (banners container) override oritation functions, clone from CTStandaloneView http://stackoverflow.com/questions/19905088/ios-7-change-page-orientation-only-for-one-view-controller
//      GADBannerView
//   UIView (full ad container)
//
// see GetDebuggString

UIView* findStageView (UIView* view)
{
   if (view == nil)
   {
      view = [[[UIApplication sharedApplication] delegate] window];
   }
   
   NSArray* subs = view.subviews;
   int n = [subs count];
   for (int i = 0; i < n; ++ i)
   {
      UIView* subview = [subs objectAtIndex:i];
   
      if ([NSStringFromClass([subview class]) isEqualToString:@"CTStageView"])
         return subview;
      
      UIView* stageview = findStageView (subview);
      if (stageview != nil)
         return stageview;
   }
   
   return nil;
}

- (UIView*)getStageView // ios only
{
   if (stageView == nil)
   {
      stageView = findStageView (nil);
   }
   
   return stageView;
}

- (UIViewController*)getStageViewController // ios only
{
   if (stageViewController == nil)
   {
      UIView* view = [self getStageView];
      while (view != nil)
      {
         UIResponder* responder = [view nextResponder];
         if ([responder isKindOfClass:[UIViewController class]])
         {
            stageViewController = (UIViewController*)responder;
            break;
         }
          
         view = [view superview];
      }
   }
   
   return stageViewController;
}

- (void)setAppWindowPadding:(double)left top:(double)top right:(double)right bottom:(double)bottom
{
   UIView* stage = [self getStageView];
   if (stage == nil)
      return;
   
   UIView* controllerView = [stage superview];
   if (controllerView == nil)
      return;
   
   CGRect superbounds = controllerView.bounds;
   
   stage.frame = CGRectMake (left, top, superbounds.size.width - left - right, superbounds.size.height - top - bottom);
}

- (AdMob_ViewController*)getBannderAdContainer
{
   if (bannderAdContainer == nil)
   {
      bannderAdContainer = [[AdMob_ViewController alloc] initWithContext:self];
   }
   
   if ([bannderAdContainer.view superview] == nil)
   {  
      [[[[UIApplication sharedApplication] delegate] window] addSubview:bannderAdContainer.view];
      bannderAdContainer.view.userInteractionEnabled = NO;
      bannderAdContainer.view.hidden = YES;
   }
   
   return bannderAdContainer;
}

- (void)updateBannderAdContainer
{
   if (bannderAdContainer != nil)
   {
      BOOL hidden = YES;
      
      NSArray *adkeys = [allAds allKeys];
      
      for (NSNumber* adkey in adkeys)
      {
         Ad_AdMob* ad = [allAds objectForKey:adkey];
         GADBannerView* adview = [ad getAdView];
         if (adview != nil && [adview superview] == bannderAdContainer.view && adview.hidden == NO)
         {
            hidden = NO;
         }
      }
      
      if (hidden != bannderAdContainer.view.hidden)
      {
         bannderAdContainer.view.hidden = hidden;
      }
   }
}
 
@end
