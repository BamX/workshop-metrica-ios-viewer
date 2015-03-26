//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMUserInfoParser.h"
#import "WMMetricaLoader.h"

#import <PNChart/PNChart.h>

@interface WMUserInfoParser ()

@property (nonatomic, copy) NSString *infoKey;

@end

@implementation WMUserInfoParser

- (instancetype)initWithInfoKey:(NSString *)infoKey
{
    self = [super init];
    if (self != nil) {
        _infoKey = [infoKey copy];
    }
    return self;
}

- (void)loadDataWithCallback:(WMMetricaDataParserCallback)callback
{
    NSDictionary *parameters = @{
        @"metrics" : @"ym:m:devices,ym:m:clientEvents",
        @"dimensions" : @"ym:m:eventLabel,ym:m:paramsLevel1,ym:m:paramsLevel2,ym:m:paramsLevel3",
        @"parent_id" : [NSString stringWithFormat:@"[\"user_info\",\"%@\"]", self.infoKey],
    };

    [WMMetricaLoader loadObjectForParameters:parameters
                                   drilldown:YES
                                    callback:^(NSDictionary *responseObject) {
                                        [self loaderDidLoadData:responseObject callback:callback];
                                    }];
}

- (void)loaderDidLoadData:(NSDictionary *)dictionary callback:(WMMetricaDataParserCallback)callback
{
    NSMutableArray *items = [NSMutableArray array];

    NSArray *data = dictionary[@"data"];
    for (NSDictionary *value in data) {
        NSArray *metrics = value[@"metrics"];
        NSNumber *total = metrics[1];

        NSDictionary *dimension = value[@"dimension"];
        NSString *os = dimension[@"name"];

        if (total.integerValue != 0) {
            [items addObject:[PNPieChartDataItem dataItemWithValue:total.floatValue
                                                             color:PNBlue
                                                       description:NSLocalizedString(os, nil)]];
        }
    }

    if (callback != nil) {
        callback([items copy]);
    }
}

@end
