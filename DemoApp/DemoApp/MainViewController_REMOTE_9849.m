//
//  ViewController.m
//  DemoApp
//
//  Created by Shimi Sheetrit on 2/1/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "CollectionViewCell.h"
#import "SettingsViewController.h"
#import "NativeAdViewController.h"
#import "MPMobFoxNativeAdRenderer.h"
#import "MoPubNativeAdapterMobFox.h"



#define NATIVEAD_ADAPTER_TEST 0
#define ADMOB_ADAPTER_TEST 0
#define MOPUB_ADAPTER_TEST 0


#define ADS_TYPE_NUM 5
#define AD_REFRESH 0


#define MOBFOX_HASH_BANNER @"fe96717d9875b9da4339ea5367eff1ec"
#define MOBFOX_HASH_INTER @"267d72ac3f77a3f447b32cf7ebf20673" //inter video
//#define MOBFOX_HASH_INTER @"267d72ac3f77a3f447b32cf7ebf20673"

#define MOBFOX_HASH_NATIVE @"4c3ea57788c5858881dc42cfafe8c0ab"
#define MOBFOX_HASH_VIDEO @"80187188f458cfde788d961b6882fd53"
#define MOBFOX_HASH_AUDIO @"75f994b45ca31b454addc8b808d59135"

#define MOPUB_HASH_NATIVE @"ac0f139a2d9544fface76d06e27bc02a"
#define MOPUB_HASH_BANNER @"234dd5a1b1bf4a5f9ab50431f9615784"

@interface MainViewController ()

@property (strong, nonatomic) MobFoxAd *mobfoxAd;
@property (strong, nonatomic) MobFoxInterstitialAd *mobfoxInterAd;
@property (strong, nonatomic) MobFoxNativeAd* mobfoxNativeAd;
@property (strong, nonatomic) MobFoxAd *mobfoxVideoAd;
@property (strong, nonatomic) NSURL *clickURL;
@property (strong, nonatomic) NSString *cellID;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *nativeAdView;
@property (weak, nonatomic) IBOutlet UIView *innerNativeAdView;

@property (weak, nonatomic) IBOutlet UIImageView *nativeAdIcon;
@property (weak, nonatomic) IBOutlet UILabel *nativeAdTitle;
@property (weak, nonatomic) IBOutlet UILabel *nativeAdDescription;

@property (strong, nonatomic) MPAdView *mpAdView;
@property (nonatomic) CGRect videoAdRect;
@property (nonatomic) CGRect bannerAdRect;




@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.cellID = @"cellID";
    self.nativeAdView.hidden = true;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.innerNativeAdView addGestureRecognizer:recognizer];
    
    // Oreintation dependent in iOS 8 and later.
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float bannerWidth = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 728.0 : 320.0;
    float bannerHeight = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 90.0 : 50.0;
    float videoWidth = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 500.0 : 300.0;
    float videoHeight = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 450.0 : 250.0;
    
    /*** Banner ***/
    
    [MobFoxAd locationServicesDisabled:true];
    
    self.bannerAdRect = CGRectMake((screenWidth-bannerWidth)/2, screenHeight-bannerHeight, bannerWidth, bannerHeight);
    self.mobfoxAd = [[MobFoxAd alloc] init:MOBFOX_HASH_BANNER withFrame:self.bannerAdRect];
    self.mobfoxAd.delegate = self;
    self.mobfoxAd.auto_pilot = true;
    self.mobfoxAd.refresh = [NSNumber numberWithInt:AD_REFRESH];
    [self.view addSubview:self.mobfoxAd];
    
