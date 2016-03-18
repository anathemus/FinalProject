//
//  HomeViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "HomeViewController.h"
#import "NewDriveViewController.h"
#import "BadgesTableViewController.h"
#import "BadgeController.h"
#import "PastDrivesViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *driveArray;

@end

@implementation HomeViewController

@synthesize managedObjectContext;


- (void)viewWillAppear:(BOOL)animated
{
    // Gets CoreData every time you go to the home screen
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Drive" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.driveArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createAdBanner];
}

- (void)createAdBanner
{
    
    // Creates Google ADMOB banner
    
    self.bannerView1.adUnitID = @"ca-app-pub-7531252031513293/2655042967";
    self.bannerView1.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    
    [self.bannerView1 loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[NewDriveViewController class]])
    {
        ((NewDriveViewController *) nextController).managedObjectContext = self.managedObjectContext;
    }
    else if ([nextController isKindOfClass:[BadgesTableViewController class]])
    {
        ((BadgesTableViewController *) nextController).earnStatusArray = [[BadgeController defaultController] earnStatusesForDrives:self.driveArray];
    }
    else if ([nextController isKindOfClass:[PastDrivesViewController class]])
    {
        ((PastDrivesViewController *) nextController).driveArray = self.driveArray;
    }
}
@end
