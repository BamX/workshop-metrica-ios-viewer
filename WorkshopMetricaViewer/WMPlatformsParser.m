//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMPlatformsParser.h"
#import "WMMetricaLoader.h"

#import <PNChart/PNChart.h>

@implementation WMPlatformsParser

- (void)loadDataWithCallback:(WMMetricaDataParserCallback)callback
{
    [WMMetricaLoader loadObjectForParameters:@{
                                               @"metrics" : @"ym:m:users",
                                               @"dimensions" : @"ym:m:operatingSystem"
                                               }
                                   drilldown:NO
                                    callback:^(NSDictionary *responseObject) {
                                       [self loaderDidLoadData:responseObject callback:callback];
                                   }];
}

- (UIColor *)colorForOSName:(NSString *)osName
{
    static NSDictionary *colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = @{
            @"iOS" : PNBlue,
            @"android" : PNGreen,
            @"WindowsPhone" : PNRed,
        };
    });

    return colors[osName] ?: PNGrey;
}

- (void)loaderDidLoadData:(NSDictionary *)dictionary callback:(WMMetricaDataParserCallback)callback
{
    NSMutableArray *platforms = [NSMutableArray array];

    NSArray *data = dictionary[@"data"];
    for (NSDictionary *value in data) {
        NSArray *metrics = value[@"metrics"];
        NSNumber *total = metrics.firstObject;

        NSArray *dimensions = value[@"dimensions"];
        NSString *os = dimensions[0][@"name"];

        if (total.integerValue != 0) {
            [platforms addObject:[PNPieChartDataItem dataItemWithValue:total.floatValue
                                                                 color:[self colorForOSName:os]
                                                           description:NSLocalizedString(os, nil)]];
        }
    }

    if (callback != nil) {
        callback([platforms copy]);
    }
}

@end
