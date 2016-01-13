// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSEvent.m instead.

#import "_MSEvent.h"

const struct MSEventAttributes MSEventAttributes = {
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
	if ([key isEqualToString:@"time_minuteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time_minute"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

- (int16_t)time_minuteValue {
	NSNumber *result = [self time_minute];
	return [result shortValue];
}

- (void)setTime_minuteValue:(int16_t)value_ {
	[self setTime_minute:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTime_minuteValue {
	NSNumber *result = [self primitiveTime_minute];
	return [result shortValue];
}

- (void)setPrimitiveTime_minuteValue:(int16_t)value_ {
	[self setPrimitiveTime_minute:[NSNumber numberWithShort:value_]];
}

@dynamic match;

@dynamic player;

@dynamic team;

@end

