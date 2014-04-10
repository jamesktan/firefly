//
//  FLYCaseManager.h
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLYCaseManager : NSObject

+ (id) sharedInstance;
- (void) setupNotifications;

@end
