//
//  MobFoxCustomEventAmazon.m
//  MobFoxCoreDemo
//
//  Created by Shimon Shnitzer on 17/5/16.
//  Copyright © 2015 Shimon Shnitzer. All rights reserved.
//

#import "MobFoxCustomEventAmazon.h"

#import <AmazonAd/AmazonAdRegistration.h>
#import <AmazonAd/AmazonAdView.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdError.h>

@implementation MobFoxCustomEventAmazon

//========================================================================

- (UIViewController *)viewControllerForPresentingModalView
{
    return self.rootVC;
}

- (void)adViewWillExpand:(AmazonAdView *)view
{
    NSLog(@"dbg: ### AMAZON: >>> BANNER AMAZON: adViewWillExpand <<<");
    
    [self.delegate MFCustomEventMobFoxAdClicked];
}

- (void)adViewDidCollapse:(AmazonAdView *)view
{
    
}

- (void)adViewWillResize:(AmazonAdView *)view toFrame:(CGRect)frame
{
    
}

- (BOOL)willHandleAdViewResize:(AmazonAdView *)view toFrame:(CGRect)frame
{
    return FALSE;
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error
{
    NSLog(@"dbg: ### AMAZON: >>> BANNER AMAZON: adViewDidFailToLoad %@ <<<",error.errorDescription);
    
    NSError *myErr = [NSError errorWithDomain:error.errorDescription
                                         code:error.errorCode
                                     userInfo:nil];
    [self.delegate MFCustomEventAdDidFailToReceiveAdWithError:myErr];
}

- (void)adViewDidLoad:(AmazonAdView *)view
{
    NSLog(@"dbg: ### AMAZON: >>> BANNER AMAZON: adViewDidLoad <<<");
    
    [self.delegate MFCustomEventAd:self didLoad:view];    
}

//========================================================================

- (void)requestAdWithSize:(CGSize)size
                networkID:(NSString*)networkId
          customEventInfo:(NSDictionary *)info
{
    NSLog(@"dbg: ### Amazon: loadAd ###");
    NSLog(@"dbg: ### Amazon: params: %@",info);
    NSLog(@"dbg: ### Amazon: networkID: %@",networkId);
    
    [[AmazonAdRegistration sharedRegistration] setAppKey:networkId];
    
    // Load an ad
    // Create an AmazonAdView instance with size 320x50.
    self.amazonAdView = [AmazonAdView amazonAdViewWithAdSize:AmazonAdSize_320x50];
    
    // Set the adOptions.
    AmazonAdOptions *options = [AmazonAdOptions options];
    
    // Turn on isTestRequest to load a test ad
    options.isTestRequest = YES;
    
    // Register the ViewController with the delegate to receive callbacks.
    _amazonAdView.delegate = self;
    
    // Call loadAd
    [_amazonAdView loadAd:options];
    
    self.rootVC = (UIViewController*)[[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];

    // Ad the AmazonAdView to your viewController’s view.
    [self.rootVC.view addSubview:self.amazonAdView];
}

-(void)dealloc{
    
}

@end