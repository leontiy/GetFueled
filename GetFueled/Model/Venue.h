#import "_Venue.h"

@import CoreLocation;

@interface Venue : _Venue {}

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSArray *photoUrlPrefixes;
@property (nonatomic, strong) NSArray *photoUrlSuffixes;
@property (nonatomic, readonly) NSString *thumbnailUrl;
@property (nonatomic, readonly) NSString *backgroundImageUrl;

@end
