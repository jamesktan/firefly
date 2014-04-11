//
//  FLYConnectionManager.h
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLE.h"

@interface FLYConnectionManager : NSObject  <BLEDelegate> {
    BLE * bleShield;
    CBPeripheral * periph;
}
@property(strong, nonatomic) NSArray * listOfPeripherals;

+ (id)          sharedInstance;
- (void)        setupNotifications;

@end
