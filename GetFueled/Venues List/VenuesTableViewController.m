//
//  VenuesTableViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 05/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "VenuesTableViewController.h"
@import CoreData;
#import <libextobjc/EXTKeyPathCoding.h>
#import "VenueTableViewCell.h"
#import "ModelManager.h"
#import "Venue.h"
#import "RecommendedItem.h"
#import "ActivityIndicatorView.h"




@interface VenuesTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *dataController;
@property (nonatomic, strong) ActivityIndicatorView *pageLoadingIndicator;

@end

@implementation VenuesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ModelManager sharedModelManager] refresh];

    ModelManager *model = [ModelManager sharedModelManager];
    NSFetchRequest *recommendedItems = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([RecommendedItem class])];
    recommendedItems.relationshipKeyPathsForPrefetching = @[ @keypath(RecommendedItem.new, venue),
                                                             @keypath(RecommendedItem.new, venue.categories) ];
    recommendedItems.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@keypath(RecommendedItem.new, index) ascending:YES] ];
    self.dataController = [[NSFetchedResultsController alloc] initWithFetchRequest:recommendedItems
                                                              managedObjectContext:model.mainContext
                                                                sectionNameKeyPath:nil
                                                                         cacheName:nil];
    self.dataController.delegate = self;

    NSError *error;
    BOOL fetched = [self.dataController performFetch:&error];
    if (!fetched) {
        NSLog(@"Could not fetch recommended items: %@", [error localizedDescription]);
    }
    
    self.pageLoadingIndicator = [[NSBundle mainBundle] loadNibNamed:@"ActivityIndicatorView" owner:nil options:nil][0];
    const CGFloat loadingIndicatorHeight = self.pageLoadingIndicator.frame.size.height;
    [self.tableView insertSubview:self.pageLoadingIndicator atIndex:0];

    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = loadingIndicatorHeight;
    self.tableView.contentInset = inset;
}

- (void)viewDidLayoutSubviews {
    [self.pageLoadingIndicator startAnimating];
    CGRect frame = self.pageLoadingIndicator.frame;
    frame.origin.y = self.tableView.contentSize.height;
    self.pageLoadingIndicator.frame = frame;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(RecommendedItem *)recommendedItem
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
                VenueTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
                cell.representedObject = recommendedItem.venue;
            };
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataController.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VenueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
    cell.representedObject = [self.dataController.fetchedObjects[indexPath.row] venue];
    return cell;
}

@end
