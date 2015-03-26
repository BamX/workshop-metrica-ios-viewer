//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMMetricaDataParserProtocol.h"

@interface WMUserInfoParser : NSObject <WMMetricaDataParserProtocol>

- (instancetype)initWithInfoKey:(NSString *)infoKey;

@end
