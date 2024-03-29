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
@import CoreImage;
#import <AFNetworking/AFNetworking.h>
#import <RestKit/CoreData.h>
#import "Venue.h"
#import "VenueCategory.h"
#import "MKMapUtils.h"
#import "NSNumber+Foursquare.h"
#import "CustomReview.h"
#import "ReviewViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>


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
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;

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
    if ([self.mapView respondsToSelector:@selector(setShowsBuildings:)]) {
        self.mapView.showsBuildings = YES;
    }
    if ([self.mapView respondsToSelector:@selector(setShowsPointsOfInterest:)]) {
        self.mapView.showsPointsOfInterest = YES;
    }
    self.mapView.showsUserLocation = YES;
    
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
    [self updateReview];
    [self updateAddToFavoritesButton];
}

- (void)updateAddToFavoritesButton {
    if (self.venue.dateSaved) {
        [self.addToFavoritesButton setTitle:@"★ Remove from Favorites" forState:UIControlStateNormal];
    } else {
        [self.addToFavoritesButton setTitle:@"☆ Add to Favorites" forState:UIControlStateNormal];
    }
}

- (void)updateReview {
    self.reviewLabel.text = self.venue.customReview.text ?: @"No review yet";
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
    NSDate *dateSaved = self.venue.dateSaved;
    if (dateSaved) {
        self.venue.dateSaved = nil;
    } else {
        self.venue.dateSaved = [NSDate date];
    }
    BOOL saved = [self.venue.managedObjectContext saveToPersistentStore:nil];
    if (!saved) {
        [SVProgressHUD showErrorWithStatus:@"Can't save. :(\n Contact support."];
    }
    
    [self updateAddToFavoritesButton];
}

- (IBAction)dismissReviewEditor:(UIStoryboardSegue *)segue {
    [self updateReview];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"writeReview"]) {
        UINavigationController *navController = (id)segue.destinationViewController;
        ReviewViewController *reviewController = navController.viewControllers[0];
        NSAssert([reviewController isKindOfClass:[ReviewViewController class]], @"");
        reviewController.venue = self.venue;
    }
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
    CIFilter *vibrance = [CIFilter filterWithName:@"CIVibrance"];
    [vibrance setValue:inputImage forKey:kCIInputImageKey];
    [vibrance setValue:@1.0f forKey:@"inputAmount"];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clamp = [CIFilter filterWithName:@"CIAffineClamp"];
    [clamp setValue:vibrance.outputImage forKey:@"inputImage"];
    [clamp setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blur setValue:clamp.outputImage forKey:kCIInputImageKey];
    [blur setValue:@10.0f forKey:@"inputRadius"];
    CIImage *result = [blur valueForKey:kCIOutputImageKey];
    
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