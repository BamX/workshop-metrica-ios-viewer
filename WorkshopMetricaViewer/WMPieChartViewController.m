//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMPieChartViewController.h"

#import <PNChart/PNChart.h>
#import "WMMetricaLoader.h"

@interface WMPieChartViewController ()

@property (nonatomic, weak) PNPieChart *pieChart;

@end

@implementation WMPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureChart];
}

- (void)configureChart
{
    [self.pieChart removeFromSuperview];

    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:self.chartFrame items:self.chartData];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:kWMChartFontName size:kWMChartFontSize];
    [pieChart strokeChart];

    [self.view addSubview:pieChart];
    self.pieChart = pieChart;
}

- (void)setChartData:(NSArray *)chartData
{
    if (self.chartData != chartData) {
        BOOL dataChanged = NO;

        if (chartData.count != self.chartData.count) {
            dataChanged = YES;
        }
        else {
            for (NSInteger index = 0; index < chartData.count; ++index) {
                PNPieChartDataItem *item = self.chartData[index];
                PNPieChartDataItem *newItem = chartData[index];

                if ([item.textDescription isEqualToString:newItem.textDescription] == NO || item.value != newItem.value) {
                    dataChanged = YES;
                    break;
                }
            }
        }

        [super setChartData:chartData];

        if (dataChanged) {
            [self configureChart];
        }
    }
}

@end
