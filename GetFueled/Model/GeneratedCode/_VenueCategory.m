// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VenueCategory.m instead.

#import "_VenueCategory.h"

const struct VenueCategoryAttributes VenueCategoryAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct VenueCategoryRelationships VenueCategoryRelationships = {
	.venues = @"venues",
};

const struct VenueCategoryFetchedProperties VenueCategoryFetchedProperties = {
};

@implementation VenueCategoryID
@end

@implementation _VenueCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"VenueCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"VenueCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"VenueCategory" inManagedObjectContext:moc_];
}

- (VenueCategoryID*)objectID {
	return (VenueCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic venues;

	
- (NSMutableSet*)venuesSet {
	[self willAccessValueForKey:@"venues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"venues"];
  
	[self didAccessValueForKey:@"venues"];
	return result;
}
	






@end
