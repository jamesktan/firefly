//
//  FLYDevice.h
//  Firelfy
//
//  Created by James Tan on 4/19/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot-CocoaTouch.h>

@interface FLYDevice : NSObject <CPTPlotDataSource>

@property (strong, nonatomic) NSNumber * deviceID;
@property (strong, nonatomic) NSNumber * deviceCount;

@property (strong, nonatomic) NSMutableArray * dataStores;
// the first store is the date store, each subsequent one corresponds to an ID




@end
