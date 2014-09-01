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

@end
