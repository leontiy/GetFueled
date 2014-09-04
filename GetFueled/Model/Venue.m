#import "Venue.h"


@interface Venue ()

// Private interface goes here.

@end


@implementation Venue

- (CLLocationCoordinate2D)location {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    return location;
}

- (void)setLocation:(CLLocationCoordinate2D)location {
    self.latitude = @(location.latitude);
    self.longitude = @(location.longitude);
}

#pragma mark Data parsing helpers

- (NSArray *)photoUrlSuffixes {
    return @[self.photoUrlSuffix];
}

- (NSArray *)photoUrlPrefixes {
    return @[self.photoUrlPrefix];
}

- (void)setPhotoUrlPrefixes:(NSArray *)photoUrlPrefixes {
    if ([photoUrlPrefixes count] > 0) {
        self.photoUrlPrefix = photoUrlPrefixes[0];
    }
}

- (void)setPhotoUrlSuffixes:(NSArray *)photoUrlSuffixes {
    if ([photoUrlSuffixes count] > 0) {
        self.photoUrlSuffix = photoUrlSuffixes[0];
    }
}

@end
