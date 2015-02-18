#ifndef _Context_AdMob_H
#define _Context_AdMob_H

#import "GADAdSize.h"
#import "GADRequest.h"

#import "FlashRuntimeExtensions.h"

#import "Context.h"

#import "Ad_AdMob.h"


   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game.
   
   extern const NSString *EventCode_AdLoaded;
   extern const NSString *EventCode_AdFailedToLoad;
   extern const NSString *EventCode_AdOpened;
   extern const NSString *EventCode_AdClosed;
   extern const NSString *EventCode_AdLeftApplication;

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..

   extern const int Position_CenterOrMiddle;
   extern const int Position_LeftOrTop;
   extern const int Position_RightOrBottom;
   
   // replaced by SetAppWindowPadding API
   //extern const int Position_Sibling_Left;
   //extern const int Position_Sibling_Top;
   //extern const int Position_Sibling_Right;
   //extern const int Position_Sibling_Bottom;

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..
   
   extern const int Gender_Unknown;
   extern const int Gender_Male;
   extern const int Gender_Female;

   // !!! warning: when these values are changed, the changes should be mirrorred to ANEs and editor/game..
   
   extern const int AdType_Invalid;
   extern const int AdType_Interstitial;
   extern const int AdType_SmartBanner;
   extern const int AdType_Banner;
   extern const int AdType_FullBanner;
   extern const int AdType_LargeBanner;
   extern const int AdType_Leadboard;
   extern const int AdType_MediumRectangle;
   extern const int AdType_WideSkyscraper;

//=======================================================

int Is_AdMob_Supported ();

void Context_AdMob_Initialize (void *extData, const FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet);

//=======================================================


DECLARE_ANE_FUNCTION (AdManager, SetAdGlobalOptions);
DECLARE_ANE_FUNCTION (AdManager, Pause);
DECLARE_ANE_FUNCTION (AdManager, Resume);
//DECLARE_ANE_FUNCTION (AdManager, Update);
DECLARE_ANE_FUNCTION (AdManager, DestroyAllAds);
DECLARE_ANE_FUNCTION (AdManager, HideAllAds);
DECLARE_ANE_FUNCTION (AdManager, SetAppWindowPadding);

DECLARE_ANE_FUNCTION (Ad, CreateAd);
DECLARE_ANE_FUNCTION (Ad, DestroyAd);
DECLARE_ANE_FUNCTION (Ad, CheckAdValidity);
DECLARE_ANE_FUNCTION (Ad, GetAdType);
DECLARE_ANE_FUNCTION (Ad, GetAdUnitID);
DECLARE_ANE_FUNCTION (Ad, PrepareAd);
DECLARE_ANE_FUNCTION (Ad, IsAdReady);
DECLARE_ANE_FUNCTION (Ad, SetAdPosition);
DECLARE_ANE_FUNCTION (Ad, GetAdBoundsInPixels);
DECLARE_ANE_FUNCTION (Ad, IsAdVisible);
DECLARE_ANE_FUNCTION (Ad, ShowAd);
DECLARE_ANE_FUNCTION (Ad, HideAd);



//=======================================================

@class AdMob_ViewController;

//typedef struct Location_ {
//   CGFloat x, y, z;
//} Location;

@interface Context_AdMob : Context {
   int nextAdId; // <= 0 means invalid
   NSMutableDictionary* allAds;
   /*
   AdMob_ViewController* bannderAdContainer;
   */
   
   UIView* stageView; // ios only
   UIViewController* stageViewController; // ios only
}

+ (void)fillZeros:(double[])bounds;
+ (void)getWindowBounds:(double[])bounds;
+ (void)getScreenSize:(double[])size;

+ (const GADAdSize *)getAdSizeByBannerType:(int)bannerType;

+ (int)validateGender:(int)g;
+ (int)getRequestGenderByGender:(int)gender;

@property(nonatomic, assign, readonly) NSMutableSet* testDeviceIDs;
@property(nonatomic, assign, readonly, getter=isTagForChildDirectedTreatment) BOOL tagForChildDirectedTreatment;
@property(nonatomic, assign, readonly) int gender;
@property(nonatomic, assign, readonly) NSDate* birthday;
//@property(nonatomic, assign, readonly) Location location;

- (void)pause;
- (void)resume;

- (void)resetOptions;
- (void)setOptions:(NSString*)deviceIDsString tagForCDT:(uint)tag gender:(int)g; //, int y, int m, int d)
- (GADRequest*)createNewAdRequest;

- (int)createAd:(int)type admobUnitID:(NSString*)unitID;
- (int)getNextAdId;
- (Ad_AdMob*) getAdById:(int)adId;
//- (Ad_AdMob*) getAd:(NSNumber*)adId;
- (void)destroyAdById:(int)adId;
- (void)destroyAd:(Ad_AdMob*)ad;
- (void)destroyAllAds;
- (void)hideAllAds;
- (UIView*)getStageView; // ios only
- (UIViewController*)getStageViewController; // ios only
- (void)setAppWindowPadding:(double)left top:(double)top right:(double)right bottom:(double)bottom;
//- (AdMob_ViewController*)getBannderAdContainer;
//- (void)updateBannderAdContainer;

@end

#endif
