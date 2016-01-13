// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSTeam.h instead.

#import <CoreData/CoreData.h>
#import "MSPerishableEntity.h"

extern const struct MSTeamAttributes {
	__unsafe_unretained NSString *cityID;
	__unsafe_unretained NSString *cityName;
	__unsafe_unretained NSString *coach;
	__unsafe_unretained NSString *currentLeagueID;
	__unsafe_unretained NSString *currentLeagueName;
	__unsafe_unretained NSString *currentSeasonID;
	__unsafe_unretained NSString *currentSeasonName;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *fax;
	__unsafe_unretained NSString *founded;
	__unsafe_unretained NSString *homeAddress;
	__unsafe_unretained NSString *homeCountryID;
	__unsafe_unretained NSString *homeCountryName;
	__unsafe_unretained NSString *iD;
	__unsafe_unretained NSString *logo;
	__unsafe_unretained NSString *matchesLastUpdateDate;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *playersLastUpdateDate;
	__unsafe_unretained NSString *playingCountryID;
	__unsafe_unretained NSString *playingCountryName;
	__unsafe_unretained NSString *shortName;
	__unsafe_unretained NSString *stadium;
	__unsafe_unretained NSString *synced;
	__unsafe_unretained NSString *teamColor;
	__unsafe_unretained NSString *url;
} MSTeamAttributes;

extern const struct MSTeamRelationships {
	__unsafe_unretained NSString *awayMatches;
	__unsafe_unretained NSString *homeMatches;
	__unsafe_unretained NSString *squad;
	__unsafe_unretained NSString *teamEvents;
} MSTeamRelationships;

extern const struct MSTeamUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MSTeamUserInfo;

@class MSMatch;
@class MSMatch;
@class MSPlayer;
@class MSEvent;

@interface MSTeamID : MSPerishableEntityID {}
@end

@interface _MSTeam : MSPerishableEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSTeamID* objectID;

@property (nonatomic, strong) NSString* cityID;

//- (BOOL)validateCityID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* cityName;

//- (BOOL)validateCityName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coach;

//- (BOOL)validateCoach:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentLeagueID;

//- (BOOL)validateCurrentLeagueID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentLeagueName;

//- (BOOL)validateCurrentLeagueName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentSeasonID;

//- (BOOL)validateCurrentSeasonID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* currentSeasonName;

//- (BOOL)validateCurrentSeasonName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* favorite;

@property (atomic) BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fax;

//- (BOOL)validateFax:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* founded;

//- (BOOL)validateFounded:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* homeAddress;

//- (BOOL)validateHomeAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* homeCountryID;

//- (BOOL)validateHomeCountryID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* homeCountryName;

//- (BOOL)validateHomeCountryName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iD;

//- (BOOL)validateID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* logo;

//- (BOOL)validateLogo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* matchesLastUpdateDate;

//- (BOOL)validateMatchesLastUpdateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phone;

//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* playersLastUpdateDate;

//- (BOOL)validatePlayersLastUpdateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playingCountryID;

//- (BOOL)validatePlayingCountryID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* playingCountryName;

//- (BOOL)validatePlayingCountryName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shortName;

//- (BOOL)validateShortName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* stadium;

//- (BOOL)validateStadium:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* synced;

@property (atomic) BOOL syncedValue;
- (BOOL)syncedValue;
- (void)setSyncedValue:(BOOL)value_;

//- (BOOL)validateSynced:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamColor;

//- (BOOL)validateTeamColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *awayMatches;

- (NSMutableSet*)awayMatchesSet;

@property (nonatomic, strong) NSSet *homeMatches;

- (NSMutableSet*)homeMatchesSet;

@property (nonatomic, strong) NSSet *squad;

- (NSMutableSet*)squadSet;

@property (nonatomic, strong) NSSet *teamEvents;

- (NSMutableSet*)teamEventsSet;

@end

@interface _MSTeam (AwayMatchesCoreDataGeneratedAccessors)
- (void)addAwayMatches:(NSSet*)value_;
- (void)removeAwayMatches:(NSSet*)value_;
- (void)addAwayMatchesObject:(MSMatch*)value_;
- (void)removeAwayMatchesObject:(MSMatch*)value_;

@end

