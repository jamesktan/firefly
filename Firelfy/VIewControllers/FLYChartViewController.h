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
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *markButton;
@property (strong, nonatomic) IBOutlet UITextField *statusField;
@property (strong, nonatomic) IBOutlet UIScrollView *graphScroll;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphArea;

- (IBAction)goBack:(id)sender;
- (IBAction)goSave:(id)sender;
- (IBAction)resetChart:(id)sender;
- (IBAction)startChart:(id)sender;
- (IBAction)stopChart:(id)sender;
- (IBAction)markChart:(id)sender;


@end
