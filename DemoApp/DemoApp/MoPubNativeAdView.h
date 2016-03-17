//
//  MoPubNativeAdView.h
//  DemoApp
//
//  Created by Shimi Sheetrit on 3/14/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPub.h"

@interface MoPubNativeAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *mainTextLabel;
@property (strong, nonatomic) UILabel *callToActionLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *privacyInformationIconImageView;

@end
