//
//  SecondViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 12/8/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "SecondViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView2;



@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _about.text = @"Put It Down is designed to run in the\n background. The phone should not be\n used while driving. Failure to follow traffic\n laws and good safety practices may result\n in collisions, vehicle/property damage,\n personal injury and/or death. The\n developer of this app discourages any\n phone use while driving and holds no\n resposibility for the user's vehicular actions.\n\n For the app to properly work, you must\n allow the app to access your location while\n in use, always, and allow notifications.";
    [self createBannerView];
}

// creates the view for the ad banner
- (void)createBannerView {
    
    // Creates Google ADMOB banner
    
    self.bannerView2.adUnitID = @"ca-app-pub-7531252031513293/2655042967";
    self.bannerView2.rootViewController = self;
    [self.bannerView2 loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
