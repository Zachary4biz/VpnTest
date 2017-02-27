//
//  LCVPNDetailViewController.m
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "LCVPNDetailViewController.h"
#import "LCVPNDetailTableViewController.h"
#import "LCVPNModel.h"

#define NAVIGATIONBAR_HEIGHT 64
#define SECTION_HEADER_HEIGHT 16
#define CELL_HEIGHT 50

@interface LCVPNDetailViewController ()<LCVPNDetailTableViewControllerDelegate>

@property (nonatomic, strong) LCVPNDetailTableViewController *tableViewController;

@end

@implementation LCVPNDetailViewController

-(instancetype)initWithVPNModel:(LCVPNModel *)vpnModel{
    self = [super init];
    if (self)
    {
        self.vpnModel = vpnModel;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VPN Detail";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"navigationController_leftButtonAction:")];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:NO];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"navigationController_rightButtonAction:")];
    [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
    
    LCVPNDetailTableViewController *tableViewController = [[LCVPNDetailTableViewController alloc]init];
    tableViewController.vpnModel = self.vpnModel;
    tableViewController.delegate = self;
    tableViewController.view.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-NAVIGATIONBAR_HEIGHT);
    [self addChildViewController:tableViewController];
    [tableViewController didMoveToParentViewController:self];
    [self.view addSubview:tableViewController.view];
    self.tableViewController = tableViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigationController_leftButtonAction:(id)sender {
    NSLog(@"navigationController_leftButtonAction");
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)navigationController_rightButtonAction:(id)sender {
    NSLog(@"navigationController_rightButtonAction");
//    self.vpnModel.adress = [self.tableViewController getVPNAdress];
//    self.vpnModel.account = [self.tableViewController getVPNAccount];
//    self.vpnModel.password = [self.tableViewController getVPNPassword];
//    self.vpnModel.groupKey = [self.tableViewController getVPNGroupKey];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
