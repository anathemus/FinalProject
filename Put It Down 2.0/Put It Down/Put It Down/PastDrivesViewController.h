//
//  PastDrivesViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/8/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastDrivesViewController : UITableViewController

@property(nonatomic, strong) IBOutlet UITableView *TableView;

@property (strong, nonatomic) NSArray *driveArray;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end