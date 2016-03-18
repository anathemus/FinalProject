//
//  BadgeController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/4/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>



extern float const silverMultiplier;
extern float const goldMultiplier;

@interface BadgeController : NSObject

+ (BadgeController *)defaultController;

- (NSArray *)earnStatusesForDrives:(NSArray *)drivesArray;


@end
