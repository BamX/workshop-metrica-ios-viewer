//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMAppDelegate.h"
#import "WMMainViewController.h"

@implementation WMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    WMMainViewController *mainViewController =
        [[WMMainViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                      options:nil];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:mainViewController];

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.backgroundColor = [UIColor lightGrayColor];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
