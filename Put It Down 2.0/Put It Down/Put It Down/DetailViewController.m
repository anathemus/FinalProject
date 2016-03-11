//
//  DetailViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "MulticolorPolylineSegment.h"
#import "HomeViewController.h"
#import "Badge.h"
#include "NewDriveViewController.h"

@interface DetailViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDrive:(Drive *)drive
{
    if (_drive != drive) {
        _drive = drive;
        [self configureView];
    }
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    self.distanceLabel.text = [MathController stringifyDistance:self.drive.distance.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.drive.timestamp];
    
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.drive.duration.intValue usingLongFormat:YES]];
    
    self.pickupLabel.text = [NSString stringWithFormat:@"Pickups: %@",  self.drive.pickups];
    [self loadMap];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.drive.location.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.drive.location) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
    
    return region;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MulticolorPolylineSegment class]]) {
        MulticolorPolylineSegment *polyLine = (MulticolorPolylineSegment *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

/*
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blackColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}
*/

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[self.drive.location.count];
    
    for (int i = 0; i < self.drive.location.count; i++) {
        Location *location = [self.drive.location objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.drive.location.count];
}

- (void)loadMap
{
    if (self.drive.location.count > 0) {
        
        self.mapView.hidden = NO;
        
        // set the map bounds
        [self.mapView setRegion:[self mapRegion]];
        
        // make the line(s!) on the map
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.drive.location.array];
        [self.mapView addOverlays:colorSegmentArray];
        
        // add the pins back to the map
        for (int i = 0; i < self.drive.pins.count; i++)
        {
            Pins *pins = [self.drive.pins objectAtIndex:i];
            MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
            pin.coordinate = CLLocationCoordinate2DMake(pins.latitude.doubleValue, pins.longitude.doubleValue);
            pin.title = pins.title;
            pin.subtitle = pins.subtitle;
            [self.mapView addAnnotation:pin];
        }
        
    }
    else
    {
        
        // no locations were found!
        self.mapView.hidden = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
