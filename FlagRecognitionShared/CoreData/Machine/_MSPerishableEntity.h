// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MSPerishableEntity.h instead.

#import <CoreData/CoreData.h>

extern const struct MSPerishableEntityAttributes {
	__unsafe_unretained NSString *imageFilePath;
	__unsafe_unretained NSString *lastUpdateDate;
} MSPerishableEntityAttributes;

@interface MSPerishableEntityID : NSManagedObjectID {}
@end

@interface _MSPerishableEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MSPerishableEntityID* objectID;

@property (nonatomic, strong) NSString* imageFilePath;

//- (BOOL)validateImageFilePath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastUpdateDate;

//- (BOOL)validateLastUpdateDate:(id*)value_ error:(NSError**)error_;

@end

@interface _MSPerishableEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveImageFilePath;
- (void)setPrimitiveImageFilePath:(NSString*)value;

- (NSDate*)primitiveLastUpdateDate;
- (void)setPrimitiveLastUpdateDate:(NSDate*)value;

@end
