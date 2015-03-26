//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMChartViewController.h"

#import <PNChart/PNChart.h>

CGFloat const kWMChartSizeFactor = 0.8f;
NSString *const kWMChartFontName = @"Avenir-Medium";
CGFloat const kWMChartFontSize = 14.0f;

static CGFloat const kWMChartNameFontSize = 25.0f;
static CGFloat const kWMChartNameLabelHeight = 30.0f;

@interface WMChartViewController ()

@property (nonatomic, weak) UILabel *chartNameLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end

@implementation WMChartViewController

- (instancetype)initWithChartName:(NSString *)chartName parser:(id<WMMetricaDataParserProtocol>)parser
{
    self = [super init];
    if (self != nil) {
        _chartName = [chartName copy];
        _parser = parser;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self configureChartTitle];
    [self configureActivityIndicator];
}

- (void)configureChartTitle
{
    CGRect labelFrame = {
        0.0f, CGRectGetHeight(self.view.bounds) * 0.8f,
        CGRectGetWidth(self.view.bounds), kWMChartNameLabelHeight
    };
    UILabel *chartNameLabel = [[UILabel alloc] initWithFrame:labelFrame];
    chartNameLabel.textAlignment = NSTextAlignmentCenter;
    chartNameLabel.font = [UIFont fontWithName:kWMChartFontName size:kWMChartNameFontSize];
    chartNameLabel.adjustsFontSizeToFitWidth = YES;
    chartNameLabel.text = self.chartName;
    [self.view addSubview:chartNameLabel];
    self.chartNameLabel = chartNameLabel;
}

- (void)configureActivityIndicator
{
    UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.chartNameLabel.center;
    activityIndicator.frame = CGRectOffset(activityIndicator.frame, 0.0f, kWMChartNameLabelHeight);
    [self.view addSubview:activityIndicator];
    self.activityIndicator = activityIndicator;
}

- (CGRect)chartFrame
{
    CGRect bounds = self.view.bounds;
    CGSize size = {
        kWMChartSizeFactor * CGRectGetWidth(bounds),
        kWMChartSizeFactor * CGRectGetWidth(bounds)
    };
    CGRect frame = {
        {
            (CGRectGetWidth(bounds) - size.width) * 0.5f,
            (CGRectGetHeight(bounds) - size.height) * 0.5f,
        },
        size
    };
    return frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.activityIndicator startAnimating];
    __weak __typeof(self) weakSelf = self;
    [self.parser loadDataWithCallback:^(NSArray *dataArray) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.chartData = dataArray;
        [strongSelf.activityIndicator stopAnimating];
    }];
}

- (void)fixColors
{
    static NSArray *colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = @[ PNBlue, PNRed, PNGreen, PNYellow, PNBrown, PNGrey, PNPinkGrey ];
    });

    if (self.chartData.count <= colors.count) {
        BOOL badColorsExists = NO;
        for (NSInteger index = 0; index < self.chartData.count; ++index) {
            PNPieChartDataItem *item = self.chartData[index];
            PNPieChartDataItem *nextItem = self.chartData[(index + 1) % self.chartData.count];

            if ([item.color isEqual:nextItem.color]) {
                badColorsExists = YES;
                break;
            }
        }

        if (badColorsExists) {
            for (NSInteger index = 0; index < self.chartData.count; ++index) {
                PNPieChartDataItem *item = self.chartData[index];
                item.color = colors[index];
            }
        }
    }
}

- (void)setChartData:(NSArray *)chartData
{
    if (self.chartData != chartData) {
        _chartData = [chartData copy];

        [self fixColors];
    }
}

@end
