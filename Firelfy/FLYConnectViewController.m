//
//  FLYConnectViewController.m
//  Firelfy
//
//  Created by James Tan on 4/10/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYConnectViewController.h"

@interface FLYConnectViewController ()

@end

@implementation FLYConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {

}
- (void)viewDidLoad
{
    [[FLYUtility sharedInstance] setButtonRounded:self.scanButton];
    [[FLYUtility sharedInstance] setButtonRounded:self.continueButton];
    connectedDevices = 0;
    
    self.deviceTable.delegate = self;
    self.deviceTable.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(devicesFound:)
                                                 name:@"devicesFound"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionChangeFinished)
                                                 name:@"connectionFinished"
                                               object:nil];

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
#pragma mark - IBActions
- (IBAction)goBack:(id)sender {
    if (connectedDevices > 0) {
        [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"If you go back now, you will disconnect from all your bluetooth devices." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go Ahead", nil] show];
    } else {
        [self disconnectFromAllDevices];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)scanDevices:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scanForDevices" object:self userInfo:nil];
}
- (IBAction)goChart:(id)sender {
    if (connectedDevices > 0) {
        [self performSegueWithIdentifier:@"push_monitor" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You cannot continue until you connect at least 1 device." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
}
- (void) disconnectFromAllDevices {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeAllDevices" object:self userInfo:@{@"devices":devices}];
}

#pragma mark - Receive Notifications
-(void)devicesFound:(NSNotification *)notif {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    devices = [[notif userInfo] objectForKey:@"devices"];
    [self.deviceTable reloadData];
}

-(void)connectionChangeFinished {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UITableView Delegate and DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = ((CBPeripheral*)[devices objectAtIndex:indexPath.row]).name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        //Disconnect
        connectedDevices -= 1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnectFromDevice" object:self userInfo: @{@"devicePosition": indexPath}];
        cell.accessoryType = UITableViewCellAccessoryNone;

    } else {
        //Connect
        connectedDevices += 1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectToDevice" object:self userInfo: @{@"devicePosition": indexPath}];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Disconnect Prompt - Go ahead and disconnect devices.
        [self disconnectFromAllDevices];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
