//
//  MoVPNManage.m
//  VpnTest
//
//  Created by luanchen on 16/7/11.
//  Copyright © 2016年 APUS. All rights reserved.
//

#import "MoVPNManage.h"
#import <NetworkExtension/NetworkExtension.h>
#import "AFNetworkReachabilityManager.h"


#pragma mark - 定义钥匙串中标识key/value中的key 暂时只支持ipsec
static NSString * const VPN_PwdIdentifier = @"vpnPassWord"; //vpn密码-钥匙串中标识
static NSString * const VPN_PrivateKeyIdentifier = @"sharedKey"; //群组秘钥-钥匙串中标识
static NSString * const serviceName = @"im.zorro.ipsec_demo.vpn_config"; //钥匙串中服务名称-钥匙串中标识

@interface MoVPNManage ()

@property (strong ,nonatomic) NEVPNManager * vpnManager;
@property (assign ,nonatomic) BOOL reconnect ;      //自动重连
@property (strong ,nonatomic) NSString * server;    //vpn地址
@property (strong ,nonatomic) NSString * ID;        //vpn用户名
@property (strong ,nonatomic) NSString * pwd;       //vpn密码
@property (strong ,nonatomic) NSString * privateKey;//vpn群组秘钥
@property (strong ,nonatomic) NSString * vpnTitle;  //vpn名称-用于在系统设置->vpn显示名称

@property (assign ,nonatomic, getter=isConfig) BOOL config;//设置标识


@property (assign ,nonatomic) BOOL vpnSwitch ;//vpn开关

//static NetworkChangedHandle networkChangedHandle = nil
@property (copy) NetworkChangedHandle networkChangedHandle;


@end

@implementation MoVPNManage

+ (id) shareVPNManage {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[[self class] alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vpnManager = [NEVPNManager sharedManager];
        self.vpnSwitch = NO;
    }
    return self;
}

- (void)setReconnect:(BOOL)reconnect{
    _reconnect = reconnect;
    
    if (_reconnect) {
        // 这里需要延迟加载否则通知会失效
        [self performSelector:@selector(registerNetWorkReachability) withObject:nil afterDelay:0.35f];
    }
    else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setVpnTitle:(NSString *)vpnTitle{
    _vpnTitle = vpnTitle;
}


- (void)setServer:(NSString *)server ID:(NSString *)ID pwd:(NSString *)pwd privateKey:(NSString *)privateKey {
    _server = server;
    _ID = ID;
    _pwd = pwd;
    _privateKey = privateKey;
    [self createKeychainPwdAndPrivateKey];
}

- (void) createKeychainPwdAndPrivateKey{
    [self createKeychainValue:_pwd forIdentifier:VPN_PwdIdentifier];
    [self createKeychainValue:_privateKey forIdentifier:VPN_PrivateKeyIdentifier];
    self.config = YES;
}

- (void) saveConfigCompleteHandle:(CompleteHandle)completeHandle;{
    if (!_vpnManager) {
        completeHandle(NO,@"NEVPNManager Uninitialized");
        return;
    }
    
    if (!_config) {
        completeHandle(NO,@"Configuration parameters cannot be empty");
        return;
    }
    
    //  这里才是核心代码 仅支持 ipsec
    // 1. 获取NEVPNManager实例
    // 2. loadFromPreferencesWithCompletionHandler 加载设置
    // 3. saveToPreferencesWithCompletionHandler 设置并存储设置
    {
//        self.vpnManager = [NEVPNManager sharedManager];
        [_vpnManager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
            if (error) {
                completeHandle(NO,[NSString stringWithFormat:@"Load config failed [%@]", error.localizedDescription]);
                return;
            }
            NEVPNProtocolIPSec *p = (NEVPNProtocolIPSec*)_vpnManager.protocol;
            if (!p) {
                p = [[NEVPNProtocolIPSec alloc] init];
            }
            
            p.username = _ID;
            p.serverAddress = _server;
            p.passwordReference = [self searchKeychainCopyMatching:VPN_PwdIdentifier];
            p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
            p.sharedSecretReference = [self searchKeychainCopyMatching:VPN_PrivateKeyIdentifier];
            p.useExtendedAuthentication = YES;
            p.disconnectOnSleep = NO;
            _vpnManager.protocol = p;
            _vpnManager.onDemandEnabled=NO;//按需链接
            _vpnManager.localizedDescription = _vpnTitle?_vpnTitle:@"Ipsec Test"; //设置VPN的名字 可以自定义
            
            // 保存设置
            [_vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    completeHandle(NO,[NSString stringWithFormat:@"Save config failed [%@]", error.localizedDescription]);
                }
                else {
                    completeHandle(YES,@"Save config success");
                }
            }];
        }];
    }
}

