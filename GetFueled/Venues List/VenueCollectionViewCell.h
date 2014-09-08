//
//  VenueTableViewCell.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 30/08/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Venue;

@interface VenueCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Venue *representedObject;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

@end
