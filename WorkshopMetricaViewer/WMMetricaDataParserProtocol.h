//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WMMetricaDataParserCallback)(NSArray *dataArray);

@protocol WMMetricaDataParserProtocol <NSObject>

- (void)loadDataWithCallback:(WMMetricaDataParserCallback)callback;

@end
