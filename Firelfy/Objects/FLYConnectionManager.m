//
//  FLYConnectionManager.m
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYConnectionManager.h"
@implementation FLYConnectionManager

+ (FLYConnectionManager*)sharedInstance {
    static dispatch_once_t _singletonPredicate;
    static FLYConnectionManager *_singleton = nil;
    
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    

    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (void) setupNotifications {

    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanForDevices)
                                                 name:@"scanForDevices"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isReady)
                                                 name:@"isReady"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectToDevice:)
                                                 name:@"connectToDevice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectFromDevice:)
                                                 name:@"disconnectFromDevice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllDevices:)
                                                 name:@"removeAllDevices"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(writeStart)
                                                 name:@"start"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(writeStop)
                                                 name:@"stop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(writeReset)
                                                 name:@"reset"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(writeSample:)
                                                 name:@"sample"
                                               object:nil];
    
    DEVICE_MANAGER = [FLYDeviceManager sharedInstance];

    




}

#pragma mark - Recieve Notifications
-(void)scanForDevices {
    
    NSLog(@"Beginning scan for devices");
    CBCentralManager* testBluetooth = [[CBCentralManager alloc] initWithDelegate:nil queue: nil];
    NSLog(@"%d state for CBCentralManager", [testBluetooth state]);
    
    // Get the Periperal List
    CBPeripheral *peripheral = bleShield.activePeripheral;
    NSInteger i = bleShield.activePeripheral.state;
    
    if ((i == 0) && (peripheral == nil)) {
        [bleShield findBLEPeripherals:3];
    }
}

-(void)connectToDevice:(NSNotification*)notif {
    NSInteger row = [((NSIndexPath*)[[notif userInfo] objectForKey:@"deviceID"]) row];
    periph = [self.listOfPeripherals objectAtIndex:row];
    [bleShield connectPeripheral:periph];
    
}
-(void)disconnectFromDevice:(NSNotification*)notif {
    NSInteger row = [((NSIndexPath*)[[notif userInfo] objectForKey:@"deviceID"]) row];
    periph = [self.listOfPeripherals objectAtIndex:row];
    [[bleShield CM] cancelPeripheralConnection:periph];
    
}
-(void)removeAllDevices:(NSNotification*)notif {
    NSArray * devices = [[notif userInfo] objectForKey:@"devices"];
    for( CBPeripheral * p in devices) {
        [[bleShield CM] cancelPeripheralConnection:p];
    }
}

-(void)isReady {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionReady" object:self userInfo:nil];
}

#pragma mark - RedBear Writing Methods
-(void)writeStart {
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [bleShield write:data];
}

-(void)writeStop {
    UInt8 buf[3] = {0x02, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [bleShield write:data];
}

-(void)writeReset {
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [bleShield write:data];
}
-(void)writeSample:(NSNotification*) notif {
    NSInteger val = ((NSString*)[[notif userInfo] objectForKey:@"values"]).integerValue;
    UInt8 buf[3] = {0x04, 0x01, 0x00};
    buf[1] = val;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [bleShield write:data];
}
-(void)writeSensor {
    UInt8 buf[3] = {0x05, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [bleShield write:data];
}

#pragma mark - RedBear BLE Module Methods
-(void) bleDidUpdateRSSI:(NSNumber *)rssi {
    
}
-(void)bleDidFindDevice {
    self.listOfPeripherals = bleShield.peripherals;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"devicesFound" object:self userInfo:@{@"devices": self.listOfPeripherals}];
}

-(void)bleDidDisconnect {
    NSLog(@"bleDidDisconnect Fired");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:nil];
    
}
-(void)bleDidConnect {
    NSLog(@"bleDidConnect Fired");
    
    [bleShield getAllServicesFromPeripheral:bleShield.activePeripheral];
    [bleShield getAllCharacteristicsFromPeripheral:bleShield.activePeripheral];
    
    NSArray * services = bleShield.activePeripheral.services;
    NSLog(@"These are services: %@", services);
    
    // Get the number and name of sensors
    [self writeSensor];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:nil];
    
}
-(void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    
    NSLog(@"Length: %d", length);
    
    // if the message is about sensor count
    if (data[0] == 0x05) {
        UInt16 sensorCount = data[2];
        
        NSLog(@"Recieved - Device: %d SensorCount:%d", data[1], sensorCount);
        
        // Create the Devices
        if(![DEVICE_MANAGER isInDeviceStore:data[1]]) {
            [DEVICE_MANAGER createDevice:data[1] sensorCount:sensorCount];
        }
    }
    
    // if the message is about data
    if (data[0] == 0x06) {
        if ([DEVICE_MANAGER isInDeviceStore:data[1]]) {
            [DEVICE_MANAGER storeData: [NSDate date] device: data[1] data: data length:length];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGraph" object:self];
        }
    }
    
}

@end
