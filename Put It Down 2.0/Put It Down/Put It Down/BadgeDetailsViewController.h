//
//  BadgeDetailsViewController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/8/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BadgeEarnStatus;

@interface BadgeDetailsViewController : UIViewController

@property (strong, nonatomic) BadgeEarnStatus *earnStatus;

@end