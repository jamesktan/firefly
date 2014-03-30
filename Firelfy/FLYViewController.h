//
//  FLYViewController.h
//  Firelfy
//
//  Created by James Tan on 3/27/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "BLE.h"
#import <UIKit/UIKit.h>

@interface FLYViewController : UIViewController <BLEDelegate> {
    BLE *bleShield;
    CBPeripheral *periph;

}
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UIButton *disconnectButton;
@property (strong, nonatomic) IBOutlet UILabel *deviceID;


- (IBAction)scanDevices:(UIButton *)sender;
- (IBAction)connectPeripheral:(UIButton *)sender;
- (IBAction)disconnectPeripheral:(UIButton *)sender;

@end
