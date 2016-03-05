//
//  HomeViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@class GADBannerView;

@interface HomeViewController : UIViewController<NSFetchedResultsControllerDelegate>

// CoreData
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

// Google Ad Banner
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView1;

@end
