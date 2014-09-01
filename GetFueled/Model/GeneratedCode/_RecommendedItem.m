// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecommendedItem.m instead.

#import "_RecommendedItem.h"

const struct RecommendedItemAttributes RecommendedItemAttributes = {
	.index = @"index",
};

const struct RecommendedItemRelationships RecommendedItemRelationships = {
	.venue = @"venue",
};

const struct RecommendedItemFetchedProperties RecommendedItemFetchedProperties = {
};

@implementation RecommendedItemID
@end

@implementation _RecommendedItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecommendedItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecommendedItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecommendedItem" inManagedObjectContext:moc_];
}

- (RecommendedItemID*)objectID {
	return (RecommendedItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic index;



- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithInt:value_]];
}





@dynamic venue;

	






@end
