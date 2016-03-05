//
//  HomeViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "HomeViewController.h"
#import "NewDriveViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize managedObjectContext;

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
    [self.bannerView1 loadRequest:[GADRequest request]];
    
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
    if ([nextController isKindOfClass:[NewDriveViewController class]]) {
        ((NewDriveViewController *) nextController).managedObjectContext = self.managedObjectContext;
    }
}

@end
