// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSMatch.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSMatchAttributes {
	__unsafe_unretained NSString *dateString;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *leagueID;
	__unsafe_unretained NSString *leagueName;
	__unsafe_unretained NSString *score;
	__unsafe_unretained NSString *seasonID;
	__unsafe_unretained NSString *seasonName;
	__unsafe_unretained NSString *teamAwayID;
	__unsafe_unretained NSString *teamAwayName;
	__unsafe_unretained NSString *teamHomeID;
	__unsafe_unretained NSString *teamHomeName;
	__unsafe_unretained NSString *timestamp;
    __unsafe_unretained NSString *matchStatus;
} MSMatchAttributes;

extern const struct MSMatchRelationships {
	__unsafe_unretained NSString *matchEvents;
	__unsafe_unretained NSString *teamAway;
	__unsafe_unretained NSString *teamHome;
} MSMatchRelationships;

extern const struct MSMatchUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSMatchUserInfo;

@class MSEvent;
@class MSTeam;
@class MSTeam;

@interface MSMatchID : MSPerishableEntityID {}
@end

@interface _MSMatch : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSMatchID* objectID;

@property (nonatomic, strong) NSString* dateString;

//- (BOOL)validateDateString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueID;

//- (BOOL)validateLeagueID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* leagueName;

//- (BOOL)validateLeagueName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* score;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonID;

//- (BOOL)validateSeasonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* seasonName;

//- (BOOL)validateSeasonName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamAwayID;

//- (BOOL)validateTeamAwayID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamAwayName;

//- (BOOL)validateTeamAwayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamHomeID;

//- (BOOL)validateTeamHomeID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamHomeName;

//- (BOOL)validateTeamHomeName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* timestamp;

//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* matchStatus;

//- (BOOL)validateMatchStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *matchEvents;

- (NSMutableSet*)matchEventsSet;

@property (nonatomic, strong) MSTeam *teamAway;

//- (BOOL)validateTeamAway:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MSTeam *teamHome;

//- (BOOL)validateTeamHome:(id*)value_ error:(NSError**)error_;

@end

@interface _MSMatch (MatchEventsCoreDataGeneratedAccessors)
- (void)addMatchEvents:(NSSet*)value_;
- (void)removeMatchEvents:(NSSet*)value_;
- (void)addMatchEventsObject:(MSEvent*)value_;
- (void)removeMatchEventsObject:(MSEvent*)value_;

@end

@interface _MSMatch (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDateString;
- (void)setPrimitiveDateString:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveLeagueID;
- (void)setPrimitiveLeagueID:(NSString*)value;

- (NSString*)primitiveLeagueName;
- (void)setPrimitiveLeagueName:(NSString*)value;

- (NSString*)primitiveScore;
- (void)setPrimitiveScore:(NSString*)value;

- (NSString*)primitiveSeasonID;
- (void)setPrimitiveSeasonID:(NSString*)value;

- (NSString*)primitiveSeasonName;
- (void)setPrimitiveSeasonName:(NSString*)value;

- (NSString*)primitiveTeamAwayID;
- (void)setPrimitiveTeamAwayID:(NSString*)value;

- (NSString*)primitiveTeamAwayName;
- (void)setPrimitiveTeamAwayName:(NSString*)value;

- (NSString*)primitiveTeamHomeID;
- (void)setPrimitiveTeamHomeID:(NSString*)value;

- (NSString*)primitiveTeamHomeName;
- (void)setPrimitiveTeamHomeName:(NSString*)value;

- (NSString*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSString*)value;

- (NSString*)primitiveMatchStatus;
- (void)setPrimitiveMatchStatus:(NSString*)value;

- (NSMutableSet*)primitiveMatchEvents;
- (void)setPrimitiveMatchEvents:(NSMutableSet*)value;

- (MSTeam*)primitiveTeamAway;
- (void)setPrimitiveTeamAway:(MSTeam*)value;

- (MSTeam*)primitiveTeamHome;
- (void)setPrimitiveTeamHome:(MSTeam*)value;

@end
