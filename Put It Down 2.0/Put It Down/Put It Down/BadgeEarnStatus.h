//
//  BadgeEarnStatus.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/5/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;
@class Drive;

@interface BadgeEarnStatus : NSObject

@property (strong, nonatomic) Badge *badge;
@property (strong, nonatomic) Drive *earnDrive;
@property (strong, nonatomic) Drive *silverDrive;
@property (strong, nonatomic) Drive *goldDrive;
@property (strong, nonatomic) Drive *bestDrive;

@end
