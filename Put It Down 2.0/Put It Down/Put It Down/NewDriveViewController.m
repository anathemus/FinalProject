//
//  NewDriveViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "NewDriveViewController.h"
#import "DetailViewController.h"
#import "Drive.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MathController.h"
#import "Location.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Pins.h"


static NSString * const detailSegueName = @"DriveDetails";

@interface NewDriveViewController () <UIActionSheetDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) Drive *drive;

// Features of the app, labels, buttons, and the map!
@property (nonatomic, weak) IBOutlet MKMapView *driveMapView;
@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *screenTouch;

// Variables to hold the timer, location, and number of times picked up
@property int seconds;
@property int pickups;
@property float distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIAcceleration *driveAcceleration;

// instantiates the location grabbed
@property (strong, nonatomic) CLLocation *location;
- (IBAction)Pickup:(id)sender;

// sets up array of pins so they can be stored and saved.
@property (strong, nonatomic) NSMutableArray *annotations;


@end

@implementation NewDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startButton.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.timeLabel.text = @"Time:";
    self.timeLabel.hidden = YES;
    self.distLabel.hidden = YES;
    self.pickupLabel.hidden = YES;
    self.stopButton.hidden = YES;
    self.driveMapView.hidden = YES;
    [self createAdBanner];
    
    // initialize locationManager
    _locationManager = [[CLLocationManager alloc]init];
    // delegate locationManager to self
    _locationManager.delegate = self;
    // This is also repeated when the timer starts, just in case.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Always is preferred over only when in use.
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [_locationManager requestAlwaysAuthorization];
    }
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    // New for iOS 9. This is to get location updates while app is running in the background!
    if ([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    // delegates the mapView so it can zoom in
    _driveMapView.delegate = self;
    
    // initiate annotations array
    _annotations = [NSMutableArray array];
    
    // initiate accelerometer
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    
}

- (void)createAdBanner
{
    
    // Creates Google ADMOB banner
    
    self.bannerView2.adUnitID = @"ca-app-pub-7531252031513293/2655042967";
    self.bannerView2.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"b03ba6b32502bab9a8cabc47c31701ba" ];
    
    [self.bannerView2 loadRequest:request];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:
(UIAcceleration *)acceleration
{
    self.driveAcceleration = acceleration;
    // NSLog([NSString stringWithFormat:@"%f",acceleration.x]);
    // NSLog([NSString stringWithFormat:@"%f",acceleration.y]);
    // NSLog([NSString stringWithFormat:@"%f",acceleration.z]);
}

-(IBAction)startPressed:(id)sender
{
    // hide the start UI
    self.startButton.hidden = YES;
    self.promptLabel.hidden = YES;
    
    // show the running UI
    self.timeLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.pickupLabel.hidden = NO;
    self.stopButton.hidden = NO;
    self.driveMapView.hidden = NO;
    
    // start the eachSecond NSTimer, grab location updates
    self.seconds = 0;
    self.distance = 0;
    self.pickups = 0;
    self.locations = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                selector:@selector(eachSecond) userInfo:nil repeats:YES];
    [self startLocationUpdates];
    
    // After a delay to update the location, put down the start pin.
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(getStart) userInfo:nil repeats:NO];

}

- (IBAction)stopPressed:(id)sender
{
    _endPoint = self.location.coordinate;
    [self annotateEnd];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save", @"Discard", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The drive's over so no need to update the loaction anymore.
    [self.locationManager stopUpdatingLocation];
    [self.timer invalidate];
    // save
    if (buttonIndex == 0) {
        [self saveDrive];
        [self performSegueWithIdentifier:detailSegueName sender:nil];
        
        // discard
    } else if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setDrive:self.drive];
}

// called every second to update labels
- (void)eachSecond
{
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"Distance: %@", [MathController stringifyDistance:self.distance]];
    self.pickupLabel.text = [NSString stringWithFormat:@"Times picked up: %i",  _pickups];
    
    /* every second, check the accelerometer to see if phone indicates that it's at an angle that could be considered picked up.
     */
    if (self.driveAcceleration.x < -0.25 || self.driveAcceleration.x > 0.25 || self.driveAcceleration.y < -0.25 || self.driveAcceleration.y > 0.25)
    {
        [self countPickup];
    }
}

- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    _location = [locations lastObject];
    
    /*for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
                self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
            }
            
            [self.locations addObject:newLocation];
        }
    }*/
    
    for (CLLocation *newLocation in locations) {
        
        NSDate *eventDate = newLocation.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
                self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [self.driveMapView setRegion:region animated:YES];
                
                [self.driveMapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:newLocation];
        }
    }
}

// Zooms into where the user's location is on the map.
/*- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = _driveMapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.05, 0.05);
    [_driveMapView setRegion:mapRegion animated: YES];
}
*/

- (void)getStart
{
    // Grab initial location
    _startPoint = self.location.coordinate;
    // calls annotateStart function
    [self annotateStart];
}

// Pins start point on map.
- (void)annotateStart
{
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    startAnnotation.coordinate = _startPoint;
    startAnnotation.title = @"Start";
    startAnnotation.subtitle = @"You started your route here.";
    [self.driveMapView addAnnotation:startAnnotation];
    
    // save the start point in the annotations array
    [self.annotations addObject:startAnnotation];
}

// Pins end point on the map
- (void)annotateEnd
{
    MKPointAnnotation *endAnnotation = [[MKPointAnnotation alloc] init];
    endAnnotation.coordinate = _endPoint;
    endAnnotation.title = @"Finish";
    endAnnotation.subtitle = @"Your route ended here.";
    [self.driveMapView addAnnotation:endAnnotation];
    [self.annotations addObject:endAnnotation];
}

- (IBAction)Pickup:(id)sender
{
    [self countPickup];
    
}

- (void)playNoTouchieSound
{
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/Alarm.wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    //also vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


// Save the drive to CoreData
- (void)saveDrive
{
    // adds the drive data to CoreData
    Drive *newDrive = [NSEntityDescription insertNewObjectForEntityForName:@"Drive"
                                                inManagedObjectContext:self.managedObjectContext];
    
    newDrive.distance = [NSNumber numberWithFloat:self.distance];
    newDrive.duration = [NSNumber numberWithInt:self.seconds];
    newDrive.timestamp = [NSDate date];
    newDrive.pickups = [NSNumber numberWithInt:self.pickups];
    
    // adds all the locations (breadcrumb/trail) to CoreData
    NSMutableArray *locationArray = [NSMutableArray array];
    for (CLLocation *location in self.locations) {
        Location *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                                 inManagedObjectContext:self.managedObjectContext];
        
        locationObject.timestamp = location.timestamp;
        locationObject.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationObject.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [locationArray addObject:locationObject];
    }
    
    // adds the pins to CoreData
    NSMutableArray *pinArray = [NSMutableArray array];
    for (MKPointAnnotation *annotation in self.annotations)
    {
    Pins *newPin = [NSEntityDescription insertNewObjectForEntityForName:@"Pins" inManagedObjectContext:self.managedObjectContext];
        
        newPin.latitude = [NSNumber numberWithDouble:annotation.coordinate.latitude];
        newPin.longitude = [NSNumber numberWithDouble:annotation.coordinate.longitude];
        newPin.title = annotation.title;
        newPin.subtitle = annotation.subtitle;
        [pinArray addObject:newPin];
    
    }
    
    newDrive.pins = [NSOrderedSet orderedSetWithArray:pinArray];
    newDrive.location = [NSOrderedSet orderedSetWithArray:locationArray];
    self.drive = newDrive;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// Draws a blue line to show where the user has been
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    return nil;
}

// save the pins for the other screens
- (NSArray *)annotationsForDrive:(Drive *)drive
{
    
    
    return _annotations;
}

+ (NewDriveViewController *)newDriveViewController
{
    static NewDriveViewController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[NewDriveViewController alloc] init];
    });
    
    return controller;
}

- (void)countPickup
{
    self.pickups++;
    MKPointAnnotation *pickupAnnotation = [[MKPointAnnotation alloc] init];
    pickupAnnotation.coordinate = self.location.coordinate;
    pickupAnnotation.title = @"Picked up";
    pickupAnnotation.subtitle = @"You touched your phone here.";
    [self.driveMapView addAnnotation:pickupAnnotation];
    [self playNoTouchieSound];
    [self.annotations addObject:pickupAnnotation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
