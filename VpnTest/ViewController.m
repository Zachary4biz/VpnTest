//
//  ViewController.m
//  VpnTest
//
//  Created by Pellet Mo on 15/12/14.
//  Copyright © 2015年 APUS. All rights reserved.
//

#import "ViewController.h"
#import "MoVPNManage.h"
#import <NetworkExtension/NetworkExtension.h>

#import "LCVPNViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *vpnBtn = [UIButton new];
    vpnBtn.frame = CGRectMake(0, 0, 150, 50);
    vpnBtn.center = self.view.center;
    vpnBtn.backgroundColor = [UIColor purpleColor];
    [vpnBtn setTitle:@"vpn settings" forState:UIControlStateNormal];
    [vpnBtn addTarget:self action:@selector(vpnBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vpnBtn];
    
    UIButton *testBtn = [UIButton new];
    testBtn.frame = CGRectMake(CGRectGetMinX(vpnBtn.frame), CGRectGetMaxY(vpnBtn.frame), 150, 33);
    testBtn.backgroundColor = [UIColor cyanColor];
    [testBtn setTitle:@"learningBtn" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(clickTestBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    
    
  
    
    
    
//    // ios 9 参考
//    {
//        NETunnelProviderManager * manager = [[NETunnelProviderManager alloc] init];
//        NETunnelProviderProtocol * protocol = [[NETunnelProviderProtocol alloc] init];
//        protocol.providerBundleIdentifier = @"com.APUS.Vpn";
//        
//        protocol.providerConfiguration = @{@"key":@"value"};
//        protocol.serverAddress = @"server";
//        manager.protocolConfiguration = protocol;
//        [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
//            
//        }];
//        
//        NETunnelProviderSession * session = (NETunnelProviderSession *)manager.connection;
//        NSDictionary * options = @{@"key" : @"value"};
//        
//        NSError * err;
//        [session startTunnelWithOptions:options andReturnError:&err];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"%ld",(long)manager.connection.status);
//        });
//    }
    
}


- (void)clickTestBtn:(id)sender
{
//    NEVPNManager *manager = [NEVPNManager sharedManager];
//    [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"load er - %@",error);
//        }else{
//            NEVPNProtocolIKEv2 *IKEv2Protocol = [[NEVPNProtocolIKEv2 alloc]init];
//            IKEv2Protocol.username = @"MyUserName";
//            IKEv2Protocol.passwordReference = 
//
//            
//        }
//    }];
}




-(void)vpnBtnTapped:(id)sender {
    
    LCVPNViewController *vc = [[LCVPNViewController alloc]init];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 操作方法 BEGIN
- (IBAction)buttonPressed:(id)sender {
    [[MoVPNManage shareVPNManage] vpnStart];
}
- (IBAction)buttonStop:(id)sender {
    [[MoVPNManage shareVPNManage] vpnStop];
}

@end
