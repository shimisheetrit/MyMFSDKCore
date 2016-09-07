//
//  FacebookBannerCustomEvent.m
//  MoPub
//
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import "MoPubAdapterMobFox.h"

#import "MPInstanceProvider.h"
#import "MPLogging.h"

#import <MobFoxSDKCore/MobFoxSDKCore.h>

@interface MoPubAdapterMobFox () <MobFoxAdDelegate>

@property (nonatomic, strong) MobFoxAd * mobfoxAdView;

@end

@implementation MoPubAdapterMobFox

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
	NSString * appId = [info objectForKey:@"invh"];
	if (appId)
	{
		[MobFoxAd locationServicesDisabled:YES];
		CGRect frame;
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			frame = CGRectMake(0, 0, MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
		else
			frame = CGRectMake(0, 0, MOPUB_LEADERBOARD_SIZE.width, MOPUB_LEADERBOARD_SIZE.height);
		self.mobfoxAdView = [[MobFoxAd alloc] init:appId withFrame:frame];
		self.mobfoxAdView.delegate = self;
		[self.mobfoxAdView loadAd];
	}
	else
	{
		[self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
	}
    

}

- (void)MobFoxAdDidLoad:(MobFoxAd *)banner {

	[self.delegate bannerCustomEvent:self didLoadAd:banner];
}
- (void)MobFoxAdDidFailToReceiveAdWithError:(NSError *)error
{
	[self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}
- (void)MobFoxAdClicked
{
	[self.delegate bannerCustomEventWillBeginAction:self];
}
- (void)MobFoxAdFinished
{
	[self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)invalidate
{
	if (self.mobfoxAdView)
	{
		[self stopWebViewInView:self.mobfoxAdView];
		self.mobfoxAdView.bridge = nil;
		self.mobfoxAdView.delegate = nil;
		[self.mobfoxAdView removeFromSuperview];
		self.mobfoxAdView = nil;
	}
}

- (void) stopWebViewInView:(UIView *)view {
    if ([view isKindOfClass:[UIWebView class]]) {
        UIWebView * webView = (UIWebView *)view;
        webView.delegate = nil;
        [webView stopLoading];
    }
    
    NSArray * subviews = view.subviews;
    if (subviews.count == 0)
        return;
    
    for (UIView * subview in subviews)
        [self stopWebViewInView:subview];
}

- (void)dealloc
{
	[self invalidate];
}

@end
