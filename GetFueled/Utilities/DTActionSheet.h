//
//  DTActionSheet.h
//  DTFoundation
//
//  Created by Oliver Drobnik on 08.06.12.
//  Copyright (c) 2012 Cocoanetics. All rights reserved.
//

// the block to execute when an option button is tapped
typedef void (^DTActionSheetBlock)(void);

/**
 Extends UIActionSheet with support for blocks
 */

@interface DTActionSheet : UIActionSheet

/**
 Initializes the action sheet using the specified title. 
 @param title The title
 */
- (id)initWithTitle:(NSString *)title;

/**
 Adds a custom button to the action sheet.
 @param title The title of the new button.
 @param block The block to execute when the button is tapped.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
*/ 
- (NSInteger)addButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block;

/**
 Adds a custom destructive button to the action sheet.
 
 Since there can only be one destructive button a previously marked destructive button becomes a normal button.
 @param title The title of the new button.
 @param block The block to execute when the button is tapped.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
 */ 
- (NSInteger)addDestructiveButtonWithTitle:(NSString *)title block:(DTActionSheetBlock)block;

/**
 Adds a custom cancel button to the action sheet.
 
 Since there can only be one cancel button a previously marked cancel button becomes a normal button.
 @param title The title of the new button.
 @returns The index of the new button. Button indices start at 0 and increase in the order they are added.
 */ 
- (NSInteger)addCancelButtonWithTitle:(NSString *)title;

- (void)addWillDismissBlock:(DTActionSheetBlock)block;

@end
