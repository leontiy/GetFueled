// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Venue.m instead.

#import "_Venue.h"

const struct VenueAttributes VenueAttributes = {
	.address = @"address",
	.blacklisted = @"blacklisted",
	.id = @"id",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.menuUrl = @"menuUrl",
	.name = @"name",
	.openHorus = @"openHorus",
	.openNow = @"openNow",
	.phone = @"phone",
	.photoUrlPrefix = @"photoUrlPrefix",
	.photoUrlSuffix = @"photoUrlSuffix",
	.priceTier = @"priceTier",
	.rating = @"rating",
	.websiteUrl = @"websiteUrl",
};

const struct VenueRelationships VenueRelationships = {
	.categories = @"categories",
	.checkins = @"checkins",
	.customReview = @"customReview",
	.recommendedItem = @"recommendedItem",
};

const struct VenueFetchedProperties VenueFetchedProperties = {
};

@implementation VenueID
@end

@implementation _Venue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Venue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:moc_];
}

- (VenueID*)objectID {
	return (VenueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"blacklistedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"blacklisted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"priceTierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"priceTier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic address;






@dynamic blacklisted;



- (BOOL)blacklistedValue {
	NSNumber *result = [self blacklisted];
	return [result boolValue];
}

- (void)setBlacklistedValue:(BOOL)value_ {
	[self setBlacklisted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveBlacklistedValue {
	NSNumber *result = [self primitiveBlacklisted];
	return [result boolValue];
}

- (void)setPrimitiveBlacklistedValue:(BOOL)value_ {
	[self setPrimitiveBlacklisted:[NSNumber numberWithBool:value_]];
}





@dynamic id;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic menuUrl;






@dynamic name;






@dynamic openHorus;






@dynamic openNow;






@dynamic phone;






@dynamic photoUrlPrefix;






@dynamic photoUrlSuffix;






@dynamic priceTier;



- (int16_t)priceTierValue {
	NSNumber *result = [self priceTier];
	return [result shortValue];
}

- (void)setPriceTierValue:(int16_t)value_ {
	[self setPriceTier:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePriceTierValue {
	NSNumber *result = [self primitivePriceTier];
	return [result shortValue];
}

- (void)setPrimitivePriceTierValue:(int16_t)value_ {
	[self setPrimitivePriceTier:[NSNumber numberWithShort:value_]];
}





@dynamic rating;



- (float)ratingValue {
	NSNumber *result = [self rating];
	return [result floatValue];
}

- (void)setRatingValue:(float)value_ {
	[self setRating:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRatingValue {
	NSNumber *result = [self primitiveRating];
	return [result floatValue];
}

- (void)setPrimitiveRatingValue:(float)value_ {
	[self setPrimitiveRating:[NSNumber numberWithFloat:value_]];
}





@dynamic websiteUrl;






@dynamic categories;

	
- (NSMutableSet*)categoriesSet {
	[self willAccessValueForKey:@"categories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"categories"];
  
	[self didAccessValueForKey:@"categories"];
	return result;
}
	

@dynamic checkins;

	
- (NSMutableSet*)checkinsSet {
	[self willAccessValueForKey:@"checkins"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"checkins"];
  
	[self didAccessValueForKey:@"checkins"];
	return result;
}
	

@dynamic customReview;

	

@dynamic recommendedItem;

	






@end