@interface _MSTeam (HomeMatchesCoreDataGeneratedAccessors)
- (void)addHomeMatches:(NSSet*)value_;
- (void)removeHomeMatches:(NSSet*)value_;
- (void)addHomeMatchesObject:(MSMatch*)value_;
- (void)removeHomeMatchesObject:(MSMatch*)value_;

@end

@interface _MSTeam (SquadCoreDataGeneratedAccessors)
- (void)addSquad:(NSSet*)value_;
- (void)removeSquad:(NSSet*)value_;
- (void)addSquadObject:(MSPlayer*)value_;
- (void)removeSquadObject:(MSPlayer*)value_;

@end

@interface _MSTeam (TeamEventsCoreDataGeneratedAccessors)
- (void)addTeamEvents:(NSSet*)value_;
- (void)removeTeamEvents:(NSSet*)value_;
- (void)addTeamEventsObject:(MSEvent*)value_;
- (void)removeTeamEventsObject:(MSEvent*)value_;

@end

@interface _MSTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCityID;
- (void)setPrimitiveCityID:(NSString*)value;

- (NSString*)primitiveCityName;
- (void)setPrimitiveCityName:(NSString*)value;

- (NSString*)primitiveCoach;
- (void)setPrimitiveCoach:(NSString*)value;

- (NSString*)primitiveCurrentLeagueID;
- (void)setPrimitiveCurrentLeagueID:(NSString*)value;

- (NSString*)primitiveCurrentLeagueName;
- (void)setPrimitiveCurrentLeagueName:(NSString*)value;

- (NSString*)primitiveCurrentSeasonID;
- (void)setPrimitiveCurrentSeasonID:(NSString*)value;

- (NSString*)primitiveCurrentSeasonName;
- (void)setPrimitiveCurrentSeasonName:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveFavorite;
- (void)setPrimitiveFavorite:(NSNumber*)value;

- (BOOL)primitiveFavoriteValue;
- (void)setPrimitiveFavoriteValue:(BOOL)value_;

- (NSString*)primitiveFax;
- (void)setPrimitiveFax:(NSString*)value;

- (NSString*)primitiveFounded;
- (void)setPrimitiveFounded:(NSString*)value;

- (NSString*)primitiveHomeAddress;
- (void)setPrimitiveHomeAddress:(NSString*)value;

- (NSString*)primitiveHomeCountryID;
- (void)setPrimitiveHomeCountryID:(NSString*)value;

- (NSString*)primitiveHomeCountryName;
- (void)setPrimitiveHomeCountryName:(NSString*)value;

- (NSString*)primitiveID;
- (void)setPrimitiveID:(NSString*)value;

- (NSString*)primitiveLogo;
- (void)setPrimitiveLogo:(NSString*)value;

- (NSDate*)primitiveMatchesLastUpdateDate;
- (void)setPrimitiveMatchesLastUpdateDate:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;

- (NSDate*)primitivePlayersLastUpdateDate;
- (void)setPrimitivePlayersLastUpdateDate:(NSDate*)value;

- (NSString*)primitivePlayingCountryID;
- (void)setPrimitivePlayingCountryID:(NSString*)value;

- (NSString*)primitivePlayingCountryName;
- (void)setPrimitivePlayingCountryName:(NSString*)value;

- (NSString*)primitiveShortName;
- (void)setPrimitiveShortName:(NSString*)value;

- (NSString*)primitiveStadium;
- (void)setPrimitiveStadium:(NSString*)value;

- (NSNumber*)primitiveSynced;
- (void)setPrimitiveSynced:(NSNumber*)value;

- (BOOL)primitiveSyncedValue;
- (void)setPrimitiveSyncedValue:(BOOL)value_;

- (NSString*)primitiveTeamColor;
- (void)setPrimitiveTeamColor:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (NSMutableSet*)primitiveAwayMatches;
- (void)setPrimitiveAwayMatches:(NSMutableSet*)value;

- (NSMutableSet*)primitiveHomeMatches;
- (void)setPrimitiveHomeMatches:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSquad;
- (void)setPrimitiveSquad:(NSMutableSet*)value;

- (NSMutableSet*)primitiveTeamEvents;
- (void)setPrimitiveTeamEvents:(NSMutableSet*)value;

@end
