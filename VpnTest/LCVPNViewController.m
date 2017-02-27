//
//  LCVPNViewController.m
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "LCVPNViewController.h"
#import "LCVPNTableViewController.h"
#import "LCVPNModel.h"

#import "LCVPNDetailViewController.h"
#import "MoVPNManage.h"

#define NAVIGATIONBAR_HEIGHT 64

@interface LCVPNViewController ()<LCVPNTableViewControllerDelegate>

@property (nonatomic, strong) LCVPNTableViewController *tableViewController;
@property (nonatomic, strong) LCVPNModel *vpnModel;

@end

@implementation LCVPNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VPN";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"navigationController_rightButtonAction:")];
    [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
    
    LCVPNModel *vpnModel = [[LCVPNModel alloc]init];//应该从本地数据库读取
    self.vpnModel = vpnModel;
    [self prepareVPN];
    
    vpnModel.status = (int)[[MoVPNManage shareVPNManage] vpnStatus];
    
    [self refreshSwitchStatus:@"初始化"];
    
    LCVPNTableViewController *tableViewController = [[LCVPNTableViewController alloc]init];
    tableViewController.delegate = self;
    tableViewController.view.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-NAVIGATIONBAR_HEIGHT);
    [self addChildViewController:tableViewController];
    [tableViewController didMoveToParentViewController:self];
    [self.view addSubview:tableViewController.view];
    tableViewController.vpnModel = vpnModel;
    self.tableViewController = tableViewController;
    
    [self addNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableViewController.tableView reloadData];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeNotifications];
}

- (IBAction)navigationController_rightButtonAction:(id)sender {
    NSLog(@"navigationController_rightButtonAction");
    
    LCVPNDetailViewController *vc = [[LCVPNDetailViewController alloc]initWithVPNModel:self.vpnModel];
    vc.view.frame = self.view.bounds;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - vpn操作方法 手动打开关闭
-(void)prepareVPN{
    MoVPNManage * vpnManage = [MoVPNManage shareVPNManage];
    [vpnManage setVpnTitle:@"Akai Vpn"];
    //    [vpnManage setServer:@"108.61.180.50" ID:@"chenziqiang01" pwd:@"18607114709" privateKey:@"tksw123"];
    [vpnManage setServer:self.vpnModel.adress ID:self.vpnModel.account pwd:self.vpnModel.password privateKey:self.vpnModel.groupKey];
    [vpnManage setReconnect:YES];
    [vpnManage saveConfigCompleteHandle:^(BOOL success, NSString *returnInfo) {
        NSLog(@"%@",returnInfo);
        if (success) {
    //            [vpnManage vpnStart];//设置完毕自动打开
        }
    }];
    
    __weak typeof(self) wself = self;
    [vpnManage saveNetworkChangedHandle:^(LCVPNStatus VPNStatus) {
        NSString *VPNStatusText = @"";
        switch (VPNStatus) {
            case LCVPNStatusInvalid:
                VPNStatusText = @"未设置";
//                NSLog(@"NEVPNStatusInvalid The VPN is not configured.");
                break;
            case LCVPNStatusDisconnected:
                VPNStatusText = @"未连接";
//                NSLog(@"NEVPNStatusDisconnected The VPN is disconnected.");
                break;
            case LCVPNStatusConnecting:
                VPNStatusText = @"连接中";
//                NSLog(@"NEVPNStatusConnecting The VPN is connecting.");
                break;
            case LCVPNStatusConnected:
                VPNStatusText = @"已连接";
//                NSLog(@"NEVPNStatusConnected The VPN is connected.");
                break;
            case LCVPNStatusReasserting:
                VPNStatusText = @"重连中";
//                NSLog(@"NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.");
                break;
            case LCVPNStatusDisconnecting:
                VPNStatusText = @"断开中";
//                NSLog(@"NEVPNStatusDisconnecting The VPN is disconnecting.");
                break;
                
            default:
                break;
        }
        
        wself.tableViewController.vpnModel.status = VPNStatus;
        wself.tableViewController.vpnModel.statusText = VPNStatusText;
        [wself.tableViewController.tableView reloadData];

    }];
}

- (void)vpnStart {
    [[MoVPNManage shareVPNManage] vpnStart];
}
- (void)vpnStop {
    [[MoVPNManage shareVPNManage] vpnStop];
}

- (void)switchedSaveTabIsOn:(BOOL)isOn{
    if (isOn) {
        self.tableViewController.vpnModel.status = LCVPNStatusConnecting;
        [self refreshSwitchStatus:@"连接中"];
        [self vpnStart];
    }else {
        self.tableViewController.vpnModel.status = LCVPNStatusDisconnected;
        [self refreshSwitchStatus:@"断开中"];
        [self vpnStop];
    }
}

#pragma mark - Notifications
/**
 * 添加通知
 **/
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
}

/**
 * 移除通知
 **/
-(void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 * 程序挂起
 **/
- (void) applicationWillResignActive: (NSNotification *)notification
{
    [self refreshSwitchStatus:nil];
}

/**
 * 程序激活
 **/
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self refreshSwitchStatus:nil];
}

-(void)refreshSwitchStatus:(NSString *)text{
    if (text) {//默认设置状态文本
        self.tableViewController.vpnModel.statusText = text;
        [self.tableViewController.tableView reloadData];
        return;
    }
    
    int VPNStatus = [[MoVPNManage shareVPNManage] vpnStatus];
    NSString *VPNStatusText = @"";
    switch (VPNStatus) {
        case LCVPNStatusInvalid:
            VPNStatusText = @"未设置";
            //                NSLog(@"NEVPNStatusInvalid The VPN is not configured.");
            break;
        case LCVPNStatusDisconnected:
            VPNStatusText = @"未连接";
            //                NSLog(@"NEVPNStatusDisconnected The VPN is disconnected.");
            break;
        case LCVPNStatusConnecting:
            VPNStatusText = @"连接中";
            //                NSLog(@"NEVPNStatusConnecting The VPN is connecting.");
            break;
        case LCVPNStatusConnected:
            VPNStatusText = @"已连接";
            //                NSLog(@"NEVPNStatusConnected The VPN is connected.");
            break;
        case LCVPNStatusReasserting:
            VPNStatusText = @"重连中";
            //                NSLog(@"NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.");
            break;
        case LCVPNStatusDisconnecting:
            VPNStatusText = @"断开中";
            //                NSLog(@"NEVPNStatusDisconnecting The VPN is disconnecting.");
            break;
            
        default:
            break;
    }
    
    self.tableViewController.vpnModel.status = VPNStatus;
    self.tableViewController.vpnModel.statusText = VPNStatusText;
    [self.tableViewController.tableView reloadData];
}
@end
