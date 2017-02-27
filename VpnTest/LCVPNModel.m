//
//  LCVPNModel.m
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "LCVPNModel.h"

@implementation LCVPNModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupForDefault];//for test
    }
    
    return self;
}
-(void)setupForDefault{
    
    self.adress = @"m2.gouvpn.com";
    self.account = @"8110";
    self.password = @"4936";
    self.groupKey = @"fungou";
    self.demandEnabled = NO;
    self.autoReconnect = YES;
    self.type = 0;//IPSec
}


-(void)dealloc
{
    self.adress = nil;
    self.account = nil;
    self.password = nil;
    self.groupKey = nil;
}
@end
