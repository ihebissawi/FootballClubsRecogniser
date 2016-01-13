// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPlayer.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSPlayerAttributes {
	__unsafe_unretained NSString *age;
	__unsafe_unretained NSString *birth;
	__unsafe_unretained NSString *cityID;
	__unsafe_unretained NSString *cityName;
	__unsafe_unretained NSString *countryID;
	__unsafe_unretained NSString *countryName;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *foot;
	__unsafe_unretained NSString *height;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *nameShort;
	__unsafe_unretained NSString *photoLink;
	__unsafe_unretained NSString *playsForCountryID;
	__unsafe_unretained NSString *playsForTeamID;
	__unsafe_unretained NSString *playsForTeamName;
	__unsafe_unretained NSString *positionID;
	__unsafe_unretained NSString *positionName;
	__unsafe_unretained NSString *positionNameShort;
	__unsafe_unretained NSString *shirtNumber;
	__unsafe_unretained NSString *urlLink;
	__unsafe_unretained NSString *weight;
} MSPlayerAttributes;

extern const struct MSPlayerRelationships {
	__unsafe_unretained NSString *playerEvents;
	__unsafe_unretained NSString *seasonsResults;
	__unsafe_unretained NSString *team;
} MSPlayerRelationships;

extern const struct MSPlayerUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSPlayerUserInfo;

@class MSEvent;
@class MSPlayerProgress;
@class MSTeam;

@interface MSPlayerID : MSPerishableEntityID {}
@end

@interface _MSPlayer : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSPlayerID* objectID;

@property (nonatomic, strong) NSString* age;

//- (BOOL)validateAge:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* birth;

//- (BOOL)validateBirth:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cityID;

//- (BOOL)validateCityID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cityName;

//- (BOOL)validateCityName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* countryID;

//- (BOOL)validateCountryID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* countryName;

//- (BOOL)validateCountryName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* foot;

//- (BOOL)validateFoot:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* height;

//- (BOOL)validateHeight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nameShort;

//- (BOOL)validateNameShort:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* photoLink;

//- (BOOL)validatePhotoLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playsForCountryID;

//- (BOOL)validatePlaysForCountryID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playsForTeamID;

//- (BOOL)validatePlaysForTeamID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playsForTeamName;

//- (BOOL)validatePlaysForTeamName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* positionID;

//- (BOOL)validatePositionID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* positionName;

//- (BOOL)validatePositionName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* positionNameShort;

//- (BOOL)validatePositionNameShort:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shirtNumber;

//- (BOOL)validateShirtNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* urlLink;

//- (BOOL)validateUrlLink:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* weight;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *playerEvents;

- (NSMutableSet*)playerEventsSet;

@property (nonatomic, strong) NSSet *seasonsResults;

- (NSMutableSet*)seasonsResultsSet;

@property (nonatomic, strong) MSTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@end

@interface _MSPlayer (PlayerEventsCoreDataGeneratedAccessors)
- (void)addPlayerEvents:(NSSet*)value_;
- (void)removePlayerEvents:(NSSet*)value_;
- (void)addPlayerEventsObject:(MSEvent*)value_;
- (void)removePlayerEventsObject:(MSEvent*)value_;

@end

@interface _MSPlayer (SeasonsResultsCoreDataGeneratedAccessors)
- (void)addSeasonsResults:(NSSet*)value_;
- (void)removeSeasonsResults:(NSSet*)value_;
- (void)addSeasonsResultsObject:(MSPlayerProgress*)value_;
- (void)removeSeasonsResultsObject:(MSPlayerProgress*)value_;

@end

@interface _MSPlayer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAge;
- (void)setPrimitiveAge:(NSString*)value;

- (NSString*)primitiveBirth;
- (void)setPrimitiveBirth:(NSString*)value;

- (NSString*)primitiveCityID;
- (void)setPrimitiveCityID:(NSString*)value;

- (NSString*)primitiveCityName;
- (void)setPrimitiveCityName:(NSString*)value;

- (NSString*)primitiveCountryID;
- (void)setPrimitiveCountryID:(NSString*)value;

- (NSString*)primitiveCountryName;
- (void)setPrimitiveCountryName:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveFoot;
- (void)setPrimitiveFoot:(NSString*)value;

- (NSString*)primitiveHeight;
- (void)setPrimitiveHeight:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitiveNameShort;
- (void)setPrimitiveNameShort:(NSString*)value;

- (NSString*)primitivePhotoLink;
- (void)setPrimitivePhotoLink:(NSString*)value;

- (NSString*)primitivePlaysForCountryID;
- (void)setPrimitivePlaysForCountryID:(NSString*)value;

- (NSString*)primitivePlaysForTeamID;
- (void)setPrimitivePlaysForTeamID:(NSString*)value;

- (NSString*)primitivePlaysForTeamName;
- (void)setPrimitivePlaysForTeamName:(NSString*)value;

- (NSString*)primitivePositionID;
- (void)setPrimitivePositionID:(NSString*)value;

- (NSString*)primitivePositionName;
- (void)setPrimitivePositionName:(NSString*)value;

- (NSString*)primitivePositionNameShort;
- (void)setPrimitivePositionNameShort:(NSString*)value;

- (NSString*)primitiveShirtNumber;
- (void)setPrimitiveShirtNumber:(NSString*)value;

- (NSString*)primitiveUrlLink;
- (void)setPrimitiveUrlLink:(NSString*)value;

- (NSString*)primitiveWeight;
- (void)setPrimitiveWeight:(NSString*)value;

- (NSMutableSet*)primitivePlayerEvents;
- (void)setPrimitivePlayerEvents:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSeasonsResults;
- (void)setPrimitiveSeasonsResults:(NSMutableSet*)value;

- (MSTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(MSTeam*)value;

@end
