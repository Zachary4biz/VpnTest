//
//  MoVPNManage.h
//  VpnTest
//
//  Created by luanchen on 16/7/11.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /*! @const NEVPNStatusInvalid The VPN is not configured. */
    LCVPNStatusInvalid = 0,
    /*! @const NEVPNStatusDisconnected The VPN is disconnected. */
    LCVPNStatusDisconnected = 1,
    /*! @const NEVPNStatusConnecting The VPN is connecting. */
    LCVPNStatusConnecting = 2,
    /*! @const NEVPNStatusConnected The VPN is connected. */
    LCVPNStatusConnected = 3,
    /*! @const NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity. */
    LCVPNStatusReasserting = 4,
    /*! @const NEVPNStatusDisconnecting The VPN is disconnecting. */
    LCVPNStatusDisconnecting = 5,
}LCVPNStatus;


typedef void(^CompleteHandle)(BOOL success , NSString * returnInfo);
typedef void(^NetworkChangedHandle)(LCVPNStatus VPNStatus);

@interface MoVPNManage : NSObject

+ (id) shareVPNManage;

/**
 *  设置vpn参数
 *
 *  @param server     主机HOST
 *  @param ID         账号
 *  @param pwd        密码
 *  @param privateKey 私钥
 */
- (void)setServer:(NSString *)server ID:(NSString *)ID pwd:(NSString *)pwd privateKey:(NSString *)privateKey;

/**
 *  设置标题
 */
- (void)setVpnTitle:(NSString *)vpnTitle;

/**
 *  执行
 */
- (void) saveConfigCompleteHandle:(CompleteHandle)completeHandle;

/**
 *  断线重连 默认为NO
 */
- (void) setReconnect:(BOOL)reconnect;

- (void) vpnStart;

- (void) vpnStop;

/**
 *  当前状态
 */
- (LCVPNStatus)vpnStatus;

/**
 *  网络状态变更
 */
- (void) saveNetworkChangedHandle:(NetworkChangedHandle)networkChangedHandle;

@end
