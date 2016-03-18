//
//  DetailViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/3/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "MathController.h"
#import "Drive.h"
#import "Location.h"
#import "Pins.h"
#import <UIKit/UIKit.h>

@class Drive;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) Drive *drive;


@end

