//
//  FLYSplashViewController.m
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYSplashViewController.h"

@interface FLYSplashViewController ()

@end

@implementation FLYSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

}
-(void)viewDidAppear:(BOOL)animated {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        UIImage * img = [UIImage imageNamed:@"bee@2x_highlighted.png"];
//        UIImage *imgOff = [UIImage imageNamed:@"bee@2x.png"];
//        
//        // Make a trivial (1x1) graphics context, and draw the image into it
//        UIGraphicsBeginImageContext(CGSizeMake(1,1));
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
//        UIGraphicsEndImageContext();
//        
//        UIGraphicsBeginImageContext(CGSizeMake(1,1));
//        CGContextRef context2 = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context2, CGRectMake(0, 0, 1, 1), [imgOff CGImage]);
//        UIGraphicsEndImageContext();
//
//        
//        // Now the image will have been loaded and decoded and is ready to rock for the main thread
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            while (TRUE) {
//                int randNum = rand() % (4 - 1) + 1; //create the random number.
//                
//                [self.fireflyImage setImage:img];
//                [NSThread sleepForTimeInterval:randNum];
//                [self.fireflyImage setImage:imgOff];
//                [NSThread sleepForTimeInterval:randNum];
//                
//                
//                
//            }
//
//            [self.fireflyImage setImage:img];
//        });
//    });
//
    
}
//- (void)flicker {
//    while (TRUE) {
//        int randNum = rand() % (4 - 1) + 1; //create the random number.
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"flickOn" object:self];
//        [NSThread sleepForTimeInterval:randNum];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"flickOff" object:self];
//        [NSThread sleepForTimeInterval:randNum];
//
//
//
//    }
//    
//    
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[FLYUtility sharedInstance] setButtonRounded:self.caseNewButton];
    [[FLYUtility sharedInstance] setButtonRounded:self.caseExistingButton];

    highlight = [UIImage imageNamed:@"bee@2x_highlighted.png"];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(flickOn)
//                                                 name:@"flickOn"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(flickOff)
//                                                 name:@"flickOff"
//                                               object:nil];

}

//-(void)flickOn {
//
//    [self.fireflyImage setImage:highlight];
//    
//}
//-(void)flickOff {
//    [self.fireflyImage setImage:highlight];
//
//    
//}
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

- (IBAction)startNewCase:(id)sender {
    [self performSegueWithIdentifier:@"pushNew" sender:self];
    
}

- (IBAction)openExistingCase:(id)sender {
//    [self performSegueWithIdentifier:@"pushOpen" sender:self];
    [[[UIAlertView alloc] initWithTitle:@"Not ready!" message:@"Sorry, this feature isn't ready yet! Check back soon!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
