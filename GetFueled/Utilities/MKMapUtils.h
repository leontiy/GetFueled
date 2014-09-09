/*
 *  MKMapUtils.h
 *  TravelersCoffee
 *
 *  Created by Leontiy Deriglazov on 20.05.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#pragma mark Map Kit Utils

static const MKCoordinateRegion kNullRegion;

MKCoordinateRegion regionContatingAnnotations(NSArray *annotations, CLLocationDegrees delta);
MKCoordinateRegion regionContatingAnnotationsAndLocation(NSArray *annotations, CLLocationCoordinate2D location, CLLocationDegrees delta);
BOOL MKCoordinateRegionIsNull(MKCoordinateRegion region);

#pragma mark Core Location Utils

CLLocationDistance distanceBetweenCoordinates(CLLocationCoordinate2D location0, CLLocationCoordinate2D location1);
CLLocationCoordinate2D minCoordinate(MKCoordinateRegion region);
CLLocationCoordinate2D maxCoordinate(MKCoordinateRegion region);