// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VenueCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct VenueCategoryAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} VenueCategoryAttributes;

extern const struct VenueCategoryRelationships {
	__unsafe_unretained NSString *venues;
} VenueCategoryRelationships;

extern const struct VenueCategoryFetchedProperties {
} VenueCategoryFetchedProperties;

@class Venue;




@interface VenueCategoryID : NSManagedObjectID {}
@end

@interface _VenueCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VenueCategoryID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *venues;

- (NSMutableSet*)venuesSet;





@end

@interface _VenueCategory (CoreDataGeneratedAccessors)

- (void)addVenues:(NSSet*)value_;
- (void)removeVenues:(NSSet*)value_;
- (void)addVenuesObject:(Venue*)value_;
- (void)removeVenuesObject:(Venue*)value_;

@end

@interface _VenueCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveVenues;
- (void)setPrimitiveVenues:(NSMutableSet*)value;


@end
