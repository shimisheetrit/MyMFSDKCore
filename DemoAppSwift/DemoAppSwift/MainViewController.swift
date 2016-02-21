//
//  ViewController.swift
//  DemoAppSwift
//
//  Created by Shimi Sheetrit on 2/16/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

import UIKit
import MobFoxSDKCore
//import CollectionViewCell.h


let AdsTypeNum = 4

struct InventoryHash {
    
    static let MobFoxHashBanner = "fe96717d9875b9da4339ea5367eff1ec"
    static let MobFoxHashInter = "267d72ac3f77a3f447b32cf7ebf20673"
    static let MobFoxHashNative = "80187188f458cfde788d961b6882fd53"
    static let MobFoxHashVideo = "80187188f458cfde788d961b6882fd53"
}

/*
@objc protocol MobFoxAdDelegate {
    
    optional func MobFoxAdDidLoad(banner: MobFoxAd!)
    
    optional func MobFoxAdDidFailToReceiveAdWithError(error: NSError!)
    
    optional func MobFoxAdClosed()
    
    optional func MobFoxAdClicked()
    
    optional func MobFoxAdFinished()
    
    optional func MobFoxDelegateCustomEvents(events: [AnyObject]!)
    
}*/
/*
@objc protocol UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    
}

@objc protocol UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
}*/

class MainViewController: UIViewController, MobFoxAdDelegate, MobFoxInterstitialAdDelegate, MobFoxNativeAdDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nativeAdView: UIView!
    @IBOutlet weak var innerNativeAdView: UIView!
    @IBOutlet weak var nativeAdTitle: UILabel!
    @IBOutlet weak var nativeAdDescription: UILabel!
    @IBOutlet weak var nativeAdIcon: UIImageView!
    
    private var invh: String = ""
    private let cellID = "cellID"
    private var clickURL: NSURL!
    private var adVideoRect: CGRect!
    
    private var mobfoxAd: MobFoxAd!
    private var mobfoxInterAd: MobFoxInterstitialAd!
    private var mobfoxNativeAd: MobFoxNativeAd!
    private var mobfoxVideoAd: MobFoxAd!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.nativeAdView.hidden = true
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: MobFox Ad Delegate
     func MobFoxAdDidLoad(banner: MobFoxAd!) {
        
        print("MobFoxAdDidLoad")
        
    }
    
    func MobFoxAdDidFailToReceiveAdWithError(error: NSError!) {
        
        print("MobFoxAdDidFailToReceiveAdWithError")
        
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
        
        switch indexPath.item {
        case 0:
            self.hideAds(indexPath)
            self.removeVideoAd()
            self.mobfoxAd.invh = self.invh.characters.count > 0 ? self.invh : InventoryHash.MobFoxHashBanner
            self.mobfoxAd.loadAd()
            
        case 1:
            self.hideAds(indexPath)
            self.removeVideoAd()
            self.mobfoxInterAd.ad.invh = self.invh.characters.count > 0  ? self.invh : InventoryHash.MobFoxHashInter
            self.mobfoxInterAd.loadAd()

        case 2:
            self.hideAds(indexPath)
            self.removeVideoAd()
            self.mobfoxNativeAd.invh = self.invh.characters.count > 0  ? self.invh : InventoryHash.MobFoxHashNative
            self.mobfoxNativeAd.loadAd()

        case 3:
            self.hideAds(indexPath)
            self.removeVideoAd()
            self.initVideoAd()
            self.mobfoxVideoAd.invh = self.invh.characters.count > 0  ? self.invh : InventoryHash.MobFoxHashVideo
            self.mobfoxVideoAd.loadAd()

            
        default:
             break
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("collectionView:didDeselectItemAtIndexPath")
        
    }
    
    //MARK: UICollection View Data Source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print("collectionView:cellForItemAtIndexPath")

        
        //var cell: CollectionViewCell
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
    
    //MARK: Internal Functions
    func adTitle(indexPath: NSIndexPath) ->String {
        
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
    
    func adImage(indexPath: NSIndexPath) ->UIImage {
        
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
    
    func hideAds(indexPath: NSIndexPath) {
        
        switch indexPath.item {
            
        case 0:
            self.mobfoxAd.hidden = false
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = true
            self.mobfoxVideoAd.hidden = true
            
        case 1:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = false
            self.nativeAdView.hidden = true
            self.mobfoxVideoAd.hidden = true
            
        case 2:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = false
            self.mobfoxVideoAd.hidden = true
            
        case 3:
            self.mobfoxAd.hidden = true
            self.mobfoxInterAd.ad.hidden = true
            self.nativeAdView.hidden = true
            self.mobfoxVideoAd.hidden = false
            
        default:
            break
            
        }
        
    }
        
    func initVideoAd() {
        
        if (self.mobfoxVideoAd == nil) {
            
            self.mobfoxVideoAd = MobFoxAd(InventoryHash.MobFoxHashVideo, withFrame: self.adVideoRect)
            self.mobfoxVideoAd.delegate = self
            self.mobfoxVideoAd.type = "video"
            self.view.addSubview(self.mobfoxVideoAd)
        }
    }
        
    func removeVideoAd () {
        
        self.mobfoxVideoAd!.stopPlayback()
        //self.mobfoxVideoAd = nil
    }
        
        
    

}

