//
//  FirstViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 12/8/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>

CLLocationManager *locationManager;



@interface FirstViewController : UIViewController<ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *speed;

@property double mph;


@end

