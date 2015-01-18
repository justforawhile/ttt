
#import "Context_AdMob.h"
#import "Ad_AdMob.h"


@implementation Ad_AdMob

- (id)initWithKeyAndContext:(NSNumber*)adkey admobContext:(Context_AdMob*)adcontext type:(int)t unitID:(NSString *)unitid
{
   self = [super initWithProperties:@"admob" type:t unitID:unitid];
   
   if (self) {
      _key = adkey;
      _context = adcontext;
      _adListener = nil;
   }
   
   return self;
}

//- (void)dealloc {
//   dispose ();
//   
//   [super dealloc];
//}

- (void)dispose
{
   [super dispose];
}

- (int)getId
{
   return [_key intValue];
}

- (GADBannerView*)getAdView
{
   return nil;
}

- (void)onAdOpened
{
   // to override
}

- (void)onAdClosed
{
   // to override
}

- (void)onAdLoaded
{
   [self onPrepareReady];
      
   // to override
}

- (void)onAdFailedToLoad
{
   [self onPrepareFailed];
   
   // to override
}
 
@end



@implementation Ad_AdMobBanner

- (void)initialize
{
   if (! Is_AdMob_Supported ())
   {
      [self setInvalidReason:@"ios version is too old"];
      return;
   }
   
   adSize = [Context_AdMob getAdSizeByBannerType:self.type];
   if(adSize == NULL) {
      [self setInvalidReason:[NSString stringWithFormat:@"invalid type: %d/12", self.type]];
   }
   
   if (self.type == AdType_WideSkyscraper) {
      [self setPosition:Position_LeftOrTop posY:Position_RightOrBottom];
   } else {
      [self setPosition:Position_RightOrBottom posY:Position_LeftOrTop];
   }
   
   if (self.unitID == nil) {
      self.unitID = @"";
   } else {
      self.unitID = [self.unitID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   }
   
   if ([self.unitID length] == 0) {
      [self setInvalidReason:@"invalid unit id"];
   }
}

//=========================== as Ad_AdMob
 
- (id)initWithKeyAndContext:(NSNumber*)adkey admobContext:(Context_AdMob*)adcontext type:(int)t unitID:(NSString *)unitid
{
   self = [super initWithKeyAndContext:adkey admobContext:adcontext type:t unitID:unitid];
   
   if (self) {
      adView = nil;
      adSize = NULL; // AdSize is a c struct
      showOnReady = NO;
      
      [self initialize];
   }
   
   return self;
}

- (GADBannerView*)getAdView
{
   return adView;
}

- (void)onAdLoaded
{
   [super onAdLoaded];
   
   //>> java version has no this
   [self updatePosition]; // size may changed for adView.mediatedAdView
   //<<
         
   if (showOnReady)
   {
      [self show];
   }
}

//=========================== as Ad
 
- (void)dispose
{
   [self hide];
   
   //>> java version has no this part
   if (adView != nil)
   {
      if ([adView superview] != nil)
      {
         [adView removeFromSuperview];
      }
      
      adView.delegate = nil;
      adView.rootViewController = nil;
      
      // for obj-c, maybe calling one of the following two is ok.
      [adView release];
      adView = nil;
   }
   //<<
   
   //>> java version has no this part (also no need for obj-c now, for self.adListener is a weak reference now)
   if (self.adListener != nil)
   {
      [self.adListener release];
      self.adListener = nil;
   }
   //<<
   
   [super dispose];
}

- (void)pause
{
   if (adView != nil)
   {
      //[adView pause];
   }
}

- (void)resume;
{
   if (adView != nil)
   {
      //[adView resume];
   }
}

- (void)reload
{
   if ([self checkValidity] != nil)
      return;
   
   if (adView == nil)
   {
      adView = [[GADBannerView alloc] initWithAdSize:*adSize];
      adView.adUnitID = self.unitID;
      adView.adSize = *adSize; // no need for ios
   
      //>> java version has no this part (also no need for obj-c now, for self.adListener is a weak reference now)
      if (self.adListener != nil)
      {
         [self.adListener release];
         self.adListener = nil;
      }
      //<<
      
      self.adListener = [[AdMob_Listener alloc] initWithAdMobAd:self];
      adView.delegate = self.adListener;

      adView.hidden = true;
      AdMob_ViewController* bannerContainer = [self.context getBannderAdContainer];
      adView.rootViewController = bannerContainer;
      [bannerContainer.view addSubview:adView];
      
      [self updatePosition];
   }
   
   [adView loadRequest:[self.context createNewAdRequest]];
   
   //log ("request new banner");
}

- (void)updatePosition
{
   if (adView != nil)
   {
      double windowBounds [4];
      [Context_AdMob getWindowBounds:windowBounds];
      double windowWidth  = windowBounds [2];
      double windowHeight = windowBounds [3];
   
      //>> for ios only (handle orientation changing)
      const GADAdSize * newAdSize = [Context_AdMob getAdSizeByBannerType:self.type];
      if (newAdSize != adSize) // caused by orientation changed.
      {
         adSize = newAdSize;
         adView.adSize = *adSize;
      }
      //<<
      
      double adWidth, adHeight;
      CGSize size = CGSizeFromGADAdSize(*adSize);
      adWidth = size.width;
      adHeight = size.height;
      
      // orientation may change, so above 2 lines are safer.
      //if (adView.mediatedAdView != nil)
      //{
      //   adWidth = adView.mediatedAdView.width;
      //   adHeight = adView.mediatedAdView.height;
      //}
      //else
      //{
      //   adWidth = adView.width;
      //   adHeight = adView.height;
      //}
      
      float adx, ady;
      
      if (((int)posX) == Position_CenterOrMiddle)
         adx = 0.5 * (windowWidth - adWidth);
      else if (((int)posX) == Position_LeftOrTop) // || ((int)posX) == Position_Sibling_Left)
         adx = 0;
      else if (((int)posX) == Position_RightOrBottom) // || ((int)posX) == Position_Sibling_Right)
         adx = windowWidth - adWidth;
      else {
         adx = posX;
         adx /= [[UIScreen mainScreen] scale]; // ios only (as3 inputs are pixels)
      }
      
      if (((int)posY) == Position_CenterOrMiddle)
         ady = 0.5 * (windowHeight - adHeight);
      else if (((int)posY) == Position_LeftOrTop) // || ((int)posY) == Position_Sibling_Top)
         ady = 0;
      else if (((int)posY) == Position_RightOrBottom) // || ((int)posY) == Position_Sibling_Bottom)
         ady = windowHeight - adHeight;
      else {
         ady = posY;
         ady /= [[UIScreen mainScreen] scale]; // ios only (as3 inputs are pixels)
      }
      
      adView.frame = CGRectMake(adx, ady, adWidth, adHeight);
      adView.bounds = CGRectMake(0, 0, adWidth, adHeight);
   }
}

- (void)getBounds:(double[])bounds
{
   if (adView == nil || [adView superview] == nil || [self checkValidity] != nil) {
      [Context_AdMob fillZeros:bounds];
      
      return;
   }
   
   bounds [0] = adView.frame.origin.x;
   bounds [1] = adView.frame.origin.y;
   bounds [2] = adView.frame.size.width;
   bounds [3] = adView.frame.size.height;
}

- (BOOL)isVisible
{
   return adView != nil && adView.hidden == NO && [adView superview] != nil && [adView superview].hidden == NO;
}

- (void)show
{
   if ([self checkValidity] != nil)
   {
      //[self hide];
      return;
   }
   
   showOnReady = YES;
   
   if (adView == nil)
   {
      [self prepare];
      return;
   }

   if ([self isReady])
   {
      if (! [self isVisible])
      {
         adView.hidden = NO;
         [self.context updateBannderAdContainer];
         
         //>> padding (todo, to find the AIR main view then change its frame)
         /*
         ViewGroup vg = (ViewGroup) (context.getActivity ().findViewById (android.R.id.content));
         vg = (ViewGroup) vg.getChildAt (0);
         
         if (((int)posX) == Context_AdMob.Position_Sibling_Left)
            vg.setPadding (adView.getWidth (), vg.getPaddingTop (), vg.getPaddingRight (), vg.getPaddingBottom ());
         else if (((int)posX) == Context_AdMob.Position_Sibling_Right)
            vg.setPadding (vg.getPaddingLeft (), vg.getPaddingTop (), adView.getWidth (), vg.getPaddingBottom ());
         
         if (((int)posY) == Context_AdMob.Position_Sibling_Top)
            vg.setPadding (vg.getPaddingLeft (), adView.getHeight (), vg.getPaddingRight (), vg.getPaddingBottom ());
         else if (((int)posY) == Context_AdMob.Position_Sibling_Bottom)
            vg.setPadding (vg.getPaddingLeft (), vg.getPaddingTop (), vg.getPaddingRight (), adView.getHeight ());
         */
         //<<
      }
      
      showOnReady = NO;
   }
   else
   {
      [self prepare];
   }
}

- (void)hide
{
   //if (adView != nil && [adView superview] != nil)
   //{
   //   [adView removeFromSuperview];
   //}
   
   if (adView != nil)
   {
      adView.hidden = YES;
      [self.context updateBannderAdContainer];
   }
   
   showOnReady = NO;
}
 
@end



@implementation Ad_AdMobInterstitial



- (void)initialize
{
   if (! Is_AdMob_Supported ())
   {
      [self setInvalidReason:@"ios version is too old"];
      return;
   }
   
   if (self.unitID == nil) {
      self.unitID = @"";
   } else {
      self.unitID = [self.unitID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   }
   
   if ([self.unitID length] == 0) {
      [self setInvalidReason:@"invalid unit id"];
   }
}

- (void)buildInterstitial
{
   if (viewController == nil)
   {
      viewController = [[AdMob_ViewController alloc] initWithContext:self.context];
      
      [[[[UIApplication sharedApplication] delegate] window] addSubview:viewController.view];
      viewController.view.userInteractionEnabled = NO;
   }
   
   if (interstitial == nil)
   {
      interstitial = [[GADInterstitial alloc] init];
   }
   
   if (self.adListener == nil)
   {
      self.adListener = [[AdMob_Listener alloc] initWithAdMobAd:self];
   }
}

- (void)destroyInterstitial
{
   if (viewController != nil)
   {
      if ([viewController.view superview] != nil)
      {
         [viewController.view removeFromSuperview];
      }
      
      [viewController release];
      viewController = nil;
   }
   
   if (self.adListener != nil)
   {
      [self.adListener release];
      self.adListener = nil;
   }
   
   if (interstitial != nil)
   {  
      interstitial.delegate = nil;
      
      [interstitial release];
      interstitial = nil;
   }
   
   interstitialInShowing = nil;
}

//=========================== as Ad_AdMob
 
- (id)initWithKeyAndContext:(NSNumber*)adkey admobContext:(Context_AdMob*)adcontext type:(int)t unitID:(NSString *)unitid
{
   self = [super initWithKeyAndContext:adkey admobContext:adcontext type:t unitID:unitid];
   
   if (self) {
      interstitial = nil;
      interstitialInShowing = nil;
      viewController = nil;
      
      [self initialize];
   }
   
   return self;
}

//- (void)onAdOpened
//{
//}

 - (void)onAdClosed
 {
   [self destroyInterstitial];
   
   interstitialInShowing = nil;
   
   // ...
   interstitial = nil;
   [self resetReady];
   [self prepare]; // for next show
}

//=========================== as Ad

- (BOOL)forbitRefreshingWhenReady
{
   return interstitial != nil;
}

- (void)dispose
{
   //>> java version has no this part
   [self destroyInterstitial];
   //<<
   
   //>> maybe no needs
   interstitial = nil;
   interstitialInShowing = nil;
   //<<
   
   [super dispose];
}

- (BOOL)isReadySafely
{
   return interstitial != nil && [interstitial isReady]
         && viewController != nil;
}

- (void)reload
{  
   if ([self checkValidity] != nil)
      return;
   
   if (interstitial == nil) {
      [self buildInterstitial];
      
      interstitial.adUnitID  = self.unitID;
      
      interstitial.delegate = self.adListener; // listener is created in buildInterstitial
   }
   
   [interstitial loadRequest:[self.context createNewAdRequest]];
   
   //log ("request new interstitial");
}

- (void)getBounds:(double[])bounds
{
   [Context_AdMob getWindowBounds:bounds];
   
   // implementation 1
   //bounds [2] += bounds [0];
   //bounds [3] += bounds [1];
   
   // implementation 2
   double size[2];
   [Context_AdMob getScreenSize:size]; // bounds+2];
   bounds [2] = size [0];
   bounds [3] = size [1];
   
   // make the values relative to app window origin.
   bounds [0] = - bounds [0];
   bounds [1] = - bounds [1];
}

- (BOOL)isVisible
{
   return interstitialInShowing != nil;
}

- (void)show
{
   //if ([self checkValidity] != nil)
   //   return;
   
   if ([self isVisible])
      return;
   
   if (interstitial == nil) {
      [self prepare];
      return;
   }
   
   //>> java version has no this
   if (viewController == nil)
      return;
   //<<
   
   if ([self isReady]) {
      interstitialInShowing = interstitial;
      viewController.view.userInteractionEnabled = YES;
      [interstitialInShowing presentFromRootViewController:viewController];
   }
}

- (void)hide
{
}
 
@end



@implementation AdMob_Listener

- (id)initWithAdMobAd:(Ad_AdMob*)admobAd
{
   self = [super init];
   
   if (self) {
      _ad = admobAd;
   }
   
   return self;
}

- (void)onAdLoaded
{
   if ([_ad adListener] == self)
   {
      [_ad onAdLoaded];
      
      [_ad.context dispatchStatusEventAsyncWithCode:EventCode_AdLoaded AndLevel:[_ad.key stringValue]];
   }
}

- (void)onAdFailedToLoad:(int)errorCode
{
   if ([_ad adListener] == self)
   {
      NSString* errorReason;
      switch (errorCode)
      {
         case kGADErrorInvalidRequest:
            errorReason = @"InvalidRequest";
            break;
         case kGADErrorNoFill:
            errorReason = @"NoFill";
            break;
         case kGADErrorNetworkError:
            errorReason = @"NetworkError";
            break;
         case kGADErrorServerError:
            errorReason = @"ServerError";
            break;
         case kGADErrorOSVersionTooLow:
            errorReason = @"OSVersionTooLow";
            break;
         case kGADErrorTimeout:
            errorReason = @"Timeout";
            break;
         case kGADErrorInterstitialAlreadyUsed:
            errorReason = @"InterstitialAlreadyUsed";
            break;
         case kGADErrorMediationDataError:
            errorReason = @"MediationDataError";
            break;
         case kGADErrorMediationAdapterError:
            errorReason = @"MediationAdapterError";
            break;
         case kGADErrorMediationNoFill:
            errorReason = @"MediationNoFill";
            break;
         case kGADErrorMediationInvalidAdSize:
            errorReason = @"MediationInvalidAdSize";
            break;
         case kGADErrorInternalError:
            errorReason = @"Internal error";
            break;
         case kGADErrorInvalidArgument:
            errorReason = @"InvalidArgument";
            break;
         case kGADErrorReceivedInvalidResponse:
            errorReason = @"ReceivedInvalidResponse";
            break;
         default:
         {
            errorReason = @"";
         }
      }
      
      [_ad onAdFailedToLoad];
      
      [_ad.context dispatchStatusEventAsyncWithCode:EventCode_AdFailedToLoad AndLevel:[NSString stringWithFormat:@"%d_/%@", [_ad.key intValue], errorReason]];
   }
}

- (void)onAdOpened
{
   if ([_ad adListener] == self)
   {
      [_ad onAdOpened];
      
      [_ad.context dispatchStatusEventAsyncWithCode:EventCode_AdOpened AndLevel:[_ad.key stringValue]];
   }
}

- (void)onAdClosed
{
   if ([_ad adListener] == self)
   {
      [_ad onAdClosed];
      
      [_ad.context dispatchStatusEventAsyncWithCode:EventCode_AdClosed AndLevel:[_ad.key stringValue]];
   }
}

//============================== banner

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
   [self onAdLoaded];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
   [self onAdFailedToLoad:[error code]];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
   [self onAdOpened];
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
   [self onAdClosed];
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
}

//============================== interstitial

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
   [self onAdLoaded];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
   [self onAdFailedToLoad:[error code]];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
   [self onAdOpened];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
   [self onAdClosed];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
}
 
@end




@implementation AdMob_ViewController

- initWithContext:(Context_AdMob*)context
{
   self = [super init];
   
   if (self) {
      adMobContext = context;
   }
   
   return self;
}

-(BOOL)shouldAutorotate
{
    return [[adMobContext getStageViewController] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[adMobContext getStageViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[adMobContext getStageViewController] preferredInterfaceOrientationForPresentation];
}

// todo: add orientation change notifications
// [adMobContext onOrientationChangaed] // to notify all banner ads to reposition.

@end
