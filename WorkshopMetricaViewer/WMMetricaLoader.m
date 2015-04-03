//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import "WMMetricaLoader.h"

static NSString *const kWMAppApiKey = @"37970";
static NSString *const kWMAppToken = @"0e491c59ad834583b4e397ddf7ce9d9e";
static NSString *const kWMFromDate = @"2015-03-26"; // The day of workshop
static NSString *const kWMToDate = @"today";

static NSString *const kWMMetricaDataURL = @"https://beta.api-appmetrika.yandex.ru/stat/v1/data";
static NSString *const kWMMetricaDrilldownPostfix = @"/drilldown";

@implementation WMMetricaLoader

+ (void)loadObjectForParameters:(NSDictionary *)parameters
                      drilldown:(BOOL)drilldown
                       callback:(WMMetricaLoaderCallback)callback
{
    NSURL *URL = [[self class] metricaURLForParameters:parameters drilldown:drilldown];

    [[self class] dispatchAsync:^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:URL options:NSDataReadingUncached error:&error];
        if (error == nil && data != nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&error];
            if (error == nil) {
                [[self class] dispatchMain:^{
                    if (callback != nil) {
                        callback(responseObject);
                    }
                }];
            }
        }
    }];
}

+ (NSURL *)metricaURLForParameters:(NSDictionary *)parameters drilldown:(BOOL)drilldown
{
    NSMutableDictionary *fullParameters = [parameters mutableCopy];
    fullParameters[@"ids"] = kWMAppApiKey;
    fullParameters[@"oauth_token"] = kWMAppToken;
    fullParameters[@"date1"] = kWMFromDate;
    fullParameters[@"date2"] = kWMToDate;

    NSString *parametersString = [[self class] stringWithJoinedParameters:fullParameters];

    NSString *baseURL = kWMMetricaDataURL;
    if (drilldown) {
        baseURL = [baseURL stringByAppendingString:kWMMetricaDrilldownPostfix];
    }

    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", baseURL, parametersString]];
}

+ (NSString *)stringWithJoinedParameters:(NSDictionary *)parameters
{
    NSMutableArray *parameterPairs = [NSMutableArray arrayWithCapacity:parameters.count];
    for (NSString *key in parameters) {
        NSString *value = [parameters[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [parameterPairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }

    return [parameterPairs componentsJoinedByString:@"&"];
}

+ (void)dispatchAsync:(void (^)())block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}

+ (void)dispatchMain:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