//    self.view.hidden = true;
//    bool isVisible = [self.mobfoxAd isViewVisible];
//    NSLog(@"isVisible: %d", isVisible);
    
    
    /*** Interstitial ***/
    
    [MobFoxInterstitialAd locationServicesDisabled:true];
    
    self.mobfoxInterAd = [[MobFoxInterstitialAd alloc] init:MOBFOX_HASH_INTER withRootViewController:self];
    //self.mobfoxInterAd.ad.type = @"video";
    self.mobfoxInterAd.delegate = self;
    self.mobfoxInterAd.ad.autoplay =  true;
    
    
    /*** Native ***/
    
    [MobFoxNativeAd locationServicesDisabled:true];

    self.mobfoxNativeAd = [[MobFoxNativeAd alloc] init:MOBFOX_HASH_NATIVE];
    self.mobfoxNativeAd.delegate = self;
    
    
    
    /*** Video ***/
    
    [MobFoxAd locationServicesDisabled:true];

    float videoTopMargin = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 200.0 : 80.0;
    self.videoAdRect = CGRectMake((screenWidth - videoWidth)/2, self.collectionView.frame.size.height + videoTopMargin, videoWidth, videoHeight);
    self.mobfoxVideoAd = [[MobFoxAd alloc] init:MOBFOX_HASH_VIDEO withFrame:self.videoAdRect];
    
    self.mobfoxVideoAd.delegate = self;
    self.mobfoxVideoAd.type = @"video";
    self.mobfoxVideoAd.auto_pilot = YES;
    self.mobfoxVideoAd.autoplay = YES;
    [self.view addSubview:self.mobfoxVideoAd];
    
    
    
    #if NATIVEAD_ADAPTER_TEST

    // TEST: native ad adapter
    MobFoxNativeAd *nativeAd = [[MobFoxNativeAd alloc] init:MOBFOX_HASH_NATIVE];
    //NSLog(@"nativeAd: %@", nativeAd);
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MobFoxNativeAd *nativeAd = [[MobFoxNativeAd alloc] init:MOBFOX_HASH_NATIVE];
        //NSLog(@"nativeAd: %@", nativeAd);

    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        MoPubNativeAdapterMobFox *nativeAdAdapter = [[MoPubNativeAdapterMobFox alloc] init];
        nativeAdAdapter.delegate = self;
        [nativeAdAdapter requestAdWithCustomEventInfo:nil];
        
    });
    
    #endif
    
    
    #if ADMOB_ADAPTER_TEST
    
    // banner.
    /*
    self.gadBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 430, 320, 50)];
    self.gadBannerView.adUnitID = @"ca-app-pub-6224828323195096/5240875564";
    self.gadBannerView.rootViewController = self;
    [self.view addSubview: self.gadBannerView];
    GADRequest *request = [[GADRequest alloc] init];
    //request.testDevices = @[ @"221e6c438e8184e0556942ea14bb214b" ];
    [self.gadBannerView loadRequest:request];
    
    
    // interstitial
    self.gadInterstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-6224828323195096/7876284361"];
    GADRequest *request_interstitial = [GADRequest request];
    // Requests test ads on test devices.
    //request_interstitial.testDevices = @[ @"221e6c438e8184e0556942ea14bb214b" ];
    self.gadInterstitial.delegate = self;
    [self.gadInterstitial loadRequest:request_interstitial];
    NSLog(@"%s", GoogleMobileAdsVersionString);
     */
    
    
    // DFP request.
    self.dfpBannerView = [[DFPBannerView alloc] initWithFrame:CGRectMake(0, 330, 320, 50)];
    self.dfpBannerView.adUnitID = @"ca-app-pub-6224828323195096/5240875564";
    self.dfpBannerView.rootViewController = self;
    [self.dfpBannerView loadRequest:[DFPRequest request]];
    [self.view addSubview: self.dfpBannerView];
    
    
    self.dfpInterstitial = [[DFPInterstitial alloc] initWithAdUnitID:@"ca-app-pub-6224828323195096/7876284361"];
    GADRequest *dfp_request = [GADRequest request];
    self.dfpInterstitial.delegate = self;
    // Requests test ads on test devices.
    dfp_request.testDevices = @[ @"221e6c438e8184e0556942ea14bb214b" ];
    [self.dfpInterstitial loadRequest:dfp_request];
    

    
    #endif
    
    #if MOPUB_ADAPTER_TEST
    self.mpAdView = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_BANNER
                                                     size:MOPUB_BANNER_SIZE];
    self.mpAdView.delegate = self;
    self.mpAdView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.mpAdView];
    [self.mpAdView loadAd];
    #endif
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //NSLog(@"viewWillDisappear");
    
    [super viewWillDisappear:animated];
    [self.mobfoxVideoAd pause];
    //self.mobfoxVideoAd = nil;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)viewControllerForPresentingModalView {
    
    return self;
}

