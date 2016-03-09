//
//  BadgeController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/4/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"
#import "BadgeEarnStatus.h"
#import "Drive.h"

float const silverMultiplier = 1.05; // 5% speed increase
float const goldMultiplier = 1.10; // 10% speed increase

@interface BadgeController ()

@property (strong, nonatomic) NSArray *badges;

@end

@implementation BadgeController

+ (BadgeController *)defaultController
{
    static BadgeController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[BadgeController alloc] init];
        controller.badges = [self badgeArray];
    });
    
    return controller;
}

+ (NSArray *)badgeArray
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"txt"];
    NSString *jsonContent = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
    NSData *data = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *badgeDicts = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *badgeObjects = [NSMutableArray array];
    
    for (NSDictionary *badgeDict in badgeDicts) {
        [badgeObjects addObject:[self badgeForDictionary:badgeDict]];
    }
    
    return badgeObjects;
}

+ (Badge *)badgeForDictionary:(NSDictionary *)dictionary
{
    Badge *badge = [Badge new];
    badge.name = [dictionary objectForKey:@"name"];
    badge.information = [dictionary objectForKey:@"information"];
    badge.imageName = [dictionary objectForKey:@"imageName"];
    badge.distance = [[dictionary objectForKey:@"distance"] floatValue];
    return badge;
}

- (NSArray *)earnStatusesForDrives:(NSArray *)drives {
    NSMutableArray *earnStatuses = [NSMutableArray array];
    
    for (Badge *badge in self.badges) {
        
        BadgeEarnStatus *earnStatus = [BadgeEarnStatus new];
        earnStatus.badge = badge;
        
        for (Drive *drive in drives) {
            
            if (drive.distance.floatValue > badge.distance) {
                
                // this is when the badge was first earned
                if (!earnStatus.earnDrive) {
                    earnStatus.earnDrive = drive;
                }
                
                double earnDriveSpeed = earnStatus.earnDrive.distance.doubleValue / earnStatus.earnDrive.duration.doubleValue;
                double driveSpeed = drive.distance.doubleValue / drive.duration.doubleValue;
                
                // does it deserve silver?
                if (!earnStatus.silverDrive
                    && driveSpeed > earnDriveSpeed * silverMultiplier) {
                    
                    earnStatus.silverDrive = drive;
                }
                
                // does it deserve gold?
                if (!earnStatus.goldDrive
                    && driveSpeed > earnDriveSpeed * goldMultiplier) {
                    
                    earnStatus.goldDrive = drive;
                }
                
                // is it the best for this distance?
                if (!earnStatus.bestDrive) {
                    earnStatus.bestDrive = drive;
                    
                } else {
                    double bestDriveSpeed = earnStatus.bestDrive.distance.doubleValue / earnStatus.bestDrive.duration.doubleValue;
                    
                    if (driveSpeed > bestDriveSpeed) {
                        earnStatus.bestDrive = drive;
                    }
                }
            }
        }
        
        [earnStatuses addObject:earnStatus];
    }
    
    return earnStatuses;
}

@end

