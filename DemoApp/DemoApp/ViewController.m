//
//  ViewController.m
//  DemoApp
//
//  Created by Shimi Sheetrit on 2/1/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

NSString *kCellID = @"cellID";

#define MOBFOX_HASH_BANNER @"fe96717d9875b9da4339ea5367eff1ec"
#define MOBFOX_HASH_INTER @"267d72ac3f77a3f447b32cf7ebf20673"
#define MOBFOX_HASH_NATIVE @"80187188f458cfde788d961b6882fd53"


@interface ViewController ()

@property (strong, nonatomic) MobFoxAd *mobfoxAd;
@property (strong, nonatomic) MobFoxInterstitialAd *mobfoxInterAd;
@property (strong, nonatomic) MobFoxNativeAd* mobfoxNativeAd;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //define the position and dimensions of your ad
    CGRect  adRect = CGRectMake(0, 200, 320, 50);
    
    //init your ad
    self.mobfoxAd = [[MobFoxAd alloc] init:MOBFOX_HASH_BANNER withFrame:adRect];
    self.mobfoxAd.delegate = self;
    self.mobfoxAd.refresh = [NSNumber numberWithInt:5];
    
    // self.mobfoxAd.frame.origin.x =
    //add it to your view
    [self.view addSubview:self.mobfoxAd];
    
    //call to display ad
    [self.mobfoxAd loadAd];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    CollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    //cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    //cell.image.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"collectionView:didSelectItemAtIndexPath:");
    NSLog(@"collectionView:didSelectItemAtIndexPath: %ld", (long)indexPath.row);
    NSLog(@"collectionView:didSelectItemAtIndexPath: %ld", (long)indexPath.item);
    
    
    
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

#pragma mark MobFox Interstitial Ad Delegate

//best to show after delegate informs an ad was loaded
- (void)MobFoxInterstitialAdDidLoad:(MobFoxInterstitialAd *)interstitial {
    
    NSLog(@"MobFoxInterstitialAdDidLoad:");
    
    if(self.mobfoxInterAd.ready){
        [self.mobfoxInterAd show];
    }
}

- (void)MobFoxInterstitialAdDidFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFoxInterstitialAdDidFailToReceiveAdWithError: %@", error);
    
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
- (void)MobFoxNativeAdDidLoad:(MobFoxNativeData *)ad {
    
    NSLog(@"ad.assetHeadline: %@",ad.assetHeadline);
    NSLog(@"ad.assetDescription: %@",ad.assetDescription);
    NSLog(@"ad.callToActionText: %@",ad.callToActionText);
    NSLog(@"ad.advertiserName: %@",ad.advertiserName);
    NSLog(@"ad.socialContext: %@",ad.socialContext);
    NSLog(@"ad.rating: %@",ad.rating);
    NSLog(@"ad.clickURL: %@",ad.clickURL);
    
    /*
    
    self.nativeAdTitle.text = ad.assetHeadline;
    self.nativeAdDescription.text = ad.assetDescription;
    
    self.nativeAdMain.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:ad.main.url]];
    self.nativeAdIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:ad.icon.url]];
    
    NSLog(@"ad.main.width: %@",ad.main.width);
    NSLog(@"ad.main.height: %@",ad.main.height);
    
    NSLog(@"ad.icon.width: %@",ad.icon.width);
    NSLog(@"ad.icon.height: %@",ad.icon.height);
    
    
    for (MobFoxNativeTracker *tracker in ad.trackersArray) {
        
        NSLog(@"tracker url: %@", tracker.url);
        NSLog(@"tracker type: %@", tracker.type);
        
    }
    
    [self.nativeAd registerViewWithInteraction:self.fullNativeAdView withViewController:self];
     */
    
}

//called when ad response cannot be returned
- (void)MobFoxNativeAdDidFailToReceiveAdWithError:(NSError *)error {
    
}

@end
