//
//  VenueTableViewCell.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 30/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenueCollectionViewCell.h"
@import QuartzCore;
#import <AFNetworking/AFNetworking.h>
#import "Venue.h"
#import "VenueCategory.h"
#import "NSNumber+Foursquare.h"




@interface VenueCollectionViewCell ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textBoxes;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end


@implementation VenueCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.textBoxes enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.frame].CGPath;
    }];
}

- (void)setRepresentedObject:(Venue *)representedObject {
    _representedObject = representedObject;
    [self configureWithRepresentedObject:representedObject];
}

- (void)configureWithRepresentedObject:(Venue *)venue {
    if (venue == nil) {
        return;
    }
    
    NSURL *photoUrl = [NSURL URLWithString:venue.thumbnailUrl];
    [self.photoView setImageWithURL:photoUrl];
    
    self.categoryLabel.hidden = [venue.categories count] == 0;
    VenueCategory *category = venue.categories.anyObject;
    self.categoryLabel.text = category.name;
    
    self.nameLabel.text = venue.name;
    
    self.hoursLabel.hidden = [venue.openNow length] == 0;
    self.hoursLabel.text = venue.openNow;
    
    NSString *priceTier = [venue.priceTier gf_priceTierRerepresentationString];
    self.ratingsLabel.text = [NSString stringWithFormat:@"%@  ★ %@", priceTier, venue.rating];

    self.addressLabel.text = venue.address;
}

- (void)prepareForReuse {
    self.photoView.image = nil;
    self.representedObject = nil;
}

static const CGFloat kSelectedHighlightedAlpha = 0.5;

- (void)setSelected:(BOOL)selected {
    self.contentView.alpha = selected || self.highlighted ? kSelectedHighlightedAlpha : 1;
}

- (void)setHighlighted:(BOOL)highlighted {
    self.contentView.alpha = self.selected || highlighted ? kSelectedHighlightedAlpha : 1;
}

@end
