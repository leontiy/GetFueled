//
//  BouncyButton.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 13/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "BouncyButton.h"

@implementation BouncyButton

- (void)doInitBouncyButton {
    SEL bounceSelector = GF_SYSTEM_VERSION_LESS_THAN(7.0) ? @selector(bounce_iOS6) : @selector(bounce);
    [self addTarget:self action:@selector(prepareBounce) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:bounceSelector forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(cancelBounce) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(cancelBounce) forControlEvents:UIControlEventTouchCancel];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInitBouncyButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInitBouncyButton];
    }
    return self;
}

- (void)prepareBounce {
    self.transform = CGAffineTransformMakeScale(0.97, 0.97);
}

- (void)bounce {
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.1
          initialSpringVelocity:4.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:nil];
}

- (void)bounce_iOS6 {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

- (void)cancelBounce {
    [UIView animateWithDuration:0.5 animations:^{ self.transform = CGAffineTransformMakeScale(1, 1); }];
}
@end
