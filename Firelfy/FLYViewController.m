//
//  FLYViewController.m
//  Firelfy
//
//  Created by James Tan on 3/27/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYViewController.h"

@interface FLYViewController ()

@end

@implementation FLYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanDevices:(UIButton *)sender {
    /*
     scanDevices
     IBAction associated with the frontend to discover devices
     */
    
    CBPeripheral *peripheral = bleShield.activePeripheral;
    NSInteger i = bleShield.activePeripheral.state;
    
    if ((i == 0) && (peripheral == nil)) {
        [bleShield findBLEPeripherals:3];
    }

}

- (IBAction)connectPeripheral:(UIButton *)sender {
    /*
     connectPeripheral
     IBAction associated with a connection attempt
     */

    NSLog(@"///////////////////////////");
    NSLog(@"Connecting...");
    [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    
    CBPeripheral *peripheral = bleShield.activePeripheral;
    NSInteger i = bleShield.activePeripheral.state;
    if ((i != 0) && (peripheral != nil)) {
        NSLog(@"Successfully connected....");
        self.deviceID.text = [bleShield.activePeripheral.identifier UUIDString];
    }
    

}

- (IBAction)disconnectPeripheral:(UIButton *)sender {
    NSLog(@"///////////////////////////");
    NSLog(@"Disconnecting...");

    [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
    
}
-(void)bleDidDisconnect {
    NSLog(@"bleDidDisconnect Fired");
    self.disconnectButton.hidden = TRUE;
    self.deviceID.text = @"";

    
    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Device disconnected!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];

}
-(void)bleDidConnect {
    NSLog(@"bleDidConnect Fired");
    self.disconnectButton.hidden = FALSE;
    
    [bleShield getAllServicesFromPeripheral:bleShield.activePeripheral];
    [bleShield getAllCharacteristicsFromPeripheral:bleShield.activePeripheral];
    
    NSArray * services = bleShield.activePeripheral.services;
    NSLog(@"These are services: %@", services);
    
}
-(void)bleDidFindDevice {
    NSArray * listOfPeripherals = bleShield.peripherals;
    
    if ([listOfPeripherals count]) {
        periph= [listOfPeripherals objectAtIndex:0];
        self.deviceName.text = periph.name;
        self.connectButton.hidden = FALSE;
    }

}
-(void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
}
-(void) bleDidUpdateRSSI:(NSNumber *)rssi {
    
}

@end
