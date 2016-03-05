//
//  Badge.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/4/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Badge : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *information;
@property float distance;

@end
