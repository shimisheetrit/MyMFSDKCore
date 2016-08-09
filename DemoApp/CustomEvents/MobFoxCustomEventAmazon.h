//
//  MobFoxCustomEventAmazon.h
//  MobFoxCoreDemo
//
//  Created by Shimon Shnitzer on 17/5/16.
//  Copyright © 2015 Shimon Shnitzer. All rights reserved.
//

#ifndef MobFoxCustomEventAmazon_h
#define MobFoxCustomEventAmazon_h

#import <MobFoxSDKCore/MobFoxSDKCore.h>
#import <AmazonAd/AmazonAdRegistration.h>
#import <AmazonAd/AmazonAdView.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdError.h>

@interface MobFoxCustomEventAmazon : MobFoxCustomEvent <AmazonAdViewDelegate>

@property (strong, nonatomic) AmazonAdView *amazonAdView;
@property (strong, nonatomic) UIViewController *rootVC;

- (void)requestAdWithSize:(CGSize)size networkID:(NSString*)nid customEventInfo:(NSDictionary *)info;

@end

#endif /* MobFoxCustomEventAmazon_h */