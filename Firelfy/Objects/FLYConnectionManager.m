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

#pragma mark - RedBear BLE Module Methods

-(void)bleDidFindDevice {
    /*
     bleDidFindDevice
     Delegate method letting the controller know that the device has been found.
     */
    
    self.listOfPeripherals = bleShield.peripherals;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"devicesFound" object:self userInfo:@{@"devices": self.listOfPeripherals}];
}

-(void)bleDidDisconnect {
    /*
     bleDidDisconnect
     Delegate method letting the controller know that the device was disconnected!
     */
    NSLog(@"bleDidDisconnect Fired");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:nil];
    
}
-(void)bleDidConnect {
    /*
     bleDidConnect
     Delegate method letting the controller know that the device connected successfully
     */
    NSLog(@"bleDidConnect Fired");
    
//    [bleShield getAllServicesFromPeripheral:bleShield.activePeripheral];
//    [bleShield getAllCharacteristicsFromPeripheral:bleShield.activePeripheral];
    
//    NSArray * services = bleShield.activePeripheral.services;
//    NSLog(@"These are services: %@", services);
    
    // Get the number and name of sensors
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFinished" object:self userInfo:nil];
    
}

@end
