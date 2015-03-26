//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WMMetricaLoaderCallback)(NSDictionary *responseObject);

@interface WMMetricaLoader : NSObject

+ (void)loadObjectForParameters:(NSDictionary *)parameters
                      drilldown:(BOOL)drilldown
                       callback:(WMMetricaLoaderCallback)callback;

@end
