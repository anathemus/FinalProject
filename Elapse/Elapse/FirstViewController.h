//
//  FirstViewController.h
//  Elapse
//
//  Created by Benjamin A Burgess on 12/7/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

