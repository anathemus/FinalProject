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
#import <GoogleMobileAds/GoogleMobileAds.h>

// Important: Conversion of meters to miles. Location outputs in meters.

#define METERS_PER_MILE 1609.344

@interface FirstViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *driver;


@property NSTimer *t;

// instantiates the location grabbed
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITextField *customText;

@end

@implementation FirstViewController

// CoreData access
@synthesize fetchedResultsController, managedObjectContext;

NSString *customNotification = @"Your screen's contents are not worth your life.";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    _mapView.delegate = self;
    // Create the ad banner
    [self createAdBanner];
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
- (void)createAdBanner
{
    // Creates Google ADMOB banner
    
    self.bannerView1.adUnitID = @"ca-app-pub-7531252031513293/2655042967";
    self.bannerView1.rootViewController = self;
    [self.bannerView1 loadRequest:[GADRequest request]];
    
}

// Zooms into where the user's location is on the map.
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
    [_mapView setRegion:mapRegion animated: YES];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations: (NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    
    _location = [locations lastObject];
    
    // store the phone's speed as Miles Per Hour, correct for 0 MPH
    if (((self.location.speed)*2.23694) <= 0 || !_location){
        _mph = 0;
    }
    
    else {
        _mph = ((self.location.speed) * 2.23694);
    }
    
    
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Put it down" message:customNotification preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Put it down" message:customNotification delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        // wait 5 seconds before displaying another alert.
    
        
    }
    
    // If app is in the background, send local notifications, canceling/deleting the last one sent before sending another one to ensure notifications screen is tidy.
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = customNotification;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }

}
- (IBAction)textEntered:(UITextField *)sender {
    customNotification = _customText.text;
}
- (IBAction)textEdited:(id)sender
{
    customNotification = _customText.text;
}

- (IBAction)driverSwitched:(UISwitch *)sender
{
    if(_driver.isOn)
    {
        
        [locationManager startUpdatingLocation];
        
        // After a delay to update the location, put down the start pin.
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(getStart) userInfo:nil repeats:NO];
        
        // speed check. if over 10 mph and phone unlocked (checked by brightness) then, send alerts for the user to put it down or lock the phone. Note the TimeInterval. Sends alerts every 5 seconds.
        [NSTimer scheduledTimerWithTimeInterval:7.0
                                         target:self
                                       selector:@selector(sendAlerts:)
                                       userInfo:nil
                                        repeats:YES];
    }
    else
    {
        // Grab last place in route. Must be before stopUpdatingLocation.
        _endPoint = self.location.coordinate;
        [self annotateEnd];
        [locationManager stopUpdatingLocation];
        _speed.text = [NSString stringWithFormat:@"Off"];
        _mph = 0;
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error

{
    NSLog(@"didFinishDeferredUpdatesWithError");
    
}

- (void)getStart
{
    // Grab initial location
    _startPoint = self.location.coordinate;
    // calls annotateStart function
    [self annotateStart];
}

- (void)annotateStart
{
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    startAnnotation.coordinate = _startPoint;
    startAnnotation.title = @"Start";
    startAnnotation.subtitle = @"You started your route here.";
    [self.mapView addAnnotation:startAnnotation];
}

- (void)annotateEnd
{
    MKPointAnnotation *endAnnotation = [[MKPointAnnotation alloc] init];
    endAnnotation.coordinate = _endPoint;
    endAnnotation.title = @"Finish";
    endAnnotation.subtitle = @"Your route ended here.";
    [self.mapView addAnnotation:endAnnotation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
