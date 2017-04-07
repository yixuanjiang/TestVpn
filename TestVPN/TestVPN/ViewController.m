//
//  ViewController.m
//  TestVPN
//
//  Created by 蒋毅轩 on 2017/4/7.
//  Copyright © 2017年 蒋毅轩. All rights reserved.
//

#import "ViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "MJVpnInfo.h"
#import "ViewController+Keychain.h"

@interface ViewController ()

@property (nonatomic, strong)NEVPNManager *manager;
@property (nonatomic, strong)MJVpnInfo *VpnInfo;

@property (nonatomic, assign)BOOL isConnect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _manager = [NEVPNManager sharedManager];
    NSMutableArray *rules = [[NSMutableArray alloc] init];
    NEOnDemandRuleConnect *connectRule = [NEOnDemandRuleConnect new];
    
    [rules addObject:connectRule];
    [_manager setOnDemandRules:rules];
    _VpnInfo = [MJVpnInfo defaultVPNInfo][@"vpnList"][0];
    
    //NEVPNManager初始化后,系统设置可以使用loadFromPreferencesWithCompletionHandler:加载方法:
    [_manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if(error) {
            NSLog(@"Load error: %@", error);
        } else {
            // No errors! The rest of your codes goes here...
            
            NEVPNProtocolIKEv2 *protocol = [self setUpProtocolIKEv2];
            
            _manager.protocol = protocol;
            _manager.onDemandEnabled = YES;
            _manager.localizedDescription = _VpnInfo.preferenceTitle;
            _manager.enabled = YES;
//            _manager.protocolConfiguration = protocol;
//            _manager.enabled = YES;
            
            [_manager saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
                }
            }];
            
        }
        
    }];
    
}
- (IBAction)btnClick:(UIButton *)sender {

    if (_isConnect) {
        [_manager.connection stopVPNTunnel];
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _isConnect = !_isConnect;
    }else
    {
        
        [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
            if (!error)
            {
                NSError *startError;
                [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
                
                if(startError) {
                    NSLog(@"Start error: %@", startError.localizedDescription);
                } else {
                    NSLog(@"Connection established!");
                    [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            }
        }];

        _isConnect = !_isConnect;
    }
    
    
    
}

- (NEVPNProtocolIKEv2 *)setUpProtocolIKEv2
{
    NEVPNProtocolIKEv2 *protocol = [[NEVPNProtocolIKEv2 alloc] init];
    protocol.deadPeerDetectionRate = NEVPNIKEv2DeadPeerDetectionRateHigh;
    protocol.serverAddress = _VpnInfo.serverAddress;
    protocol.remoteIdentifier = _VpnInfo.remoteID;
    protocol.username = _VpnInfo.username;
    
    // 设置密码
    static NSString *passwordKey = @"k_VPN_Password";
    [self setKeychainWithString:_VpnInfo.password forIdentifier:passwordKey];
    protocol.passwordReference = [self getDataReferenceInKeychainFromIdentifier:passwordKey];
    
    // 共享密码
    static NSString *sharedSecretKey = @"k_VPN_sharedSecret";
    [self setKeychainWithString:_VpnInfo.sharedSecret forIdentifier:sharedSecretKey];
    protocol.sharedSecretReference = [self getDataReferenceInKeychainFromIdentifier:sharedSecretKey];
    
    // 其他配置
    protocol.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
    protocol.useExtendedAuthentication = YES;
    protocol.disconnectOnSleep = NO;
    
    return protocol;
}

- (NETunnelProviderProtocol *)TunnelProviderProtocol
{
    NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
//    protocol.serverAddress = _VpnInfo.serverAddress;
    protocol.providerConfiguration = @{@"serverAddress":@"162.216.18.187",
                                       @"password":@"123VPNoye!",
                                       @"sharedSecret":@"123VPNoye!",
                                       @"routeCode":@"USA-NJ-Newark",
                                       @"regionCode":@"US",
                                       @"routeName":@"A",
                                       @"regionImage":@"Flags/US",
                                       @"isFree":@"1"
                                       };
    return protocol;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
