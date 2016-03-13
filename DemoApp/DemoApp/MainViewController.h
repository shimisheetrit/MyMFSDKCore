//
//  ViewController.h
//  DemoApp
//
//  Created by Shimi Sheetrit on 2/1/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobFoxSDKCore/MobFoxSDKCore.h>
//#import "MPInterstitialAdController.h"
//#import "MoPubInterstitialAdapterMobFox.h"
//#import "MoPub.h"
//#import "MPNativeAd.h"
@import FBAudienceNetwork;


@interface MainViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, MobFoxAdDelegate, MobFoxInterstitialAdDelegate, MobFoxNativeAdDelegate, FBAdViewDelegate>

@property (strong, nonatomic) NSString *invh;
//@property (strong, nonatomic) MPInterstitialAdController *interstitial;

@end

