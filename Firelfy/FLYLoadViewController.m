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
    
    DEVICE_MANAGER = [FLYDeviceManager sharedInstance];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
                
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setTintColor:[UIColor whiteColor]];
        
    }

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"push_monitor_existing"]) {
        [DEVICE_MANAGER loadStoredData:[self.fileList objectAtIndex:selectedIndex]];
    }
}
@end
