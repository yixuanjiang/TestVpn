//
//  MJVpnInfo.m
//  ExtremeVPN
//
//  Created by Gin on 2016/12/27.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJVpnInfo.h"
#import <UIKit/UIKit.h>

@implementation MJVpnInfo

+ (instancetype)infoWithData:(id)data {
    
    MJVpnInfo *vpnInfo = [[MJVpnInfo alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        data[@"serverAddress"] ? vpnInfo.serverAddress = data[@"serverAddress"] : 0;
        data[@"remoteID"] ? vpnInfo.remoteID = data[@"remoteID"] : 0;
        data[@"username"] ? vpnInfo.username = data[@"username"] : 0;
        data[@"password"] ? vpnInfo.password = data[@"password"] : 0;
        data[@"sharedSecret"] ? vpnInfo.sharedSecret = data[@"sharedSecret"] : 0;
        data[@"preferenceTitle"] ? vpnInfo.preferenceTitle = data[@"preferenceTitle"] : 0;
        data[@"routeCode"] ? vpnInfo.routeCode = data[@"routeCode"] : 0;
        data[@"regionCode"] ? vpnInfo.regionCode = data[@"regionCode"] : 0;
        data[@"routeName"] ? vpnInfo.routeName = data[@"routeName"] : 0;
        data[@"regionImage"] ? vpnInfo.regionImage = data[@"regionImage"] : 0;
        data[@"isFree"] ? vpnInfo.isFree = [data[@"isFree"] boolValue] : 0;
    } else if ([data isKindOfClass:[self class]]) {
        vpnInfo = data;
    }
    // VPN 显示在设置列表中的名称
    if (vpnInfo.preferenceTitle.length < 1) {
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        if (appName.length == 0) {
            appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        }
        vpnInfo.preferenceTitle = appName;
    }
    // 用户名使用 UUID
    if (vpnInfo.username.length < 1) {
        vpnInfo.username = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    // 远程 ID 默认和服务器地址保持一致
    if (vpnInfo.remoteID.length < 1) {
        vpnInfo.remoteID = vpnInfo.serverAddress;
    }
    if (vpnInfo.sharedSecret.length < 1) {
        vpnInfo.sharedSecret = @"";
    }
    if (vpnInfo.routeName.length < 1) {
        vpnInfo.routeName = @"";
    }
    if (vpnInfo.regionImage.length < 1) {
        vpnInfo.regionImage = @"";
    }
    
    return vpnInfo;
}

+ (NSDictionary *)defaultVPNInfo {
    
    NSMutableDictionary *vpnDict = [NSMutableDictionary dictionary];
    // 返回一个字典
    vpnDict[@"vpnList"] = @[[MJVpnInfo infoWithData:@{@"serverAddress":@"162.216.18.187",
                                                      @"password":@"123VPNoye!",
                                                      @"sharedSecret":@"123VPNoye!",
                                                      @"routeCode":@"USA-NJ-Newark",
                                                      @"regionCode":@"US",
                                                      @"routeName":@"A",
                                                      @"regionImage":@"Flags/US",
                                                      @"isFree":@"1"
                                                      }]
                            ];
    
    return vpnDict;
}

@end
