//
//  PCAppDelegate.m
//  PerfectCrossfade
//
//  Created by Eric-Paul Lecluse on 13-11-11.
//  Copyright (c) 2011 epologee. All rights reserved.
//

#import "PCAppDelegate.h"
#import "PCBorderView.h"

@implementation PCAppDelegate

@synthesize window = _window;

- (void)performCrossfadeFrom:(UIView *)viewA to:(UIView *)viewB
{
    viewB.alpha = 0;
    
    [UIView animateWithDuration:2 
                          delay:0.5 
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         viewA.alpha = 0;
                         viewB.alpha = 1;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)createDemoInView:(UIView *)containerView
{
    UIColor *semiTransparent = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    
    CGRect topFrame = containerView.bounds;
    topFrame.size.height /= 2;
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(topFrame, 20, 0)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = @"The seam inside the blue square should not be visible during the crossfade.";
    
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
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self createDemoInView:self.window];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
