//
//  SecondViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 12/8/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *about;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _about.text = @"Put It Down is designed to run in the\n background. The phone should not be\n used while driving. Failure to follow traffic\n laws and good safety practices may result\n in collisions, vehicle/property damage,\n personal injury and/or death. The\n developer of this app discourages any\n phone use while driving and holds no\n resposibility for the user's vehicular actions.\n\n For the app to properly work, you must\n allow the app to access your location while\n in use, always, and allow notifications.";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
