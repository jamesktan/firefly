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
#import "FLYDeviceManager.h"

@interface FLYConnectionManager : NSObject  <BLEDelegate> {
    CBPeripheral * periph;
    FLYDeviceManager *DEVICE_MANAGER;
}
@property(strong, nonatomic) NSArray * listOfPeripherals;
@property(strong,nonatomic) BLE * bleShield;
+ (id)          sharedInstance;
- (void)        setupNotifications;

@end
