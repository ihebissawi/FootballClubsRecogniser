// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSEvent.h instead.

#import <CoreData/CoreData.h>

extern const struct MSEventAttributes {
	__unsafe_unretained NSString *eventType;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *matchID;
	__unsafe_unretained NSString *playerID;
	__unsafe_unretained NSString *score;
	__unsafe_unretained NSString *teamID;
	__unsafe_unretained NSString *time_minute;
} MSEventAttributes;

extern const struct MSEventRelationships {
	__unsafe_unretained NSString *match;
	__unsafe_unretained NSString *player;
	__unsafe_unretained NSString *team;
} MSEventRelationships;

@class MSMatch;
@class MSPlayer;
@class MSTeam;

@interface MSEventID : NSManagedObjectID {}
@end

@interface _MSEvent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSEventID* objectID;

@property (nonatomic, strong) NSNumber* eventType;

@property (atomic) int16_t eventTypeValue;
- (int16_t)eventTypeValue;
- (void)setEventTypeValue:(int16_t)value_;

//- (BOOL)validateEventType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* matchID;

//- (BOOL)validateMatchID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playerID;

//- (BOOL)validatePlayerID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* score;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamID;

//- (BOOL)validateTeamID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* time_minute;

@property (atomic) int16_t time_minuteValue;
- (int16_t)time_minuteValue;
- (void)setTime_minuteValue:(int16_t)value_;

//- (BOOL)validateTime_minute:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSMatch *match;

//- (BOOL)validateMatch:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSPlayer *player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@end

@interface _MSEvent (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveEventType;
- (void)setPrimitiveEventType:(NSNumber*)value;

- (int16_t)primitiveEventTypeValue;
- (void)setPrimitiveEventTypeValue:(int16_t)value_;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveMatchID;
- (void)setPrimitiveMatchID:(NSString*)value;

- (NSString*)primitivePlayerID;
- (void)setPrimitivePlayerID:(NSString*)value;

- (NSString*)primitiveScore;
- (void)setPrimitiveScore:(NSString*)value;

- (NSString*)primitiveTeamID;
- (void)setPrimitiveTeamID:(NSString*)value;

- (NSNumber*)primitiveTime_minute;
- (void)setPrimitiveTime_minute:(NSNumber*)value;

- (int16_t)primitiveTime_minuteValue;
- (void)setPrimitiveTime_minuteValue:(int16_t)value_;

- (MSMatch*)primitiveMatch;
- (void)setPrimitiveMatch:(MSMatch*)value;

- (MSPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(MSPlayer*)value;

- (MSTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(MSTeam*)value;

@end
