//
//  PCAppDelegate.m
//  PerfectCrossfade
//
//  Created by Eric-Paul Lecluse on 13-11-11.
//  Copyright (c) 2011 epologee. All rights reserved.
//

#import "PCAppDelegate.h"
#import "PCBorderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PCAppDelegate

@synthesize window = _window;

- (void)performCrossfadeFrom:(UIView *)viewA to:(UIView *)viewB
{
    [CATransaction begin];
    {    
        [CATransaction setValue:[NSNumber numberWithFloat:3.0f] forKey:kCATransactionAnimationDuration];
    
        // Change these control point values to adjust the timing curves.
        // The CAMediaTimingFunction this creates is an asymmetrical one, in the vertical sense.
        // On 50% of the animation, both alpha values added together will be greater than 1.0f.
        CGPoint low = CGPointMake(0.150, 0.000);
        CGPoint high = CGPointMake(0.500, 0.000);
        
        [CATransaction begin];
        {
            CAMediaTimingFunction* perfectIn = [CAMediaTimingFunction functionWithControlPoints:low.x :low.y :1.0 - high.x :1.0 - high.y];
            [CATransaction setAnimationTimingFunction: perfectIn];
            CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeIn.fromValue = [NSNumber numberWithFloat:0];
            fadeIn.toValue = [NSNumber numberWithFloat:1.0];
            fadeIn.repeatCount = HUGE_VALF;
            fadeIn.autoreverses = YES;
            [viewB.layer addAnimation:fadeIn forKey:@"animateOpacity"];
        }
        [CATransaction commit];
        
        [CATransaction begin];
        {
            CAMediaTimingFunction* perfectOut = [CAMediaTimingFunction functionWithControlPoints:high.x :high.y :1.0 - low.x : 1.0 - low.y];
            [CATransaction setAnimationTimingFunction: perfectOut];
            CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeOut.fromValue = [NSNumber numberWithFloat:1.0];
            fadeOut.toValue = [NSNumber numberWithFloat:0];
            fadeOut.repeatCount = HUGE_VALF;
            fadeOut.autoreverses = YES;
            [viewA.layer addAnimation:fadeOut forKey:@"animateOpacity"];
        }
        [CATransaction commit];
        
    }
    [CATransaction commit];
}

- (void)createDemoInView:(UIView *)containerView
{
    // This color contains the initial transparency of the uiviews.
    // If you change the alpha component, the curve needs adjustment too :S
    CGFloat initialTransparency = 0.8;
    UIColor *semiTransparent = [[UIColor darkGrayColor] colorWithAlphaComponent:initialTransparency];
    
    CGRect topFrame = containerView.bounds;
    topFrame.size.height /= 1.5;
    
    CGRect bottomLeftFrame = topFrame;
    bottomLeftFrame.origin.y = topFrame.size.height;
    bottomLeftFrame.size.width /= 1.5;
    
    CGRect bottomRightFrame = bottomLeftFrame;
    bottomRightFrame.origin.x = topFrame.size.width - bottomRightFrame.size.width;
    
    UIView *top = [[UIView alloc] initWithFrame:topFrame];
    top.backgroundColor = semiTransparent;
    
    UIView *bottomLeft = [[UIView alloc] initWithFrame:bottomLeftFrame];
    bottomLeft.backgroundColor = semiTransparent;
    
    UIView *bottomRight = [[UIView alloc] initWithFrame:bottomRightFrame];
    bottomRight.backgroundColor = semiTransparent;
    
    CGFloat overlap = CGRectGetMaxX(bottomLeftFrame) - CGRectGetMinX(bottomRightFrame);
    CGRect borderFrame = CGRectMake(CGRectGetMinX(bottomRightFrame), CGRectGetMaxY(topFrame) - overlap / 2, overlap, overlap);
    UIView *border = [[PCBorderView alloc] initWithFrame:borderFrame];
    
    CGRect labelFrame = CGRectInset(topFrame, 20, 0);
    labelFrame.size.height -= overlap / 2;
    labelFrame.origin.y += 10;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = [NSString stringWithFormat:@"The seam inside the blue square should not be visible during the crossfade.\n\nA change of the initial transparency will require a change of the s-curve.\n\nInitial transparency = %0.2f", initialTransparency];
    
    [containerView addSubview:top];
    [containerView addSubview:bottomLeft];
    [containerView addSubview:bottomRight];
    [containerView addSubview:border];
    [containerView addSubview:label];
    
    [self performCrossfadeFrom:bottomLeft to:bottomRight];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self createDemoInView:self.window];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