#pragma mark Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return ADS_TYPE_NUM;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{

    CollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    cell.title.text = [self adTitle:indexPath];
    cell.image.image = [self adImage:indexPath];
    
    if (cell.selected) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor]; // Default color
    }
    
    return cell;
}

#pragma mark Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    switch (indexPath.item) {
        case 0:

            [self hideAds:indexPath];
            [self.mobfoxVideoAd pause];
            self.mobfoxAd.invh = self.invh.length > 0 ? self.invh: MOBFOX_HASH_BANNER;
            [self.mobfoxAd loadAd];
            
            break;
            
        case 1:

            [self hideAds:indexPath];
            [self.mobfoxVideoAd pause];
            self.mobfoxInterAd.ad.invh = self.invh.length > 0 ? self.invh: MOBFOX_HASH_INTER;
            [self.mobfoxInterAd loadAd];

            break;
            
        case 2:
            [self hideAds:indexPath];
            [self.mobfoxVideoAd pause];
            self.mobfoxNativeAd.invh = self.invh.length > 0 ? self.invh: MOBFOX_HASH_NATIVE;
            [self.mobfoxNativeAd loadAd];
            
            break;
            
        case 3:
            
            [self hideAds:indexPath];
            self.mobfoxVideoAd.invh = self.invh.length > 0 ? self.invh: MOBFOX_HASH_VIDEO;
            [self.mobfoxVideoAd loadAd];
            break;
            
        case 4:
            
            //UIView *view  = [[UIView alloc] init];
            //UIViewController * vc = [[UIViewController alloc] init];
            
            //UIViewController *vc_ = [[UIViewController alloc] init];
            //[self presentViewController:vc animated:YES completion:nil];
            
            break;


            
        default:
            break;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}



#pragma mark MobFox Ad Delegate

//called when ad is displayed
- (void)MobFoxAdDidLoad:(MobFoxAd *)banner {
    
    NSLog(@"MobFoxAdDidLoad:");
}

//called when an ad cannot be displayed
- (void)MobFoxAdDidFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFoxAdDidFailToReceiveAdWithError: %@", [error description]);
}

//called when ad is closed/skipped
- (void)MobFoxAdClosed {
    NSLog(@"MobFoxAdClosed:");

}

//called when ad is clicked
- (void)MobFoxAdClicked {
    NSLog(@"MobFoxAdClicked:");

}

#pragma mark MobFox Interstitial Ad Delegate

//best to show after delegate informs an ad was loaded
- (void)MobFoxInterstitialAdDidLoad:(MobFoxInterstitialAd *)interstitial {
    
    NSLog(@"MobFoxInterstitialAdDidLoad:");
    
    if(self.mobfoxInterAd.ready){
        [self.mobfoxInterAd show];
    }
}

- (void)MobFoxInterstitialAdDidFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFoxInterstitialAdDidFailToReceiveAdWithError: %@", [error description]);
    
}

- (void)MobFoxInterstitialAdClosed {
    
    NSLog(@"MobFoxInterstitialAdClosed");
    
}

- (void)MobFoxInterstitialAdClicked {
    
    NSLog(@"MobFoxInterstitialAdClicked");
    
}

- (void)MobFoxInterstitialAdFinished {
    
    NSLog(@"MobFoxInterstitialAdFinished");
    
}

#pragma mark MobFox Native Ad Delegate

