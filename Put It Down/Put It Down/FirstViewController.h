//
//  FirstViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 12/8/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

CLLocationManager *locationManager;

@class GADBannerView;

@interface FirstViewController : UIViewController<NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (weak, nonatomic) IBOutlet UILabel *speed;

@property double mph;

@property(nonatomic, weak) IBOutlet GADBannerView *bannerView1;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) CLLocationCoordinate2D startPoint;
@property (nonatomic) CLLocationCoordinate2D endPoint;
;

// CoreData access
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


@end

