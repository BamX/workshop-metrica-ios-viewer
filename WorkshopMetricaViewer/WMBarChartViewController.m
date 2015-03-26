//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMBarChartViewController.h"

#import <PNChart/PNChart.h>
#import "WMMetricaLoader.h"

@interface WMBarChartViewController ()

@property (nonatomic, weak) PNBarChart *barChart;
@property (nonatomic, strong) WMMetricaLoader *usersLoader;

@end

@implementation WMBarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureChart];
}

- (void)configureChart
{
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:self.chartFrame];
    barChart.yLabelFormatter = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%ld", (long)value];
    };
    [barChart strokeChart];
    [self.view addSubview:barChart];

    self.barChart = barChart;
}

- (void)setChartData:(NSArray *)chartData
{
    if (self.chartData != chartData) {
        [super setChartData:chartData];

        NSMutableArray *xLabels = [NSMutableArray arrayWithCapacity:chartData.count];
        NSMutableArray *yValues = [NSMutableArray arrayWithCapacity:chartData.count];
        NSMutableArray *colors = [NSMutableArray arrayWithCapacity:chartData.count];
        for (PNPieChartDataItem *dataItem in chartData) {
            [xLabels addObject:dataItem.textDescription];
            [yValues addObject:@(dataItem.value)];
            [colors addObject:dataItem.color];
        }

        self.barChart.xLabels = xLabels;
        self.barChart.strokeColors = colors;
        [self.barChart updateChartData:yValues];
    }
}

@end
