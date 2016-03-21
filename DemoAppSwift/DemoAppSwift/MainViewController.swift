//
//  ViewController.swift
//  DemoAppSwift
//
//  Created by Shimi Sheetrit on 2/16/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

import UIKit
import MobFoxSDKCore
import GoogleMobileAds


let AdsTypeNum = 4
let adRefresh = 10

struct InventoryHash {
    
    static let MobFoxHashBanner = "fe96717d9875b9da4339ea5367eff1ec"
    static let MobFoxHashInter = "267d72ac3f77a3f447b32cf7ebf20673"
    static let MobFoxHashNative = "80187188f458cfde788d961b6882fd53"
    static let MobFoxHashVideo = "651586294dac23e245f26789c4043aa9"
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MobFoxAdDelegate, MobFoxInterstitialAdDelegate, MobFoxNativeAdDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nativeAdView: UIView!
    @IBOutlet weak var innerNativeAdView: UIView!
    @IBOutlet weak var nativeAdTitle: UILabel!
    @IBOutlet weak var nativeAdDescription: UILabel!
    @IBOutlet weak var nativeAdIcon: UIImageView!
    
    internal var invh: String?
    private let cellID = "cellID"
    private var clickURL: NSURL?
    private var adVideoRect: CGRect!
    
    // MobFox.
    private var mobfoxAd: MobFoxAd!
    private var mobfoxInterAd: MobFoxInterstitialAd!
    private var mobfoxNativeAd: MobFoxNativeAd!
    private var mobfoxVideoAd: MobFoxAd!
    
    // AdMob.
    private var bannerView: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        self.nativeAdView.hidden = true
        
        let recognizer = UITapGestureRecognizer.init(target: self, action: "handleGesture:")
        self.innerNativeAdView.addGestureRecognizer(recognizer)
        
        // Oreintation dependent in iOS 8 and later.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let bannerWidth = CGFloat(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 728.0 : 320.0)
        let bannerHeight = CGFloat(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 90.0 : 50.0)
        let videoWidth = CGFloat(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 500.0 : 300.0)
        let videoHeight = CGFloat(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 450.0 : 250.0)

        /*** Banner ***/
        let rect = CGRect(origin: CGPoint(x: (screenWidth-bannerWidth)/2, y: screenHeight-bannerHeight), size: CGSize(width: bannerWidth, height: bannerHeight) )
        mobfoxAd = MobFoxAd(InventoryHash.MobFoxHashBanner, withFrame: rect)
        mobfoxAd.delegate = self
        mobfoxAd.refresh = adRefresh
        self.view.addSubview(mobfoxAd)
        
        /*** Interstitial ***/
        mobfoxInterAd = MobFoxInterstitialAd(InventoryHash.MobFoxHashInter, withRootViewController:self)
        mobfoxInterAd.delegate = self

        /*** Native ***/
        mobfoxNativeAd = MobFoxNativeAd(InventoryHash.MobFoxHashNative)
        mobfoxNativeAd.delegate = self
        
        /*** Video ***/
        let videoTopMargin = CGFloat(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad ? 200.0 : 80.0)
        self.adVideoRect = CGRectMake((screenWidth - videoWidth)/2, self.collectionView.frame.size.height + videoTopMargin, videoWidth, videoHeight)
        self.initVideoAd()
        
        /*** AdMob ***/
        bannerView = GADBannerView.init(adSize: kGADAdSizeBanner, origin: CGPointMake(0, 0))
        bannerView.adUnitID = "ca-app-pub-6224828323195096/5240875564​" // "ca-app-pub-3940256099942544/2934735716"
        bannerView.frame = CGRectMake(0, 0, 320, 50)
        bannerView.rootViewController = self
        let request = GADRequest()
        //request.testDevices = ["221e6c438e8184e0556942ea14bb214b"] // kGADSimulatorID
        bannerView.loadRequest(request)
        self.view.addSubview(bannerView)
        
     
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        print("viewWillDisappear")
        
