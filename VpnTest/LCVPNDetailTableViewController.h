//
//  LCVPNTableViewController.h
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCVPNModel;

@protocol LCVPNDetailTableViewControllerDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)switchedSaveTabIsOn:(BOOL)isOn;

@end



@interface LCVPNDetailTableViewController : UITableViewController

@property (nonatomic,assign) id<LCVPNDetailTableViewControllerDelegate> delegate;
@property (nonatomic, strong) LCVPNModel *vpnModel;

//-(NSString *)getVPNAdress;
//-(NSString *)getVPNAccount;
//-(NSString *)getVPNPassword;
//-(NSString *)getVPNGroupKey;

@end
