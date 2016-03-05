//
//  NewDriveViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class GADBannerView;

@interface NewDriveViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) CLLocationCoordinate2D startPoint;
@property (nonatomic) CLLocationCoordinate2D endPoint;
;


// Google Ad Banner
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView2;


@end
