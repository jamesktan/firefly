//
//  FLYDevice.m
//  Firelfy
//
//  Created by James Tan on 4/19/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYDevice.h"

@implementation FLYDevice

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return [[self.dataStores objectAtIndex:0] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSString * plotName = plot.name;
    NSArray * plotNameArray = [plotName componentsSeparatedByString:@" - "];
    NSString * plotSensorName = [plotNameArray objectAtIndex:1];
    NSInteger sensorInteger = [plotSensorName integerValue];
    
    NSInteger newIndex = sensorInteger + 1;
    NSMutableArray * array = [self.dataStores objectAtIndex:newIndex];
    
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        // Return x value, which will, depending on index, be between -4 to 4
        return [NSNumber numberWithInteger:index];
    } else {
        // Return y value, for this example we'll be plotting y = x * x
        return [array objectAtIndex:index];
    }

}

@end
