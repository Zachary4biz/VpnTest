//
//  LCVPNTableViewController.h
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCVPNModel;

@protocol LCVPNTableViewControllerDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)switchedSaveTabIsOn:(BOOL)isOn;

@end



@interface LCVPNTableViewController : UITableViewController

@property (nonatomic,strong) LCVPNModel *vpnModel;
@property (nonatomic,assign) id<LCVPNTableViewControllerDelegate> delegate;



@end
