//
//  FLYChartViewController.h
//  Firelfy
//
//  Created by James Tan on 4/10/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "FLYDeviceManager.h"

@interface FLYChartViewController : UIViewController {
    int xmin, xmax;
    int deviceCount;
    NSMutableArray *colorArray;
    FLYDeviceManager * DEVICE_MANAGER;
}

// Nav Buttons
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

// Recording Buttons
@property (strong, nonatomic) IBOutlet UIButton *startButton;

// Sample Rate
@property (strong, nonatomic) IBOutlet UITextField *statusField;

// Graphing Area
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphArea;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceCountLabel;

- (IBAction)goBack:(id)sender;
- (IBAction)goSave:(id)sender;
- (IBAction)startChart:(id)sender;
- (IBAction)stopChart:(id)sender;
- (IBAction)toggleChartStopStart:(UIButton *)sender;


@end
