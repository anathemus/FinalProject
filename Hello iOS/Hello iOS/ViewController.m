//
//  ViewController.m
//  Hello iOS
//
//  Created by Benjamin A Burgess on 12/7/15.
//  Copyright © 2015 Benjamin A Burgess. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
- (IBAction)nameEntered:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nameEntered:(id)sender {
    [_userName setHidden:YES];
    _myLabel.text = [NSString stringWithFormat:@"Welcome, %@\n\n to the first app created\n\n by Benjamin A Burgess!", _userName.text];
}
@end