//called when ad response is returned
- (void)MobFoxNativeAdDidLoad:(MobFoxNativeAd *)ad withAdData:(MobFoxNativeData *)adData {
    
    self.nativeAdIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:adData.icon.url]];
    self.nativeAdTitle.text = adData.assetHeadline;
    self.nativeAdDescription.text = adData.assetDescription;
    self.clickURL = [adData.clickURL absoluteURL];
    
    //adData.callToActionText
    //NSLog(@"adData.assetHeadline: %@", adData.assetHeadline);
    //NSLog(@"adData.assetDescription: %@", adData.assetDescription);
    //NSLog(@"adData.callToActionText: %@", adData.callToActionText);
    
    for (MobFoxNativeTracker *tracker in adData.trackersArray) {
        
        //NSLog(@"tracker: %@", tracker);
        //NSLog(@"tracker.url: %@", tracker.url);

        if ([tracker.url absoluteString].length > 0)
        {
            
            // Fire tracking pixel
            UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString* userAgent = [wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            //NSLog(@"userAgent: %@", userAgent);
            NSURLSessionConfiguration* conf = [NSURLSessionConfiguration defaultSessionConfiguration];
            conf.HTTPAdditionalHeaders = @{ @"User-Agent" : userAgent };
            NSURLSession* session = [NSURLSession sessionWithConfiguration:conf];
            NSURLSessionDataTask* task = [session dataTaskWithURL:tracker.url completionHandler:
                                          ^(NSData *data,NSURLResponse *response, NSError *error){
                                          
                                              if(error) NSLog(@"err %@",[error description]);

                                          }];
            [task resume];
            
        }
        
    }
    
}

//called when ad response cannot be returned
- (void)MobFoxNativeAdDidFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFoxNativeAdDidFailToReceiveAdWithError: %@", [error description]);
    
}


#pragma mark Private Methods

- (void)hideAds:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
        case 0:
            self.mobfoxAd.hidden= NO;
            self.mobfoxInterAd.ad.hidden = YES;
            self.nativeAdView.hidden = YES;
            self.mobfoxVideoAd.hidden = YES;
            
            break;
            
        case 1:
            self.mobfoxAd.hidden= YES;
            self.mobfoxInterAd.ad.hidden = NO;
            self.nativeAdView.hidden = YES;
            self.mobfoxVideoAd.hidden = YES;
            
            break;
            
        case 2:
            self.mobfoxAd.hidden= YES;
            self.mobfoxInterAd.ad.hidden = YES;
            self.nativeAdView.hidden = NO;
            self.mobfoxVideoAd.hidden = YES;
            
            break;
            
        case 3:
            self.mobfoxAd.hidden= YES;
            self.mobfoxInterAd.ad.hidden = YES;
            self.nativeAdView.hidden = YES;
            self.mobfoxVideoAd.hidden = NO;
            
            break;
            
        default:
            break;
    }
    
}

- (NSString *)adTitle:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
        case 0:
            return @"Banner";
            break;
        case 1:
            return @"Interstitial";
            break;
        case 2:
            return @"Native";
            break;
        case 3:
            return @"Video";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UIImage *)adImage:(NSIndexPath *)indexPath {
    
    switch (indexPath.item) {
        case 0:
            return [UIImage imageNamed:@"test_banner.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"test_interstitial.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"test_native.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"test_video.png"];
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    
    [[UIApplication sharedApplication] openURL:self.clickURL];
    
}

- (void)presentViewController {
    
    NativeAdViewController *nativeVC = [[NativeAdViewController alloc] init];
    [self presentViewController:nativeVC animated:YES completion:nil];
    
}

#pragma mark Mopub Ad Delegate

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"Mopub -- adViewDidLoadAd");
}

#pragma mark Mopub Nativew Ad Delegate

-(void)nativeAdWillPresentModalForCollectionViewAdPlacer:(MPCollectionViewAdPlacer *)placer{
    NSLog(@">> first");
}

-(void)nativeAdDidDismissModalForCollectionViewAdPlacer:(MPCollectionViewAdPlacer *)placer{
    NSLog(@">> second");
}

-(void)nativeAdWillLeaveApplicationFromCollectionViewAdPlacer:(MPCollectionViewAdPlacer *)placer{
    NSLog(@">> third");
}


#pragma mark AdMob Ad Delegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    
}


#pragma mark AdMob interstitial Ad Delegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
    NSLog(@"interstitialDidReceiveAd");
    
    if(ad.isReady) {
        
        if(self.gadInterstitial) {
            [self.gadInterstitial presentFromRootViewController:self];
        }
        else {
            [self.dfpInterstitial presentFromRootViewController:self];
        }
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error description]);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen:");
    
}

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidFailToPresentScreen:");
    
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen:");

}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen:");

}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication:");
}


@end




