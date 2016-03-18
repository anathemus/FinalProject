//
//  Drive+CoreDataProperties.h
//  Put It Down
//
//  Created by Benjamin A Burgess on 3/9/16.
//  Copyright © 2016 Benjamin A Burgess. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Drive.h"

NS_ASSUME_NONNULL_BEGIN

@interface Drive (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSNumber *pickups;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSOrderedSet<Location *> *location;
@property (nullable, nonatomic, retain) NSOrderedSet<Pins *> *pins;

@end

@interface Drive (CoreDataGeneratedAccessors)

- (void)insertObject:(Location *)value inLocationAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationAtIndex:(NSUInteger)idx;
- (void)insertLocation:(NSArray<Location *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationAtIndex:(NSUInteger)idx withObject:(Location *)value;
- (void)replaceLocationAtIndexes:(NSIndexSet *)indexes withLocation:(NSArray<Location *> *)values;
- (void)addLocationObject:(Location *)value;
- (void)removeLocationObject:(Location *)value;
- (void)addLocation:(NSOrderedSet<Location *> *)values;
- (void)removeLocation:(NSOrderedSet<Location *> *)values;

- (void)insertObject:(Pins *)value inPinsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPinsAtIndex:(NSUInteger)idx;
- (void)insertPins:(NSArray<Pins *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePinsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPinsAtIndex:(NSUInteger)idx withObject:(Pins *)value;
- (void)replacePinsAtIndexes:(NSIndexSet *)indexes withPins:(NSArray<Pins *> *)values;
- (void)addPinsObject:(Pins *)value;
- (void)removePinsObject:(Pins *)value;
- (void)addPins:(NSOrderedSet<Pins *> *)values;
- (void)removePins:(NSOrderedSet<Pins *> *)values;

@end

NS_ASSUME_NONNULL_END