        super.viewWillDisappear(animated)
        self.removeVideoAd()

    }
    
    //MARK: MobFox Ad Delegate
     func MobFoxAdDidLoad(banner: MobFoxAd!) {
        
        print("MobFoxAdDidLoad")
        
    }
    
    func MobFoxAdDidFailToReceiveAdWithError(error: NSError!) {
        
        print("MobFoxAdDidFailToReceiveAdWithError: ", error.description)
        
    }
    
    func MobFoxAdClosed() {
        
        print("MobFoxAdClosed")

    }
    
    func MobFoxAdClicked() {
        
        print("MobFoxAdClicked")

    }
    
    //MARK: MobFox Ad Interstitial Delegate
    func MobFoxInterstitialAdDidLoad(interstitial: MobFoxInterstitialAd!) {
        
        print("MobFoxInterstitialAdDidLoad")
        
        if(self.mobfoxInterAd.ready){
            self.mobfoxInterAd.show()
        }

    }
    
    func MobFoxInterstitialAdDidFailToReceiveAdWithError(error :NSError!) {
    
        print("MobFoxInterstitialAdDidFailToReceiveAdWithError: \(error.description)");
    
    }
    
    func MobFoxInterstitialAdClosed() {
    
    print("MobFoxInterstitialAdClosed")
    
    }
    
    func MobFoxInterstitialAdClicked() {
    
    print("MobFoxInterstitialAdClicked")
    
    }
    
    func MobFoxInterstitialAdFinished() {
    
    print("MobFoxInterstitialAdFinished")
    
    }
    
    //MARK: MobFox Ad Native Delegate
    func MobFoxNativeAdDidLoad(ad: MobFoxNativeAd!, withAdData adData: MobFoxNativeData!) {
        
        self.nativeAdIcon.image = UIImage(data: NSData(contentsOfURL: adData.icon.url)!)
        self.nativeAdTitle.text = adData.assetHeadline
        self.nativeAdDescription.text = adData.assetDescription
        self.clickURL = adData.clickURL.absoluteURL
                
    }
    
    func MobFoxNativeAdDidFailToReceiveAdWithError(error: NSError!) {
        
        print("MobFoxNativeAdDidFailToReceiveAdWithError")

    }
    
    //MARK: UICollection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("collectionView:didSelectItemAtIndexPath")
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell!.backgroundColor = UIColor.lightGrayColor()
        }
        
        switch indexPath.item {
        case 0:
            self.hideAds(indexPath)
            self.removeVideoAd()
            if self.invh != nil {self.mobfoxAd.invh = self.invh!.characters.count > 0 ? self.invh! : InventoryHash.MobFoxHashBanner}
            self.resumeAdRefresh()
            
        case 1:
            self.hideAds(indexPath)
            self.pauseAdRefresh()
            self.removeVideoAd()
            if self.invh != nil {self.mobfoxInterAd.ad.invh = self.invh!.characters.count > 0  ? self.invh! : InventoryHash.MobFoxHashInter}
            self.mobfoxInterAd.loadAd()

        case 2:
            self.hideAds(indexPath)
            self.pauseAdRefresh()
            self.removeVideoAd()
            if self.invh != nil {self.mobfoxNativeAd.invh = self.invh!.characters.count > 0  ? self.invh! : InventoryHash.MobFoxHashNative}
            self.mobfoxNativeAd.loadAd()

        case 3:
            self.hideAds(indexPath)
            self.pauseAdRefresh()
            self.removeVideoAd()
            self.initVideoAd()
            if self.invh != nil {self.mobfoxVideoAd.invh = self.invh!.characters.count > 0  ? self.invh! : InventoryHash.MobFoxHashVideo}
            self.mobfoxVideoAd.loadAd()

            
        default:
             break
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell != nil {
            cell?.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    //MARK: UICollection View Data Source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellID , forIndexPath: indexPath) as! CollectionViewCell
        
        cell.title.text = self.adTitle(indexPath)
        cell.image.image = self.adImage(indexPath)

        if cell.selected {
            cell.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor() // Default color
        }
        
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    //MARK: Private Functions
    private func adTitle(indexPath: NSIndexPath) ->String {
        
        switch indexPath.item {
        case 0:
            return "Banner"
        case 1:
            return "Interstitial"
        case 2:
            return "Native"
        case 3:
            return "Video"
            
        default:
            return ""
        }
        
    }
    
    private func adImage(indexPath: NSIndexPath) ->UIImage {
        
        switch indexPath.item {
        case 0:
            return UIImage(named:"test_banner.png")!
        case 1:
            return UIImage(named:"test_interstitial.png")!
        case 2:
            return UIImage(named:"test_native.png")!
        case 3:
            return UIImage(named:"test_video.png")!
            
        default:
            return UIImage()
        }
        
    }
    
    private func hideAds(indexPath: NSIndexPath) {
        
        switch indexPath.item {
            
        case 0:
            self.mobfoxAd.hidden = false
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = true
            if self.mobfoxVideoAd != nil {self.mobfoxVideoAd.hidden = true}
            
        case 1:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = false
            self.nativeAdView.hidden = true
            if self.mobfoxVideoAd != nil {self.mobfoxVideoAd.hidden = true}
            
        case 2:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = false
            if self.mobfoxVideoAd != nil {self.mobfoxVideoAd.hidden = true}
            
        case 3:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = true
            if self.mobfoxVideoAd != nil {self.mobfoxVideoAd.hidden = true}
            
        default:
            break
            
        }
        
    }
        
    private func initVideoAd() {
        
        if (self.mobfoxVideoAd == nil) {
            
            self.mobfoxVideoAd = MobFoxAd(InventoryHash.MobFoxHashVideo, withFrame: self.adVideoRect)
            self.mobfoxVideoAd.delegate = self
            self.mobfoxVideoAd.type = "video"
            self.view.addSubview(self.mobfoxVideoAd)
        }
    }
    
    private func removeVideoAd () {
        
        if self.mobfoxVideoAd != nil {
        
        self.mobfoxVideoAd.stopPlayback()
        self.mobfoxAd.removeFromSuperview()
        self.mobfoxVideoAd = nil
        
        }
        
    }
    
    private func pauseAdRefresh (){
        
        if(adRefresh > 0) {
            
            self.mobfoxAd.refresh = NSNumber.init(integer: 0)
            self.mobfoxAd.loadAd()
            self.mobfoxAd.removeFromSuperview()
        }
    }
    
    private func resumeAdRefresh () {
        
        if(adRefresh > 0) {
            
            self.view.addSubview(self.mobfoxAd)
            self.mobfoxAd.refresh = NSNumber.init(integer: adRefresh)
            self.mobfoxAd.loadAd()
            
        } else {
            
            self.mobfoxAd.refresh = NSNumber.init(integer: adRefresh)
            self.mobfoxAd.loadAd()
        }
    }
    
    private func handleGesture( gestureRecognizer: UIGestureRecognizer) {
        
        if (self.clickURL != nil) {
            UIApplication.sharedApplication().openURL(self.clickURL!)
        }
    }
    
}

