//
//  VenueTableViewCell.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 30/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenueTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "Venue.h"
#import "VenueCategory.h"




@interface VenueTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;

@end


@implementation VenueTableViewCell

- (void)setRepresentedObject:(Venue *)representedObject {
    _representedObject = representedObject;
    [self configureWithRepresentedObject:representedObject];
}

- (void)configureWithRepresentedObject:(Venue *)venue {
    static NSString *const kPhotoFormatSpec = @"width640";
    NSString *photoUrlString = [NSString stringWithFormat:@"%@%@%@", venue.photoUrlPrefix, kPhotoFormatSpec, venue.photoUrlSuffix];
    NSURL *photoUrl = [NSURL URLWithString:photoUrlString];
    [self.photoView setImageWithURL:photoUrl];
    
    if ([venue.categories count] > 0) {
        VenueCategory *category = venue.categories.anyObject;
        self.categoryLabel.text = category.name;
    }
    
    self.nameLabel.text = venue.name;
    
    self.hoursLabel.hidden = (venue.openNow == nil);
    if (venue.openNow) {
        self.hoursLabel.text = venue.openNow;
    }
    NSString *priceTier = [self representationForPriceTier:[venue.priceTier integerValue]];
    self.ratingsLabel.text = [NSString stringWithFormat:@"%@, ★ %@", priceTier, venue.rating];
}

- (NSString *)representationForPriceTier:(NSInteger)tier {
    NSMutableString *repr = [NSMutableString stringWithCapacity:tier];
    for (NSInteger idx = 0; idx < tier; idx++) {
        [repr appendString:@"$"];
    }
    return [repr copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.representedObject = nil;
}

@end
