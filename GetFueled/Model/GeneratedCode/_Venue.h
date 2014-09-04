// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.h instead.

#import <CoreData/CoreData.h>


extern const struct VenueAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *blacklisted;
	__unsafe_unretained NSString *customRating;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *menuUrl;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *openHorus;
	__unsafe_unretained NSString *openNow;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *photoUrlPrefix;
	__unsafe_unretained NSString *photoUrlSuffix;
	__unsafe_unretained NSString *priceTier;
	__unsafe_unretained NSString *rating;
	__unsafe_unretained NSString *websiteUrl;
} VenueAttributes;

extern const struct VenueRelationships {
	__unsafe_unretained NSString *categories;
	__unsafe_unretained NSString *checkins;
	__unsafe_unretained NSString *customReview;
	__unsafe_unretained NSString *recommendedItem;
} VenueRelationships;

extern const struct VenueFetchedProperties {
} VenueFetchedProperties;

@class VenueCategory;
@class NSManagedObject;
@class CustomReview;
@class RecommendedItem;









@class NSObject;








@interface VenueID : NSManagedObjectID {}
@end

@interface _Venue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (VenueID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* blacklisted;



@property BOOL blacklistedValue;
- (BOOL)blacklistedValue;
- (void)setBlacklistedValue:(BOOL)value_;

//- (BOOL)validateBlacklisted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* customRating;



@property int16_t customRatingValue;
- (int16_t)customRatingValue;
- (void)setCustomRatingValue:(int16_t)value_;

//- (BOOL)validateCustomRating:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* menuUrl;



//- (BOOL)validateMenuUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id openHorus;



//- (BOOL)validateOpenHorus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* openNow;



//- (BOOL)validateOpenNow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phone;



//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* photoUrlPrefix;



//- (BOOL)validatePhotoUrlPrefix:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* photoUrlSuffix;



//- (BOOL)validatePhotoUrlSuffix:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* priceTier;



@property int16_t priceTierValue;
- (int16_t)priceTierValue;
- (void)setPriceTierValue:(int16_t)value_;

//- (BOOL)validatePriceTier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rating;



@property float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* websiteUrl;



//- (BOOL)validateWebsiteUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *categories;

- (NSMutableSet*)categoriesSet;




@property (nonatomic, strong) NSSet *checkins;

- (NSMutableSet*)checkinsSet;




@property (nonatomic, strong) CustomReview *customReview;

//- (BOOL)validateCustomReview:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) RecommendedItem *recommendedItem;

//- (BOOL)validateRecommendedItem:(id*)value_ error:(NSError**)error_;





@end

@interface _Venue (CoreDataGeneratedAccessors)

- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(VenueCategory*)value_;
- (void)removeCategoriesObject:(VenueCategory*)value_;

- (void)addCheckins:(NSSet*)value_;
- (void)removeCheckins:(NSSet*)value_;
- (void)addCheckinsObject:(NSManagedObject*)value_;
- (void)removeCheckinsObject:(NSManagedObject*)value_;

@end

@interface _Venue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSNumber*)primitiveBlacklisted;
- (void)setPrimitiveBlacklisted:(NSNumber*)value;

- (BOOL)primitiveBlacklistedValue;
- (void)setPrimitiveBlacklistedValue:(BOOL)value_;




- (NSNumber*)primitiveCustomRating;
- (void)setPrimitiveCustomRating:(NSNumber*)value;

- (int16_t)primitiveCustomRatingValue;
- (void)setPrimitiveCustomRatingValue:(int16_t)value_;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveMenuUrl;
- (void)setPrimitiveMenuUrl:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (id)primitiveOpenHorus;
- (void)setPrimitiveOpenHorus:(id)value;




- (NSString*)primitiveOpenNow;
- (void)setPrimitiveOpenNow:(NSString*)value;




- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;




- (NSString*)primitivePhotoUrlPrefix;
- (void)setPrimitivePhotoUrlPrefix:(NSString*)value;




- (NSString*)primitivePhotoUrlSuffix;
- (void)setPrimitivePhotoUrlSuffix:(NSString*)value;




- (NSNumber*)primitivePriceTier;
- (void)setPrimitivePriceTier:(NSNumber*)value;

- (int16_t)primitivePriceTierValue;
- (void)setPrimitivePriceTierValue:(int16_t)value_;




- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;




- (NSString*)primitiveWebsiteUrl;
- (void)setPrimitiveWebsiteUrl:(NSString*)value;





- (NSMutableSet*)primitiveCategories;
- (void)setPrimitiveCategories:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCheckins;
- (void)setPrimitiveCheckins:(NSMutableSet*)value;



- (CustomReview*)primitiveCustomReview;
- (void)setPrimitiveCustomReview:(CustomReview*)value;



- (RecommendedItem*)primitiveRecommendedItem;
- (void)setPrimitiveRecommendedItem:(RecommendedItem*)value;


@end
