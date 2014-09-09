#import "Venue.h"


@interface Venue ()

// Private interface goes here.

@end


@implementation Venue

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    return location;
}

- (void)setCoordinate:(CLLocationCoordinate2D)location {
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

- (NSString *)thumbnailUrl {
    static NSString *const kThumbnailFormatSpec = @"640x326";
    NSString *photoUrlString = [NSString stringWithFormat:@"%@%@%@", self.photoUrlPrefix, kThumbnailFormatSpec, self.photoUrlSuffix];
    return photoUrlString;
}

- (NSString *)backgroundImageUrl {
    static NSString *const kBgFormatSpec = @"240x240";
    NSString *photoUrlString = [NSString stringWithFormat:@"%@%@%@", self.photoUrlPrefix, kBgFormatSpec, self.photoUrlSuffix];
    return photoUrlString;
}


@end
