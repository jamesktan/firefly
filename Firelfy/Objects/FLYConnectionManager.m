//
//  FLYConnectionManager.m
//  Firelfy
//
//  Created by James Tan on 4/9/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYConnectionManager.h"

@implementation FLYConnectionManager

+ (FLYConnectionManager*)sharedInstance {
    static dispatch_once_t _singletonPredicate;
    static FLYConnectionManager *_singleton = nil;
    
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
                                             selector:@selector(scanForDevices)
                                                 name:@"scanForDevices"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isReady)
                                                 name:@"isReady"
                                               object:nil];
    

}


-(void)scanForDevices {
    
}

-(void)isReady {
    if (TRUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionReady" object:self userInfo:nil];
    }
}
@end