#pragma mark - ZT设置IKEv2协议
- (void)getAnIKEv2Protocol
{
    NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc]init];
    p.username = @"no account";
    p.serverAddress = @"haven't found a server yet";
//    p.passwordReference = [self searchKeychainCopyMatching:VPN_PwdIdentifier];
    NSString *password = @"not yet";
    p.passwordReference = [password dataUsingEncoding:NSUTF8StringEncoding];
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    p.sharedSecretReference = nil;
    p.useExtendedAuthentication=YES;
    p.disconnectOnSleep = NO;
    
    _vpnManager.protocol = p;
    _vpnManager.onDemandEnabled = NO;
    _vpnManager.localizedDescription = @"IKEv2 Test One";
    
    [_vpnManager saveToPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            [NSString stringWithFormat:@"Save config failed [%@]", error.localizedDescription];
        }
        else {
           
        }
    }];

    
}

#pragma mark -
#pragma mark - 自动重连 BEGIN
- (void)registerNetWorkReachability{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
}
/**
 *  检测网络
 */
-(void)checkNetWork{
    NSLog(@"自动checkNetWork~!");
    [self outPutConnectionStatus];
    if (self.networkChangedHandle) {
        _networkChangedHandle((LCVPNStatus)_vpnManager.connection.status);
    }
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN ||
            status == AFNetworkReachabilityStatusReachableViaWiFi) {
            if (self.vpnManager.connection.status != NEVPNStatusConnected && self.vpnSwitch) {
                NSLog(@"自动重连~!");
                [self vpnStart];
            }
        }
    }];
}
#pragma mark - 自动重连 END


- (void)vpnStart{
    NSError *startError;
    [_vpnManager.connection startVPNTunnelAndReturnError:&startError];
    if (startError) {
        NSLog(@"Start VPN failed: [%@]", startError.localizedDescription);
    }else {
        self.vpnSwitch = YES;
    }
//    [self outPutConnectionStatus];
}

- (void)outPutConnectionStatus{
    switch (_vpnManager.connection.status) {
        case NEVPNStatusInvalid:
            NSLog(@"NEVPNStatusInvalid The VPN is not configured.");
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"NEVPNStatusDisconnected The VPN is disconnected.");
            break;
        case NEVPNStatusConnecting:
            NSLog(@"NEVPNStatusConnecting The VPN is connecting.");
            break;
        case NEVPNStatusConnected:
            NSLog(@"NEVPNStatusConnected The VPN is connected.");
            break;
        case NEVPNStatusReasserting:
            NSLog(@"NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.");
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"NEVPNStatusDisconnecting The VPN is disconnecting.");
            break;
        default:
            break;
    }
}

- (void)vpnStop{
    [_vpnManager.connection stopVPNTunnel];
    self.vpnSwitch = NO;
    NSLog(@"VPN has stopped success");
}

- (LCVPNStatus)vpnStatus{
    return (LCVPNStatus)_vpnManager.connection.status;
}

- (void) saveNetworkChangedHandle:(NetworkChangedHandle)networkChangedHandle{
    _networkChangedHandle = networkChangedHandle;

}

#pragma mark -
#pragma mark - KeyChain BEGIN



- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}
#pragma mark - KeyChain END

@end
