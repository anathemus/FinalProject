//
//  SecondViewController.m
//  Elapse
//
//  Created by Benjamin A Burgess on 12/7/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bio;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _bio.text = @"Benjamin A Burgess\n has programmed since the age of six.\n He began writing code in BASIC, recreating\n shareware games to his own liking and\n advantage. In high school, he wrote a paint program\n in pacsal in computer science class.\n most recently, Ben has returned to College in pursuit of a\n Bachelors in Information Technology with\n a concentration in Software Development.\n Ben has also completed a certificate from\n Harvard College in their Computer Schience 50\n program under edx.\n\n Languages Ben has familiarity and comfort with:\n C, C#, PHP, Javascript, HTML, CSS, \n and most recently Objecive C on Xcode 7.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
