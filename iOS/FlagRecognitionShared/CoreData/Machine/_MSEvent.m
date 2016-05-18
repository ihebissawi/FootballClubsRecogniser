// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSEvent.m instead.

#import "_MSEvent.h"

const struct MSEventAttributes MSEventAttributes = {
	.authorName = @"authorName",
	.eventDescription = @"eventDescription",
	.eventType = @"eventType",
	.iD = @"iD",
	.matchID = @"matchID",
	.playerID = @"playerID",
	.score = @"score",
	.teamID = @"teamID",
	.time_minute = @"time_minute",
};

const struct MSEventRelationships MSEventRelationships = {
	.match = @"match",
	.player = @"player",
	.team = @"team",
};

@implementation MSEventID
@end

@implementation _MSEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MSEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MSEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MSEvent" inManagedObjectContext:moc_];
}

- (MSEventID*)objectID {
	return (MSEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"eventTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"eventType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic authorName;

@dynamic eventDescription;

@dynamic eventType;

- (int16_t)eventTypeValue {
	NSNumber *result = [self eventType];
	return [result shortValue];
}

- (void)setEventTypeValue:(int16_t)value_ {
	[self setEventType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveEventTypeValue {
	NSNumber *result = [self primitiveEventType];
	return [result shortValue];
}

- (void)setPrimitiveEventTypeValue:(int16_t)value_ {
	[self setPrimitiveEventType:[NSNumber numberWithShort:value_]];
}

@dynamic iD;

@dynamic matchID;

@dynamic playerID;

@dynamic score;

@dynamic teamID;

@dynamic time_minute;

@dynamic match;

@dynamic player;

@dynamic team;

@end

