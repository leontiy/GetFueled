// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomReview.m instead.

#import "_CustomReview.h"

const struct CustomReviewAttributes CustomReviewAttributes = {
	.rating = @"rating",
	.text = @"text",
};

const struct CustomReviewRelationships CustomReviewRelationships = {
	.venue = @"venue",
};

const struct CustomReviewFetchedProperties CustomReviewFetchedProperties = {
};

@implementation CustomReviewID
@end

@implementation _CustomReview

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CustomReview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CustomReview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CustomReview" inManagedObjectContext:moc_];
}

- (CustomReviewID*)objectID {
	return (CustomReviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic rating;



- (int16_t)ratingValue {
	NSNumber *result = [self rating];
	return [result shortValue];
}

- (void)setRatingValue:(int16_t)value_ {
	[self setRating:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRatingValue {
	NSNumber *result = [self primitiveRating];
	return [result shortValue];
}

- (void)setPrimitiveRatingValue:(int16_t)value_ {
	[self setPrimitiveRating:[NSNumber numberWithShort:value_]];
}





@dynamic text;






@dynamic venue;

	






@end
