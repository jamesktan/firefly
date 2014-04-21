//
//  FLYUtility.m
//  Firelfy
//
//  Created by James Tan on 4/21/14.
//  Copyright (c) 2014 TanChen. All rights reserved.
//

#import "FLYUtility.h"

@implementation FLYUtility

+ (FLYUtility*)sharedInstance {
    static dispatch_once_t _singletonPredicate;
    static FLYUtility *_singleton = nil;
    
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    
    
    return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

-(UIButton*)setButtonRounded:(UIButton *)button {
    [button.layer setBorderColor:[button.backgroundColor CGColor]];
    [button.layer setBorderWidth: 1.0];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    return button;
}
@end
