//
//  PastDrivesViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/8/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "Drive.h"
#import "Location.h"
#import "Pins.h"
#import <UIKit/UIKit.h>

@class Drive;

@interface PastDrivesViewController : UITableViewController

@property(nonatomic, strong) IBOutlet UITableView *TableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSError * __autoreleasing *error;

@property (strong, nonatomic) Drive *drive;
@property (strong, nonatomic) NSArray *driveArray;


@end