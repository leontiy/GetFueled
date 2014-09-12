//
//  AppearanceCustomization.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 09/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "AppearanceCustomization.h"

@interface AppearanceCustomization_iOS6 : AppearanceCustomization
@end

@implementation AppearanceCustomization

+ (instancetype)new {
    if (GF_SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return [[AppearanceCustomization_iOS6 alloc] init];
    } else {
        return [[AppearanceCustomization alloc] init];
    }
}

+ (UIColor*)darkCandyAppleColor {
    return [UIColor colorWithRed:0.68 green:0 blue:0 alpha:1];
}

+ (UIColor *)onyxColor {
    return [UIColor colorWithWhite:0.086 alpha:0.9];
}

+ (UIColor *)antiFlashWhiteColor {
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.95 alpha:1];
}

+ (UIColor *)jumboGreyColor {
    return [UIColor colorWithRed:0.54 green:0.54 blue:0.53 alpha:1];
}

- (void)applyGeneralCustomizations {
    [self customizeNavigationBar];
    [self customizeStatusBar];
}

- (void)customizeStatusBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)customizeNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:[AppearanceCustomization onyxColor]];
    [appearance setTintColor:[AppearanceCustomization antiFlashWhiteColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [[AppearanceCustomization darkCandyAppleColor] colorWithAlphaComponent:0.5];
    shadow.shadowOffset = CGSizeMake(1, 1);
    appearance.titleTextAttributes = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"UnitedSansCond-Medium" size:28],
                                       NSForegroundColorAttributeName : [AppearanceCustomization antiFlashWhiteColor],
                                       NSShadowAttributeName : shadow,
                                       };
}

@end


@implementation AppearanceCustomization_iOS6

- (void)customizeStatusBar {
    [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackOpaque;
}

- (void)customizeNavigationBar {
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setTintColor:[UIColor colorWithWhite:0.086 alpha:0.9]];
    
    appearance.titleTextAttributes = @{
                                       UITextAttributeFont : [UIFont fontWithName:@"UnitedSansSemiCond-Bold" size:24],
                                       UITextAttributeTextColor : [AppearanceCustomization antiFlashWhiteColor],
                                       };
}

@end