//
//  Pins+CoreDataProperties.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/9/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Pins.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pins (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Drive *drive;

@end

NS_ASSUME_NONNULL_END
