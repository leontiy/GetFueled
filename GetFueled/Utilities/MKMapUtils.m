/*
 *  MKMapUtils.c
 *  TravelersCoffee
 *
 *  Created by Leontiy Deriglazov on 20.05.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "MKMapUtils.h"
#import <assert.h>

NSMutableArray *arrayOfKeyValuesFrom(NSArray *objects, NSString *key) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[objects count]];
    for (id obj in objects) {
        [result addObject:[obj valueForKey:key]];
    }
    return result;
}

MKCoordinateRegion regionContatingCoordinates(NSArray *coordinates, CLLocationDegrees delta) {
    assert(0 < [coordinates count]);
    CLLocationCoordinate2D coordinate0; [[coordinates objectAtIndex:0] getValue:&coordinate0];
    CLLocationCoordinate2D min = coordinate0, max = coordinate0;
    
    for (NSValue *value in coordinates) {
        CLLocationCoordinate2D coordinate; [value getValue:&coordinate];
        if (coordinate.latitude < min.latitude)
            min.latitude = coordinate.latitude;
        else if (coordinate.latitude > max.latitude)
            max.latitude = coordinate.latitude;

        if (coordinate.longitude < min.longitude)
            min.longitude = coordinate.longitude;
        else if (coordinate.longitude > max.longitude)
            max.longitude = coordinate.longitude;
    }
    MKCoordinateSpan span = MKCoordinateSpanMake((max.latitude-min.latitude)*1.1, (max.longitude - min.longitude)*1.1);
    if (0.0 == span.latitudeDelta)
        span.latitudeDelta = 0.005;
    if (0.0 == span.longitudeDelta)
        span.longitudeDelta = 0.005;
    CLLocationCoordinate2D center = {(min.latitude + max.latitude)/2, (min.longitude + max.longitude)/2};
    return MKCoordinateRegionMake(center, span);
}

MKCoordinateRegion regionContatingAnnotations(NSArray *annotations, CLLocationDegrees delta) {
    NSArray *coordinates = arrayOfKeyValuesFrom(annotations, @"coordinate");
    return regionContatingCoordinates(coordinates, delta);
}

MKCoordinateRegion regionContatingAnnotationsAndLocation(NSArray *annotations, CLLocationCoordinate2D location, CLLocationDegrees delta) {
	if (0.0 == location.latitude && 0.0 == location.longitude) {
		return regionContatingAnnotations(annotations, delta);
	}
	
    NSMutableArray *coordinates = arrayOfKeyValuesFrom(annotations, @"coordinate");
    [coordinates addObject:[NSValue valueWithBytes:&location objCType:@encode(CLLocationCoordinate2D)]];
    return regionContatingCoordinates(coordinates, delta);
}

CLLocationDistance distanceBetweenCoordinates(CLLocationCoordinate2D location0, CLLocationCoordinate2D location1) {
    CLLocation *l0 = [[CLLocation alloc] initWithLatitude:location0.latitude longitude:location0.longitude];
    CLLocation *l1 = [[CLLocation alloc] initWithLatitude:location1.latitude longitude:location1.longitude];
    CLLocationDistance distance = 0;
    distance = [l0 distanceFromLocation:l1];
    return distance;
}

CLLocationCoordinate2D minCoordinate(MKCoordinateRegion region) {
    const CLLocationCoordinate2D minPointOnMap = {region.center.latitude - region.span.latitudeDelta/2, region.center.longitude - region.span.longitudeDelta/2};
    return minPointOnMap;
}

CLLocationCoordinate2D maxCoordinate(MKCoordinateRegion region) {
    const CLLocationCoordinate2D maxPointOnMap = {region.center.latitude + region.span.latitudeDelta/2, region.center.longitude + region.span.longitudeDelta/2};
    return maxPointOnMap;
}

static const MKCoordinateRegion kNullRegion = {{}, {}};

BOOL MKCoordinateRegionIsNull(MKCoordinateRegion region) {
	return 0 == memcmp(&kNullRegion, &region, sizeof(MKCoordinateRegion));
}