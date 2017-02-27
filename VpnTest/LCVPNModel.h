//
//  LCVPNModel.h
//  VpnTest
//
//  Created by luanchen on 2016/12/14.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCVPNModel : NSObject

@property (nonatomic,strong) NSString *adress;              /*vpn地址*/
@property (nonatomic,strong) NSString *account;             /*vpn账户*/
@property (nonatomic,strong) NSString *password;            /*vpn密码*/
@property (nonatomic,strong) NSString *groupKey;            /*vpn组群密钥*/
@property (nonatomic,assign) int type;                      /*VPN类型*/
@property (nonatomic,assign) BOOL autoReconnect;                /*自动重连*/
@property (nonatomic,assign) BOOL demandEnabled;                /*按需链接*/
@property (nonatomic,assign) int status;                      /*VPN状态*/
@property (nonatomic,strong) NSString *statusText;            /*VPN状态*/

@end
