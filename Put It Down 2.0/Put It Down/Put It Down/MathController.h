//
//  MathController.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/4/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathController : NSObject

+(NSString *)stringifyDistance:(float)meters;
+(NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
+(NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

// To make the line drawn on the map different colors for different speeds
+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
