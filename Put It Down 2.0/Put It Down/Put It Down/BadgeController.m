//
//  BadgeController.m
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/4/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"

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

@end
