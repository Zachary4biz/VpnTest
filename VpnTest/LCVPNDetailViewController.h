//
//  LCVPNDetailViewController.h
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCVPNModel;
@interface LCVPNDetailViewController : UIViewController

@property (nonatomic, strong) LCVPNModel *vpnModel;

-(instancetype)initWithVPNModel:(LCVPNModel *)vpnModel;

@end
