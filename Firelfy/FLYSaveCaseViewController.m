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

-(void)viewWillAppear:(BOOL)animated {
    
    // Save the Data
    [tempFilePaths removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    NSInteger devicesToSave = [DEVICE_MANAGER.deviceStore count];
    for (int a = 0; a < devicesToSave; a++) {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"testRun_%d.plist", a]]; //Add the file name
        [((FLYDevice*)[DEVICE_MANAGER.deviceStore objectAtIndex:a]).dataStores writeToFile:filePath atomically:YES]; //Write the file
        [tempFilePaths addObject:filePath];
    }
    
    // Size the data
    NSInteger fileSizeTotalBytes = 0;
    for (int a = 0; a < [tempFilePaths count]; a++) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[tempFilePaths objectAtIndex:a]   error:nil];
        fileSizeTotalBytes += [fileAttributes fileSize];
    }

    [self.filesizeLabel setText:[NSByteCountFormatter stringFromByteCount:fileSizeTotalBytes countStyle:NSByteCountFormatterCountStyleFile]];
    
    // Fetch the Duration
    [self.durationLabel setText: [NSString stringWithFormat:@"%@ sec", DEVICE_MANAGER.duration.stringValue]];
    
    // Fetch the Device Count
    [self.deviceCountLabel setText:[NSString stringWithFormat:@"%d",[DEVICE_MANAGER.deviceStore count]]];
    
    // Fetch the Sensor Count
    [self.sensorCountLabel setText:[NSString stringWithFormat:@"%d", [DEVICE_MANAGER getSensorCount]]];
    
    // Fetch the Sample Rate
    [self.sampleLabel setText:[NSString stringWithFormat:@"%.1f Hz",DEVICE_MANAGER.sample.floatValue]];
}

- (void)viewDidLoad
{
    DEVICE_MANAGER = [FLYDeviceManager sharedInstance];
    [((FLYUtility*)[FLYUtility sharedInstance]) setButtonRounded:self.sendDataButton];
    tempFilePaths = [[NSMutableArray alloc] init];
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
    if ([self.nameTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Save or Skip?" message:@"No Run Name was given, would you like to save or skip? If you skip you will lose your data."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Skip",nil] show];
    } else {
        [self saveFile];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)sendData:(id)sender {
    
    // Check the Inputs into the Modal View
    NSString * recipient = @"jamesktan@gmail.com";
    if (![self.emailTextfield.text isEqualToString:@""]) {
        recipient = self.emailTextfield.text;
    }
    
    NSString * runName = @"testRun";
    if (![self.nameTextField.text isEqualToString:@""]) {
        runName = self.nameTextField.text;
    }
    
    // Create the Body Text:
    NSString *body = [NSString stringWithFormat:@"Hi!\n\n This is Firefly, delivering data! Attached is the raw file.\n\n Thanks!\n firefly \n\n filename: %@ \n duration %@ \n filesize %@ \n sensorCount %@ \n deviceCount %@ \n sampleRate %@ \n", self.nameLabel.text, self.durationLabel.text, self.filesizeLabel.text, self.sensorCountLabel.text, self.deviceCountLabel.text, self.sampleLabel.text];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setToRecipients:@[recipient]];
    [controller setSubject:[NSString stringWithFormat:@"Firefly Run: %@", runName]];
    [controller setMessageBody:body isHTML:NO];
    
    for (int a = 0; a < [tempFilePaths count]; a++) {
        NSData *noteData = [NSData dataWithContentsOfFile:[tempFilePaths objectAtIndex:a ]];
        [controller addAttachmentData:noteData mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@_%d.plist", runName, a]];
    }
    
    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)didEndOnExit:(id)sender {
    [self.emailTextfield resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

- (IBAction)runNameChanged:(id)sender {
    NSString *s = [NSString stringWithFormat:@"%@.plist", self.nameTextField.text];
    [self.nameLabel setText:s];
}

-(void)saveFile {
    
    NSFileManager * fm = [[NSFileManager alloc] init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    for (int a = 0; a < [tempFilePaths count]; a++) {
        NSString *fileName = [NSString stringWithFormat:@"%@_%d.plist", self.nameTextField.text, a ];
        NSString * filePathFull = [documentsPath stringByAppendingPathComponent:fileName];
        [fm moveItemAtPath:[tempFilePaths objectAtIndex:a ] toPath:filePathFull error:nil];
        [fm removeItemAtPath:[tempFilePaths objectAtIndex:a ] error:nil];

    }
    
    // Remove a Legacy Thing
    [fm removeItemAtPath:[documentsPath stringByAppendingString:@"test.plist"] error:nil];
    


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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        [DEVICE_MANAGER resetDevices];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
