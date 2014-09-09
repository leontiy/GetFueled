// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomReview.h instead.

#import <CoreData/CoreData.h>


extern const struct CustomReviewAttributes {
	__unsafe_unretained NSString *text;
} CustomReviewAttributes;

extern const struct CustomReviewRelationships {
	__unsafe_unretained NSString *venue;
} CustomReviewRelationships;

extern const struct CustomReviewFetchedProperties {
} CustomReviewFetchedProperties;

@class Venue;



@interface CustomReviewID : NSManagedObjectID {}
@end

@interface _CustomReview : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CustomReviewID*)objectID;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Venue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





@end

@interface _CustomReview (CoreDataGeneratedAccessors)

@end

@interface _CustomReview (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (Venue*)primitiveVenue;
- (void)setPrimitiveVenue:(Venue*)value;


@end
