//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMMainViewController.h"

#import "WMPieChartViewController.h"
#import "WMBarChartViewController.h"
#import <PNChart/PNChart.h>

#import "WMPlatformsParser.h"
#import "WMUsersParser.h"
#import "WMUserInfoParser.h"

@interface WMMainViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *charts;

@end

@implementation WMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource = self;
    self.title = NSLocalizedString(@"AppTitle", nil);

    self.charts = @[
        [[WMPieChartViewController alloc] initWithChartName:NSLocalizedString(@"Platforms", nil)
                                                     parser:[[WMPlatformsParser alloc] init]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Users", nil)
                                                     parser:[[WMUsersParser alloc] init]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Age", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"age"]],
        [[WMPieChartViewController alloc] initWithChartName:NSLocalizedString(@"Gender", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"gender"]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Education", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"education"]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Work", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"work"]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Absence", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"absence"]],
        [[WMBarChartViewController alloc] initWithChartName:NSLocalizedString(@"Rating", nil)
                                                     parser:[[WMUserInfoParser alloc] initWithInfoKey:@"rating"]],
    ];

    [self setViewControllers:@[ self.charts.firstObject ]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    UIViewController *viewController = pageViewController.viewControllers.firstObject;
    return [self.charts indexOfObject:viewController];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.charts.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.charts indexOfObject:viewController];
    return self.charts[(index + self.charts.count - 1) % self.charts.count];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.charts indexOfObject:viewController];
    return self.charts[(index + 1) % self.charts.count];
}

@end
