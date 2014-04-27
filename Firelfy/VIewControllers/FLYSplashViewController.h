//
//  FLYSplashViewController.h
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLYUtility.h"
@interface FLYSplashViewController : UIViewController {
    BOOL connectionReady;
    BOOL caseReady;
    UIImage * highlight;
}

@property (strong, nonatomic) IBOutlet UILabel *splashTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fireflyImage;

@property (strong, nonatomic) IBOutlet UIButton *caseExistingButton;
@property (strong, nonatomic) IBOutlet UIButton *caseNewButton;

- (IBAction)startNewCase:(id)sender;
- (IBAction)openExistingCase:(id)sender;


@end
