//
//  FLYLoadViewController.m
//  Firelfy
//
//  Created by James Tan on 5/2/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYLoadViewController.h"

@interface FLYLoadViewController ()

@end

@implementation FLYLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSArray *dirList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    self.fileList = dirList;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.existingCaseTable.delegate = self;
    self.existingCaseTable.dataSource = self;
    
    selectedFiles = [[NSMutableArray alloc] init];
    
    DEVICE_MANAGER = [FLYDeviceManager sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)getRunName: (NSString*)filename {
    NSString * runName = [[filename componentsSeparatedByString:@"_"] objectAtIndex:0];
    return runName;
}

-(BOOL)checkListForCompleteness:(NSMutableArray*)selected masterList:(NSArray*)masterList {
    NSString * prefix = [self getRunName:[selectedFiles firstObject]];
    for (NSString * filename in masterList) {
        if (![[self getRunName:filename] isEqualToString:prefix]) {
            return FALSE;
        }
    }
    return TRUE;
}

-(BOOL)checkForSameName:(NSMutableArray*)inputArray {
    NSString *beginning;
    for (NSString * filename in inputArray) {
        if ((beginning != nil) && (![beginning isEqualToString:filename])) {
            return FALSE; // exit if not nil and there is a mismatch
        }
        beginning = [self getRunName:filename];
    }
    return TRUE;
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

- (IBAction)loadChart:(id)sender {
    if ([selectedFiles count] == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must select a file before proceeding." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    } else {
        BOOL proceed = TRUE;
        if (![self checkForSameName:selectedFiles]) {
            proceed = FALSE;
        }
        if (![self checkListForCompleteness:selectedFiles masterList:self.fileList]) {
            proceed = FALSE;
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select all the devices in this run before proceeding" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        }
        if (proceed) {
            [self performSegueWithIdentifier:@"push_monitor_existing" sender:self];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableViewDelegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fileList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = self.titleLabel.font;
    cell.detailTextLabel.font = self.titleLabel.font;

    [cell.textLabel setText:[self.fileList objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText: [DEVICE_MANAGER getFileCreationDate: [self.fileList objectAtIndex:indexPath.row ]]];
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = self.titleLabel.font;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [selectedFiles removeObjectIdenticalTo:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        [selectedFiles addObject:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setTintColor:[UIColor whiteColor]];
        
    }
    NSLog(@"Available files: %@", selectedFiles);

}

#pragma mark - PrepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"push_monitor_existing"]) {
        [DEVICE_MANAGER loadStoredData:selectedFiles];
    }
}
@end
