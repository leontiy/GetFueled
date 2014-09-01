// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecommendedItem.h instead.

#import <CoreData/CoreData.h>


extern const struct RecommendedItemAttributes {
	__unsafe_unretained NSString *index;
} RecommendedItemAttributes;

extern const struct RecommendedItemRelationships {
	__unsafe_unretained NSString *venue;
} RecommendedItemRelationships;

extern const struct RecommendedItemFetchedProperties {
} RecommendedItemFetchedProperties;

@class Venue;



@interface RecommendedItemID : NSManagedObjectID {}
@end

@interface _RecommendedItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecommendedItemID*)objectID;





@property (nonatomic, strong) NSNumber* index;



@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





@end

@interface _RecommendedItem (CoreDataGeneratedAccessors)

@end

@interface _RecommendedItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;





- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
