//
//  FLYChartViewController.m
//  Firelfy
//
//  Created by James Tan on 4/10/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYChartViewController.h"

@interface FLYChartViewController ()

@end

@implementation FLYChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.graphArea.bounds];
    self.graphArea.hostedGraph = graph;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 50 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )]];
    
    CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace2.allowsUserInteraction = YES;

    xmin = -4;
    xmax = 8;
    
    // Create the color array
    colorArray = [[NSMutableArray alloc] init];
    CPTColor * red = [CPTColor colorWithComponentRed:221.0f/255.0f green:27.0f/255.0f blue:27.0f/255.0f alpha:1.0];
    CPTColor * yellow = [CPTColor colorWithComponentRed:243.0f/255.0f green:229.0f/255.0f blue:129.0f/255.0f alpha:1.0];
    CPTColor * blue = [CPTColor colorWithComponentRed:105.0f/255.0f green:210.0f/255.0f blue:231.0f/255.0f alpha:1.0];
    CPTColor * white = [CPTColor colorWithComponentRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0];
    CPTColor * orange = [CPTColor colorWithComponentRed:235.0f/255.0f green:89.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    CPTColor * lightBlue = [CPTColor colorWithComponentRed:167.0f/255.0f green:219.0f/255.0f blue:216.0f/255.0f alpha:1.0];
    [colorArray addObjectsFromArray:@[red, yellow, blue, white, orange, lightBlue]];
    
    
    // Setup the Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGraph)
                                                 name:@"updateGraph"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    

    wasStarted = FALSE;
}

-(void)viewWillAppear:(BOOL)animated {
    // Get Number of Devices
    DEVICE_MANAGER = ((FLYDeviceManager*)[FLYDeviceManager sharedInstance]);
    deviceCount = [DEVICE_MANAGER.deviceStore count];
    
    // For Each Device, get the count
    for (FLYDevice * device in DEVICE_MANAGER.deviceStore) {
        int d = device.deviceCount.integerValue;
        for (int a = 0; a < d; a++) {
            
            // Create the Plot
            CPTScatterPlot * plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
            plot.dataSource = device;
            
            // Identify the Plot
            NSString *plotName = [NSString stringWithFormat:@"%d - %d",device.deviceID.integerValue, a ];
            plot.name = plotName;
            
            // Style the Plot Line
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.miterLimit        = .7;
            lineStyle.lineWidth         = .7;
            lineStyle.lineColor         = [colorArray objectAtIndex:a];
            plot.dataLineStyle = lineStyle;

            // Style the Plot Symbol
            CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
            symbolLineStyle.lineColor = [colorArray objectAtIndex:a];
            CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
            plotSymbol.fill          = [CPTFill fillWithColor:[colorArray objectAtIndex:a]];
            plotSymbol.lineStyle     = symbolLineStyle;
            plotSymbol.size          = CGSizeMake(5.0, 5.0);
            plot.plotSymbol = plotSymbol;

            
            
            [self.graphArea.hostedGraph addPlot:plot];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) updateGraph {
    [self.graphArea.hostedGraph reloadData];
    
    // Calculate the Range Movement
    NSInteger  count = [[((FLYDevice*)[DEVICE_MANAGER.deviceStore firstObject]).dataStores firstObject] count];
    CPTXYPlotSpace * plotspace = (CPTXYPlotSpace *) self.graphArea.hostedGraph.defaultPlotSpace;
    xmax = 10.0;
    [plotspace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( (float)(count-10) ) length:CPTDecimalFromFloat( xmax )]];
    
    // Calculate the Duration of the sample
    NSInteger samplingRate = self.statusField.text.integerValue;
    float duration = count * (samplingRate/1000); // divide 1000 because milliseconds
    NSString * durationString = [NSString stringWithFormat:@"%3.2fs", duration];
    [self.durationLabel setText:durationString];

}

#pragma mark IBAction Methods
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated {

}

- (IBAction)goSave:(id)sender {
    
    // Turn off the Streaming
    if (self.startButton.isSelected) {
        [self toggleChartStopStart:self.startButton];
    }
    
    if (!wasStarted) {
        [[[UIAlertView alloc] initWithTitle:@"Unable to Save" message:@"No data was collected! Please record a run before saving." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    } else {
        [DEVICE_MANAGER storeSampleRate:self.statusField.text.integerValue];
        [DEVICE_MANAGER storeDuration:self.durationLabel.text.integerValue];
        [self performSegueWithIdentifier:@"push_save" sender:self];
    }
}

- (IBAction)startChart:(id)sender {
    // delay is in ms, 1000ms per s
    wasStarted = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:self userInfo:@{@"sampleRate":self.statusField.text}];
    [self.statusLabel setText:@"recording"];
    
    [self.statusField setUserInteractionEnabled:FALSE];
}

- (IBAction)stopChart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:self userInfo:nil];
    [self.statusLabel setText:@"paused"];
    
    [self.statusField setUserInteractionEnabled:YES];

}

- (IBAction)toggleChartStopStart:(UIButton *)sender {
    if (!sender.selected) {
        [self startChart:self];
        [sender setSelected:TRUE];
    } else {
        [self stopChart:self];
        [sender setSelected:FALSE];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.statusField resignFirstResponder];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Determine Up
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    NSInteger upAmount = 120;
    if (screenHeight == 568) {
        upAmount = 215;
    }
    //Assign new frame to your view
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setFrame:CGRectMake(0,-upAmount,320,screenHeight)];
                     }
                     completion: ^(BOOL finished) {
                         
                     }
     ];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setFrame:CGRectMake(0,0,320,568)];
                     }
                     completion: ^(BOOL finished) {
                         
                     }
     ];
}


@end
