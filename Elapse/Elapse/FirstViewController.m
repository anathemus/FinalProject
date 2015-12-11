//
//  FirstViewController.m
//  Elapse
//
//  Created by Benjamin A Burgess on 12/7/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "notify.h"

@interface FirstViewController ()


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // get global variable
    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    delegate.timePassed = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimePasses) userInfo:nil repeats:YES];;
}


-(void) TimePasses{
    AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    delegate.timePassed = delegate.timePassed + 1;
    NSLog(@"TimePasses %d", delegate.timePassed);
    int minuts = delegate.timePassed / 60;
    int seconds = delegate.timePassed - (minuts * 60);
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%.2d", minuts, seconds];
    _time.text = timerOutput;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
