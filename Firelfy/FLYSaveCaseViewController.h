//
//  FLYSaveCaseViewController.h
//  Firelfy
//
//  Created by James Tan on 4/24/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYDeviceManager.h"
#import "FLYUtility.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface FLYSaveCaseViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    FLYDeviceManager * DEVICE_MANAGER;
    NSString * savedTempPath;
    NSMutableArray * tempFilePaths;
}

// Action
- (IBAction)goBack:(id)sender;
- (IBAction)goFinish:(id)sender;
- (IBAction)sendData:(id)sender;
- (IBAction)didEndOnExit:(id)sender;
- (IBAction)runNameChanged:(id)sender;

// Button
@property (strong, nonatomic) IBOutlet UIButton *sendDataButton;

// TextField
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

// Label
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *filesizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *sensorCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *sampleLabel;

@end
