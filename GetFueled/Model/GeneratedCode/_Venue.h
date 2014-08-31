// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.h instead.

#import <CoreData/CoreData.h>


extern const struct VenueAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
} VenueAttributes;

extern const struct VenueRelationships {
} VenueRelationships;

extern const struct VenueFetchedProperties {
} VenueFetchedProperties;





@interface VenueID : NSManagedObjectID {}
@end

@interface _Venue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VenueID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _Venue (CoreDataGeneratedAccessors)

@end

@interface _Venue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
