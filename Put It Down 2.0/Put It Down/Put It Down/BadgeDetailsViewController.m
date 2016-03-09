//
//  BadgeDetailsViewController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/8/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "BadgeDetailsViewController.h"
#import "BadgeEarnStatus.h"
#import "Badge.h"
#import "MathController.h"
#import "Drive.h"
#import "BadgeController.h"

@interface BadgeDetailsViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *earnedLabel;
@property (nonatomic, weak) IBOutlet UILabel *silverLabel;
@property (nonatomic, weak) IBOutlet UILabel *goldLabel;
@property (nonatomic, weak) IBOutlet UILabel *bestLabel;
@property (nonatomic, weak) IBOutlet UIImageView *silverImageView;
@property (nonatomic, weak) IBOutlet UIImageView *goldImageView;

@end

@implementation BadgeDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/8);
    
    self.nameLabel.text = self.earnStatus.badge.name;
    self.distanceLabel.text = [MathController stringifyDistance:self.earnStatus.badge.distance];
    self.badgeImageView.image = [UIImage imageNamed:self.earnStatus.badge.imageName];
    self.earnedLabel.text = [NSString stringWithFormat:@"Reached on %@" , [formatter stringFromDate:self.earnStatus.earnDrive.timestamp]];
    
    if (self.earnStatus.silverDrive) {
        self.silverImageView.transform = transform;
        self.silverImageView.hidden = NO;
        self.silverLabel.text = [NSString stringWithFormat:@"Earned on %@" , [formatter stringFromDate:self.earnStatus.silverDrive.timestamp]];
        
    } else {
        self.silverImageView.hidden = YES;
        self.silverLabel.text = [NSString stringWithFormat:@"Pace < %@ for silver!", [MathController stringifyAvgPaceFromDist:(self.earnStatus.earnDrive.distance.floatValue * silverMultiplier) overTime:self.earnStatus.earnDrive.duration.intValue]];
    }
    
    if (self.earnStatus.goldDrive) {
        self.goldImageView.transform = transform;
        self.goldImageView.hidden = NO;
        self.goldLabel.text = [NSString stringWithFormat:@"Earned on %@" , [formatter stringFromDate:self.earnStatus.goldDrive.timestamp]];
        
    } else {
        self.goldImageView.hidden = YES;
        self.goldLabel.text = [NSString stringWithFormat:@"Pace < %@ for gold!", [MathController stringifyAvgPaceFromDist:(self.earnStatus.earnDrive.distance.floatValue * goldMultiplier) overTime:self.earnStatus.earnDrive.duration.intValue]];
    }
    
    self.bestLabel.text = [NSString stringWithFormat:@"Best: %@, %@", [MathController stringifyAvgPaceFromDist:self.earnStatus.bestDrive.distance.floatValue overTime:self.earnStatus.bestDrive.duration.intValue], [formatter stringFromDate:self.earnStatus.bestDrive.timestamp]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:self.earnStatus.badge.name
                              message:self.earnStatus.badge.information
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
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
