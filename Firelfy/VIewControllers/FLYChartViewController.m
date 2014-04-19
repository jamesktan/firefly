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
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 16 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -4 ) length:CPTDecimalFromFloat( 8 )]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGraph)
                                                 name:@"updateGraph"
                                               object:nil];

    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
//    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
//    CPTScatterPlot * plot2 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
//    plot2.name = @"HELLO";
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
//    plot.dataSource = self;
//    plot2.dataSource = self;
    
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
//    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
//    [graph addPlot:plot2 toPlotSpace:graph.defaultPlotSpace];
    
    CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace2.allowsUserInteraction = YES;

    xmin = -4;
    xmax = 8;


}

-(void)viewWillAppear:(BOOL)animated {
    // Get Number of Devices
    FLYDeviceManager * DEVICE_MANAGER = ((FLYDeviceManager*)[FLYDeviceManager sharedInstance]);
    deviceCount = [DEVICE_MANAGER.deviceStore count];
    
    // For Each Device, get the count
    for (FLYDevice * device in DEVICE_MANAGER.deviceStore) {
        int d = device.deviceCount.integerValue;
        for (int a = 0; a < d; a++) {
            CPTScatterPlot * plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
            
            plot.dataSource = device;
            
            NSString *plotName = [NSString stringWithFormat:@"%d - %d",device.deviceID.integerValue, a ];
            plot.name = plotName;
            
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
}

#pragma mark IBAction Methods
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated {

}

- (IBAction)goSave:(id)sender {
//    NSLog(@"Save Pressed");
//    CPTXYPlotSpace * plotspace = (CPTXYPlotSpace *) self.graphArea.hostedGraph.defaultPlotSpace;
//    xmin += 1;
//    xmax += 1;
//    [plotspace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( xmin ) length:CPTDecimalFromFloat( xmax )]];

    
    
}

- (IBAction)resetChart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reset" object:self userInfo:nil];
}

- (IBAction)startChart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"start" object:self userInfo:nil];
}

- (IBAction)stopChart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:self userInfo:nil];
}

- (IBAction)markChart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sample" object:self userInfo:@{@"values":self.statusField.text}];
}

//#pragma mark - Core Plot Datasource methods
//
//// This method is here because this class also functions as datasource for our graph
//// Therefore this class implements the CPTPlotDataSource protocol
//-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
//    return 9; // Our sample graph contains 9 'points'
//}
//
//// This method is here because this class also functions as datasource for our graph
//// Therefore this class implements the CPTPlotDataSource protocol
//-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
//{
//    if ([plot.name isEqualToString: @"HELLO"]) {
//        // We need to provide an X or Y (this method will be called for each) value for every index
//        int x = index - 4;
//        
//        // This method is actually called twice per point in the plot, one for the X and one for the Y value
//        if(fieldEnum == CPTScatterPlotFieldX)
//        {
//            // Return x value, which will, depending on index, be between -4 to 4
//            return [NSNumber numberWithInt: x ];
//        } else {
//            // Return y value, for this example we'll be plotting y = x * x
//            return [NSNumber numberWithInt: x * x + 5];
//        }
//    }
//    // We need to provide an X or Y (this method will be called for each) value for every index
//    int x = index - 4;
//    
//    // This method is actually called twice per point in the plot, one for the X and one for the Y value
//    if(fieldEnum == CPTScatterPlotFieldX)
//    {
//        // Return x value, which will, depending on index, be between -4 to 4
//        return [NSNumber numberWithInt: x];
//    } else {
//        // Return y value, for this example we'll be plotting y = x * x
//        return [NSNumber numberWithInt: x * x];
//    }
//}
@end
