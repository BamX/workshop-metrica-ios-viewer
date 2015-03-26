//
//  Copyright (c) 2015 Yandex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMMetricaDataParserProtocol.h"

extern CGFloat const kWMChartSizeFactor;
extern NSString *const kWMChartFontName;
extern CGFloat const kWMChartFontSize;

@interface WMChartViewController : UIViewController

@property (nonatomic, assign, readonly) CGRect chartFrame;
@property (nonatomic, copy, readonly) NSString *chartName;

@property (nonatomic, strong, readonly) id<WMMetricaDataParserProtocol> parser;
@property (nonatomic, copy) NSArray *chartData;

- (instancetype)initWithChartName:(NSString *)chartName parser:(id<WMMetricaDataParserProtocol>)parser;

@end
