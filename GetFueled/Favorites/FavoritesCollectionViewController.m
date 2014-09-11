//
//  FavoritesCollectionViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "FavoritesCollectionViewController.h"
@import CoreData;
#import <libextobjc/EXTKeyPathCoding.h>
#import "VenueCollectionViewCell.h"
#import "VenueViewController.h"
#import "Venue.h"
#import "RequestStatusView.h"


static NSString *const kFavoriteVenueCellReuseIdentifier = @"VenueCell";


@interface FavoritesCollectionViewController ()

@property (nonatomic, copy) NSArray *favorites;

@end

@implementation FavoritesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VenueCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:kFavoriteVenueCellReuseIdentifier];
}

- (void)refresh {
    NSFetchRequest *favoritesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Venue"];
    [favoritesRequest setPredicate:[NSPredicate predicateWithFormat:@"dateSaved != NULL"]];
    [favoritesRequest setSortDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@keypath([Venue new], dateSaved) ascending:NO] ]];
    NSError *error;
    self.favorites = [self.context executeFetchRequest:favoritesRequest error:&error];
    if (self.favorites == nil) {
        NSLog(@"Can't fetch favorites %@", [error localizedDescription]);
        [self showPlaceholderWithText:@"Internal error occurred. :(\n Contact support or reinstall the app.\n(It's not going live anyway:)"];
    } else if ([self.favorites count] == 0) {
        [self showPlaceholderWithText:@"No favorite venues.\n You can choose some from the Recommended list."];
    } else {
        [self hidePlaceholder];
    }
    [self.collectionView reloadData];
}

- (void)showPlaceholderWithText:(NSString *)text {
    RequestStatusView *statusView = [[NSBundle mainBundle] loadNibNamed:@"RequestStatusView" owner:nil options:nil][0];
    statusView.textLabel.text = text;
    self.collectionView.backgroundView = statusView;
}

- (void)hidePlaceholder {
    self.collectionView.backgroundView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.favorites count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VenueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFavoriteVenueCellReuseIdentifier forIndexPath:indexPath];
    cell.representedObject = self.favorites[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showVenue" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVenue"]) {
        VenueViewController *vc = segue.destinationViewController;
        vc.venue = [sender representedObject];
    }
}

@end
