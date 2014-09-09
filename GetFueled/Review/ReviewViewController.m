//
//  ReviewViewController.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "ReviewViewController.h"
@import CoreData;
#import <RestKit/CoreData.h>
#import "Venue.h"
#import "CustomReview.h"

@interface ReviewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.venue.customReview.text ?: @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}

- (IBAction)done:(id)sender {
    if ([[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return;
    }
    
    NSManagedObjectContext *context = self.venue.managedObjectContext;
    CustomReview *review = [NSEntityDescription insertNewObjectForEntityForName:@"CustomReview" inManagedObjectContext:context];
    review.text = self.textView.text;
    self.venue.customReview = review;
    NSError *error;
    BOOL saved = [review.managedObjectContext saveToPersistentStore:&error];
    if (!saved) {
        // TODO <# warn user #> do not dismiss
    } else {
        [self performSegueWithIdentifier:@"unwindOnDone" sender:self];
    }
}

@end
