//
//  FLYDeviceManager.h
//  Firelfy
//
//  Created by James Tan on 4/19/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLYDevice.h"
@interface FLYDeviceManager : NSObject

+ (id) sharedInstance;

@property (strong, nonatomic) NSMutableArray *deviceStore;
@property (strong, nonatomic) NSString *filepath;

- (BOOL) isInDeviceStore:(NSInteger)deviceID;
- (void) createDevice:(NSInteger)deviceID sensorCount:(NSInteger)count;
- (void) storeData: (NSDate*)date device: (NSInteger)deviceID data: (unsigned char *)data length:(NSInteger)length;
- (void) storeFilePath:(NSString*)path;
- (void) resetDevices;
@end
