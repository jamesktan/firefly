//
//  FLYCaseManager.m
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYCaseManager.h"

@implementation FLYCaseManager

+ (FLYCaseManager*)sharedInstance {
    static dispatch_once_t _singletonPredicate;
    static FLYCaseManager *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (void) setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isReady)
                                                 name:@"isReady"
                                               object:nil];
    
}
-(void)isReady {
    if (TRUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"caseReady" object:self userInfo:nil];
    }
}

-(void)setupData: (NSInteger)device sensorCount: (NSInteger)count {
    
}
-(void)captureData: (NSInteger)device sensor: (NSInteger)sensor data: (NSInteger)data {
    
}


@end
