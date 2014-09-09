// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CustomReview.m instead.

#import "_CustomReview.h"

const struct CustomReviewAttributes CustomReviewAttributes = {
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
	

	return keyPaths;
}




@dynamic text;






@dynamic venue;

	






@end
