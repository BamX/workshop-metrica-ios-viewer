//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMViewController.h"
#import <PNChart/PNChart.h>
#import "WMMetricaLoader.h"

static NSString *const kWMCellKey = @"TableChartCell";
static CGFloat const kWMPieChartSizeFactor = 0.8f;

typedef NS_ENUM(NSUInteger, WMChartType) {
    WMChartTypeFirst,
    WMChartTypeSecond,
    WMChartTypeThird,
    WMChartTypesCount,
};

@interface WMViewController () <WMMetricaLoaderDelegate>

@property (nonatomic, weak) PNPieChart *osPieChart;
@property (nonatomic, weak) PNBarChart *iosBarChart;
@property (nonatomic, weak) PNBarChart *androidBarChart;

@property (nonatomic, strong) WMMetricaLoader *usersLoader;
@property (nonatomic, strong) WMMetricaLoader *devicesLoader;

@end

@implementation WMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updatePlatformCharts:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    if (self.usersLoader == nil) {
        self.usersLoader = [[WMMetricaLoader alloc] initWithDelegate:self];
        self.usersLoader.apiKey = kWMSampleApiKey;
    }
    if (self.devicesLoader == nil) {
        self.devicesLoader = [[WMMetricaLoader alloc] initWithDelegate:self];
        self.devicesLoader.apiKey = kWMSampleApiKey;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.usersLoader loadDataForURLParameters:@"date1=2015-03-22&date2=2015-03-22"
     "&metrics=ym:m:users,ym:m:newUsers"
     "&dimensions=ym:m:date"
     "&lang=ru&accuracy=low"];

    [self.devicesLoader loadDataForURLParameters:@"date1=2015-03-22&date2=2015-03-22"
     "&metrics=ym:m:users"
     "&dimensions=ym:m:date,ym:m:operatingSystem"//,ym:m:mobileDeviceBranding"
     "&lang=ru&accuracy=low"];
}

- (void)updatePlatformCharts:(NSDictionary *)results
{
    if (results.count < self.osPieChart.items.count) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        for (PNPieChartDataItem *item in strongSelf.osPieChart.items) {
            item.value = [results[item.textDescription] integerValue];
        }

//        ((PNPieChartDataItem *)strongSelf.osPieChart.items[0]).value = [results[@"android"] integerValue];// arc4random_uniform(100);
//        ((PNPieChartDataItem *)strongSelf.osPieChart.items[1]).value = [results[@"iOS"] integerValue]; // arc4random_uniform(100);
//        ((PNPieChartDataItem *)strongSelf.osPieChart.items[2]).value = [results[@"WindowsPhone"] integerValue]; //arc4random_uniform(100);
        [strongSelf.osPieChart strokeChart];
        
        [strongSelf.refreshControl endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return WMChartTypesCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

+ (CGRect)chartFrame
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGSize size = {
        kWMPieChartSizeFactor * CGRectGetWidth(screenBounds),
        kWMPieChartSizeFactor * CGRectGetWidth(screenBounds)
    };
    CGRect frame = { {
            (CGRectGetWidth(screenBounds) - size.width) * 0.5f,
            (CGRectGetWidth(screenBounds) - size.height) * 0.5f,
        },
        size
    };
    return frame;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWMCellKey];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWMCellKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    switch (indexPath.row) {
        case WMChartTypeFirst: {
            [self.osPieChart removeFromSuperview];

            NSArray *items = @[
                [PNPieChartDataItem dataItemWithValue:10 color:PNRed description:@"WindowsPhone"],
                [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"iOS"],
                [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"android"],
            ];

            PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:[[self class] chartFrame] items:items];
            pieChart.descriptionTextColor = [UIColor whiteColor];
            pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
            [pieChart strokeChart];
            [cell.contentView addSubview:pieChart];
            self.osPieChart = pieChart;

            break;
        }

        case WMChartTypeSecond: {
            [self.iosBarChart removeFromSuperview];

            PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:[[self class] chartFrame]];
            barChart.xLabels = @[ @"iOS 6", @"iOS 7.0", @"iOS 7.1", @"iOS 8.0", @"iOS 8.2" ];
            barChart.yLabelFormatter = ^(CGFloat value) {
                return [NSString stringWithFormat:@"%.1f", value];
            };
            barChart.yValues = @[ @1, @3, @2, @6, @10 ];
            barChart.strokeColor = PNBlue;
            [barChart strokeChart];
            [cell.contentView addSubview:barChart];
            self.iosBarChart = barChart;

            break;
        }

        case WMChartTypeThird: {
            [self.androidBarChart removeFromSuperview];

            PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:[[self class] chartFrame]];
            barChart.xLabels = @[ @"2.3.3", @"4.0", @"4.1", @"4.4", @"5.0" ];
            barChart.yLabelFormatter = ^(CGFloat value) {
                return [NSString stringWithFormat:@"%.1f", value];
            };
            barChart.yValues = @[ @1, @2, @2, @7, @5 ];
            barChart.strokeColor = PNGreen;
            [barChart strokeChart];
            [cell.contentView addSubview:barChart];
            self.androidBarChart = barChart;

            break;
        }
    }

    return cell;
}

- (void)loader:(WMMetricaLoader *)loader didLoadData:(NSDictionary *)dictionary
{
    if (loader == self.usersLoader) {
        [self updateUserGraphs:dictionary];
    } else if (loader == self.devicesLoader) {
        [self updateDevicesGraph:dictionary];
    }
}

- (void)updateUserGraphs:(NSDictionary *)dictionary
{
    NSLog(@"=== updateUserGraphs ===");
    NSArray *totals = dictionary[@"totals"];
    if (totals != nil) {
        NSNumber *result = totals[0];
        NSString *activeUsers = [NSString stringWithFormat:@"actve users: %d", [result intValue]];
        NSLog(@"%@", activeUsers);

        result = totals[1];
        NSString * novelUsers = [NSString stringWithFormat:@"new users: %d", [result intValue]];
        NSLog(@"%@", novelUsers);
    }
}

- (void)updateDevicesGraph:(NSDictionary *)dictionary
{
    NSLog(@"=== updateDevicesGraph ===");
    NSMutableDictionary *platform = [NSMutableDictionary dictionary];
    NSArray *data = dictionary[@"data"];
    for (NSDictionary *value in data) {
        NSArray *count = value[@"metrics"];
        NSNumber *total = count.firstObject;

        NSArray *dimensions = value[@"dimensions"];
        NSString *os = dimensions[1][@"name"];

        [platform setObject:total forKey:os];

//        NSString *manufacturer = dimensions[2][@"name"];
    }

    [self updatePlatformCharts:platform];

}

@end
