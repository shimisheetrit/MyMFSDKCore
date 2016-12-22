//
//  ViewController.h
//  DemoApp
//
//  Created by Shimi Sheetrit on 2/1/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobFoxSDKCore/MobFoxSDKCore.h>
#import <iSoma/iSoma.h>
#import "MoPub.h"
#import "MPNativeAdConstants.h"
#import "MoPubNativeAdView.h"
//#import "MoPubNativeAdapterMobFox.h"
#import "MPAdView.h"
#import "MPCollectionViewAdPlacer.h"
//#import "MoPubAdapterMobFox.h"


@import FBAudienceNetwork;
@import GoogleMobileAds;



@interface MainViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, MobFoxAdDelegate, MobFoxInterstitialAdDelegate, MobFoxNativeAdDelegate, FBAdViewDelegate, MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPNativeAdDelegate, MPCollectionViewAdPlacerDelegate, GADInterstitialDelegate, GADBannerViewDelegate, SOMAAdViewDelegate, SOMANativeAdDelegate>

@property (strong, nonatomic) NSString *invh;
@property (nonatomic, retain) MPAdView *adView;
@property (nonatomic, retain) MPCollectionViewAdPlacer* placer;
@property (nonatomic, retain) UICollectionView* collectionView_new;

@property (nonatomic, strong) GADBannerView *gadBannerView;
@property (nonatomic, strong) DFPBannerView *dfpBannerView;

@property (nonatomic, strong) GADInterstitial *gadInterstitial;
@property (nonatomic, strong) DFPInterstitial *dfpInterstitial;

@property (nonatomic, strong) SOMAAdView* somaBanner;
@property (nonatomic, strong) SOMAInterstitialAdView* somaInterstitial;
@property (nonatomic, strong) SOMANativeAd* somaNative;




@end

