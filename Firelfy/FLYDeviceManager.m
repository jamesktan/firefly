//
//  FLYDeviceManager.m
//  Firelfy
//
//  Created by James Tan on 4/19/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYDeviceManager.h"

@implementation FLYDeviceManager

+ (FLYDeviceManager*)sharedInstance {
    static dispatch_once_t _singletonPredicate;
    static FLYDeviceManager *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    return _singleton;
}
+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}


- (BOOL) isInDeviceStore:(NSInteger)deviceID {
    
    if (![self.deviceStore count]) {
        return FALSE;
    }
    
    for(FLYDevice * device in self.deviceStore) {
        if (device.deviceID.integerValue == deviceID) {
            return TRUE;
        }
    }
    
    return FALSE;
}

- (FLYDevice*) getDeviceByID: (NSInteger) deviceID{
    for(FLYDevice * device in self.deviceStore) {
        if (device.deviceID.integerValue == deviceID) {
            return device;
        }
    }
    return nil;
}

- (void) saveDevice: (FLYDevice*)deviceSave {
    [self removeDevice:deviceSave];
    [self.deviceStore addObject:deviceSave];

}

-(void) removeDevice: (FLYDevice*)deviceRemove {
    if ([self isInDeviceStore:deviceRemove.deviceID.integerValue]) {
        for(FLYDevice * device in self.deviceStore) {
            if (device.deviceID.integerValue == deviceRemove.deviceID.integerValue) {
                [self.deviceStore removeObject:device];
            }
        }
    }
}
-(void) removeAllDevices {
    self.deviceStore = nil;
    self.deviceStore = [[NSMutableArray alloc] init];
}

- (void) createDevice:(NSInteger)deviceID sensorCount:(NSInteger)count {
    
    if (![self.deviceStore count]) {
        self.deviceStore = [[NSMutableArray alloc] init];
    }
    
    FLYDevice * device = [[FLYDevice alloc] init];
    device.deviceID = [NSNumber numberWithInteger:deviceID];
    device.deviceCount = [NSNumber numberWithInteger:count];
    device.dataStores = [[NSMutableArray alloc] init];
    [device.dataStores addObject: [[NSMutableArray alloc] init] ]; //TimeStamp
    
    for (int a = 0 ; a < count; a ++) {
        [device.dataStores addObject: [[NSMutableArray alloc]init] ]; //DataPoints
    }
    [self saveDevice:device];
}
- (void) storeData: (NSDate*)date device: (NSInteger)deviceID data: (unsigned char *)data length:(NSInteger)length {
    
    FLYDevice * device = [self getDeviceByID:deviceID];
    NSMutableArray * dataStructure = device.dataStores;
    
    [[dataStructure objectAtIndex:0] addObject:date];
    
    
    NSInteger length_sensors = length - 2;

    int i = 1;  // index for the data structure
    for (int a = 2; a < length_sensors; a++) {
        UInt16 SensorID = data[a];
        a++;
        UInt16 SensorData = data[a];
        [[dataStructure objectAtIndex:i] addObject:[NSNumber numberWithInteger:SensorData]];
        NSLog(@"Device: %ld Sensor: %d Logged: %d", (long)deviceID, SensorID, SensorData);
        i++;
    }

    [self saveDevice:device];
    
}
- (void)storeFilePath:(NSString *)path {
    self.filepath = path;
}
- (void) resetDevices {
    
}
-(void)storeDuration:(NSInteger)sec {
    self.duration = [NSNumber numberWithInteger:sec];
}
-(void)storeSampleRate:(NSInteger)sampleRate {
    float sampleRateSec = (float)sampleRate/1000.0f;
    float frequency = 1.0f/sampleRateSec;
    self.sample = [NSNumber numberWithFloat:frequency];
    
}
-(NSInteger)getSensorCount {
    NSInteger finalSensorCount = 0;
    for (FLYDevice * device in self.deviceStore ) {
        finalSensorCount += ([device.dataStores count] - 1);
    }
    return finalSensorCount;
}
@end
