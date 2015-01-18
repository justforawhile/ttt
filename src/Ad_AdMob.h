#ifndef _AD_ADMOB_H
#define _AD_ADMOB_H

#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "GADAdSize.h"
#import "GADRequest.h"

#import "Context_AdMob.h"

#import "Ad.h"

@class Context_AdMob;

@class AdMob_Listener;
      
//=========================== Ad_AdMob

@interface Ad_AdMob : Ad

@property(nonatomic, assign, readonly) NSNumber* key;
@property(nonatomic, assign, readonly) Context_AdMob *context;
//@property(nonatomic, assign, readwrite) AdMob_Listener *adListener;
@property(nonatomic, strong, readwrite) AdMob_Listener *adListener;

- (id)initWithKeyAndContext:(NSNumber*)adkey admobContext:(Context_AdMob*)adcontext type:(int)t unitID:(NSString *)unitid;

- (int)getId;

- (GADBannerView*)getAdView;

- (void)onAdOpened; // to override
- (void)onAdClosed; // to override
- (void)onAdLoaded; // to override
- (void)onAdFailedToLoad; // to override

@end
      
//=========================== Ad_AdMobBanner


@interface Ad_AdMobBanner : Ad_AdMob {
   
   GADBannerView* adView;
   const GADAdSize* adSize;
   
   BOOL showOnReady;
}

@end
      
//=========================== Ad_AdMobInterstitial

@class AdMob_ViewController;

@interface Ad_AdMobInterstitial : Ad_AdMob {

   GADInterstitial* interstitial;
   GADInterstitial* interstitialInShowing;
   
   //>> java version has no this
   AdMob_ViewController* viewController;
   //<<
}
      

@end
      
//=========================== AdMob_Listener


@interface AdMob_Listener : NSObject <GADBannerViewDelegate, GADInterstitialDelegate>

@property(nonatomic, assign, readonly) Ad_AdMob *ad;

- (id)initWithAdMobAd:(Ad_AdMob*)admobAd;

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error;
- (void)adViewDidDismissScreen:(GADBannerView *)adView;
- (void)adViewDidReceiveAd:(GADBannerView *)view;
- (void)adViewWillDismissScreen:(GADBannerView *)adView;
- (void)adViewWillLeaveApplication:(GADBannerView *)adView;
- (void)adViewWillPresentScreen:(GADBannerView *)adView;

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error;
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad;
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad;
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad;
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad;
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad;

@end
      
//=========================== AdMob_Listener


@interface AdMob_ViewController : UIViewController {
   Context_AdMob* adMobContext;
}

- initWithContext:(Context_AdMob*)context;

@end

#endif
