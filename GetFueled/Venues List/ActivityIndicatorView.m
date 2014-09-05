//
//  ActivityIndicatorView.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 05/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "ActivityIndicatorView.h"
@import QuartzCore;
#import <libextobjc/EXTKeyPathCoding.h>

@interface ActivityIndicatorView ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dots;

@end


@implementation ActivityIndicatorView

- (void)awakeFromNib {
    self.dots = [self.dots sortedArrayUsingSelector:@selector(tag)];
}

- (void)startAnimating {
    id color0 = (id)[UIColor colorWithRed:0.68 green:0 blue:0 alpha:1].CGColor;
//    id color1 = (id)[UIColor colorWithRed:0.79 green:0.27 blue:0.27 alpha:1].CGColor;
    id color2 = (id)[UIColor colorWithRed:0.95 green:0.81 blue:0.81 alpha:1].CGColor;
    
    [self animateLayer:[self.dots[0] layer] withValues:@[color0, color2, color2, color0] timings:@[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ]];
    [self animateLayer:[self.dots[1] layer] withValues:@[color2, color2, color0, color2] timings:@[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut] ]];
    [self animateLayer:[self.dots[2] layer] withValues:@[color2, color0, color2, color2] timings:@[ [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ]];
}

- (void)animateLayer:(CALayer *)layer withValues:(NSArray *)values timings:(NSArray *)timings {
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.timingFunctions = timings;
    animation.duration = 1.5;
    animation.values = values;
    animation.autoreverses = NO;
    animation.repeatCount = HUGE_VALF;
    [layer addAnimation:animation forKey:@keypath(layer, backgroundColor)];
}

- (void)stopAnimating {
    [self.dots enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view.layer removeAllAnimations];
    }];
}

@end
