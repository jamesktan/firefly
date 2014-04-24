//
//  FLYSaveCaseViewController.m
//  Firelfy
//
//  Created by James Tan on 4/24/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYSaveCaseViewController.h"

@interface FLYSaveCaseViewController ()

@end

@implementation FLYSaveCaseViewController

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
    DEVICE_MANAGER = [FLYDeviceManager sharedInstance];
    
    [((FLYUtility*)[FLYUtility sharedInstance]) setButtonRounded:self.sendDataButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goFinish:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendData:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setToRecipients:@[@"jamesktan@gmail.com"]];
    [controller setSubject:[NSString stringWithFormat:@"Firefly Run: %@", self.nameTextField.text]];
    [controller setMessageBody:@"Attached is the data you requested!" isHTML:NO];
    
    
    NSData *noteData = [NSData dataWithContentsOfFile:DEVICE_MANAGER.filepath];
    [controller addAttachmentData:noteData mimeType:@"text/plain" fileName:@"example.plist"];

    
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.emailTextfield resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Thank you for sending your data!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
