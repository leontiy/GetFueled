//
//  VenueViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenueViewController.h"
@import CoreLocation;
@import MapKit;
#import <AFNetworking/AFNetworking.h>
#import "Venue.h"
#import "VenueCategory.h"
#import "MKMapUtils.h"
#import "NSNumber+Foursquare.h"


@interface Venue (MKAnnotation) <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@end

@interface VenueViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *openNowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation VenueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.venue.name;
    
    self.mapView.delegate = self;
    [self.mapView addAnnotation:self.venue];
    CLLocationDegrees kDeltaForStreetsVisible = 0.001;
    [self.mapView setRegion:regionContatingAnnotations(@[ self.venue ], kDeltaForStreetsVisible)];
    self.mapView.showsBuildings = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    
    self.categoryLabel.hidden = [self.venue.categories count] == 0;
    VenueCategory *category = self.venue.categories.anyObject;
    self.categoryLabel.text = category.name;
    
    self.openNowLabel.hidden = [self.venue.openNow length] == 0;
    self.openNowLabel.text = self.venue.openNow;
    
    NSString *priceTier = [self.venue.priceTier gf_priceTierRerepresentationString];
    self.ratingsLabel.text = [NSString stringWithFormat:@"%@  ★ %@", priceTier, self.venue.rating];
    
    self.addressLabel.text = self.venue.address;
    
    NSURL *photoUrl = [NSURL URLWithString:self.venue.backgroundImageUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:photoUrl];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.backgroundImageView setImageWithURLRequest:request
                                    placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 [self updateBackgroundWithImage:image];
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 // ignore
                                             }];
}

- (IBAction)call:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.venue.phone]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openMenu:(id)sender {
    NSURL *url = [NSURL URLWithString:self.venue.menuUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openWebsite:(id)sender {
    NSURL *url = [NSURL URLWithString:self.venue.websiteUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)toggleSaved:(id)sender {
}

static NSString *const kAnnotationReuseId = @"FueledAnnotation";

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    return annotationView;
}

- (void)updateBackgroundWithImage:(UIImage *)image {
    UIImageOrientation sourceOrientation = [image imageOrientation];
    CGFloat sourceImageScale = [image scale];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef imgRef = [self newBlurredCGImageFromImage:image];
        UIImage *blurredImage = [UIImage imageWithCGImage:imgRef scale:sourceImageScale orientation:sourceOrientation];
        CFRelease(imgRef);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = blurredImage;
            self.backgroundImageView.alpha = 0;
            const NSTimeInterval kAnimationDuration = 0.5;
            if ([UIView respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
                [UIView animateWithDuration:kAnimationDuration
                                      delay:0
                     usingSpringWithDamping:0.9
                      initialSpringVelocity:1
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{ self.backgroundImageView.alpha = 1; }
                                 completion:nil];
            } else {
                [UIView animateWithDuration:kAnimationDuration
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{ self.backgroundImageView.alpha = 1; }
                                 completion:nil];

            }
        });
    });
}

- (CGImageRef)newBlurredCGImageFromImage:(UIImage *)sourceImage {
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:20.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef blurredCGImage = [context createCGImage:result fromRect:[inputImage extent]];
    return blurredCGImage;
}


@end


@implementation Venue (MKAnnotation)

- (NSString *)title {
    return self.name;
}

@end