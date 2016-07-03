//
//  GADMobFoxCustomEvent.m
//  BannerExample
//
//  Created by Itamar Nabriski on 11/3/15.
//  Copyright © 2015 Google. All rights reserved.
//

#import "GADMAdapterMobFox.h"

@implementation GADMAdapterMobFox

- (void)requestBannerAd:(GADAdSize)adSize parameter:(NSString *)serverParameter label:(NSString *)serverLabel request:(GADCustomEventRequest *)request{

    NSLog(@"MobFox >> GADMAdapterMobFox >> Got Ad Request");
    NSLog(@"MobFox >> GADMAdapterMobFox >> hash: %@",serverParameter);
    
    self.banner = [[MobFoxAd alloc] init:serverParameter withFrame:CGRectMake(0,0,adSize.size.width,adSize.size.height)];
    self.banner.delegate = self;
    [self.banner loadAd];
    
    
}
                   
//called when ad is displayed
- (void)MobFoxAdDidLoad:(MobFoxAd *)banner{
     NSLog(@"MobFox >> GADMAdapterMobFox >> Got Ad");
    
    [self.delegate customEventBanner:self didReceiveAd:banner];
    
    self.banner = nil;
    
}

- (void)MobFoxAdDidFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Error: %@",[error description]);
    
    self.banner = nil;
    [self.delegate customEventBanner:self didFailAd:error];
}


- (void)MobFoxAdClosed {
    
}


- (void)MobFoxAdClicked {
    //[self.delegate customEventBannerWasClicked:self];
    
    [self.delegate customEventBanner:self clickDidOccurInAd:nil];
    
}

- (void)MobFoxAdFinished{
   
}

- (void) dealloc{
    
    self.banner.bridge = nil;
    self.banner        = nil;
}

@end