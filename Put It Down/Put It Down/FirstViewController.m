//
//  FirstViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 12/8/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
@import CoreLocation;
#import <iAd/iAd.h>


@interface FirstViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *driver;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView1;
@property NSTimer *t;

// instantiates the location grabbed
@property (strong, nonatomic) CLLocation *location;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createBannerView];
    // initialize locationManager
    locationManager = [[CLLocationManager alloc]init];
    // delegate locationManager to self
    locationManager.delegate = self;
    // set the accuracy, can be lowered later to reduce battery usage
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // New for iOS 9. This is to get location updates while app is running in the background!
    if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        [locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    [locationManager stopUpdatingLocation];
    
    }
// creates the view for the ad banner
- (void)createBannerView {
    
    Class cls = NSClassFromString(@"ADBannerView");
    if (cls) {
        ADBannerView *adView = [[cls alloc] initWithFrame:CGRectZero];
        
        
        // Set the current size based on device orientation
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
        adView.delegate = self;
        
        adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleRightMargin;
        
        // Set initial frame to be offscreen
        CGRect bannerFrame =adView.frame;
        bannerFrame.origin.y = self.view.frame.size.height;
        adView.frame = bannerFrame;
        
        self.bannerView1 = adView;
        [self.view addSubview:adView];
        
    }
}

//this is the working method; note the method name
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"banner failed to receive ad with error:%@", error);
}


// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations: (NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    
    _location = [locations lastObject];
    
    // store the phone's speed as Miles Per Hour
    _mph = ((self.location.speed) * 2.23694);
    _speed.text =  [NSString stringWithFormat:@"%.1f mph", _mph];
    }
// sends the alerts to the phone when speed is over 10 mph after 5 second delay.
- (void) sendAlerts:(NSTimer*)t {
   
    if (!_driver.isOn) {
        [t invalidate];
    }
    
    if (_mph >= 10){
        
    if ([UIAlertController class])
    {
      // if app is in foreground, send alerts (iOS version checking)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Put it down" message:@"Your screen's contents are not worth your life." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Put it down" message:@"Your screen's contents are not worth your life." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        // wait 5 seconds before displaying another alert.
    
        
    }
    
    // If app is in the background, send local notifications
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = @"Your screen's contents are not worth your life.";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    }

}

- (IBAction)driverSwitched:(UISwitch *)sender {
    if(_driver.isOn){
        [locationManager startUpdatingLocation];
        // speed check. if over 10 mph and phone unlocked (checked by brightness) then, send alerts for the user to put it down or lock the phone. Note the TimeInterval. Sends alerts every 5 seconds.
        
        [NSTimer scheduledTimerWithTimeInterval:5.0
                                         target:self
                                       selector:@selector(sendAlerts:)
                                       userInfo:nil
                                        repeats:YES];
        

    } else {
        [locationManager stopUpdatingLocation];
        _speed.text = [NSString stringWithFormat:@"Off"];
        _mph = 0;
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error

{
    NSLog(@"didFinishDeferredUpdatesWithError");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
