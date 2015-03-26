//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMUsersParser.h"
#import "WMMetricaLoader.h"

#import <PNChart/PNChart.h>

@implementation WMUsersParser

- (void)loadDataWithCallback:(WMMetricaDataParserCallback)callback
{
    [WMMetricaLoader loadObjectForParameters:@{ @"metrics" : @"ym:m:users,ym:m:newUsers" }
                                   drilldown:NO
                                    callback:^(NSDictionary *responseObject) {
                                        [self loaderDidLoadData:responseObject callback:callback];
                                    }];
}

- (void)loaderDidLoadData:(NSDictionary *)dictionary callback:(WMMetricaDataParserCallback)callback
{
    NSArray *users = nil;
    NSArray *totals = dictionary[@"totals"];
    if (totals.count == 2) {
        CGFloat activeUsers = ((NSNumber *)totals[0]).floatValue;
        CGFloat newUsers = ((NSNumber *)totals[1]).floatValue;
        users = @[
            [PNPieChartDataItem dataItemWithValue:activeUsers
                                            color:PNYellow
                                      description:NSLocalizedString(@"ActiveUsers", nil)],
            [PNPieChartDataItem dataItemWithValue:newUsers
                                            color:PNGreen
                                      description:NSLocalizedString(@"NewUsers", nil)],
        ];
    }

    if (callback != nil) {
        callback([users copy]);
    }
}

@end
