#import "_Venue.h"

@import CoreLocation;

@interface Venue : _Venue {}

@property (nonatomic) CLLocationCoordinate2D location;

@property (nonatomic, strong) NSArray *photoUrlPrefixes;
@property (nonatomic, strong) NSArray *photoUrlSuffixes;

@end
