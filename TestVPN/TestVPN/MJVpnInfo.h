//
//  MJVpnInfo.h
//  ExtremeVPN
//
//  Created by Gin on 2016/12/27.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

/// VPN 配置信息
@interface MJVpnInfo : NSObject

@property (nonatomic, strong) NSString *serverAddress;      ///< 服务器地址
@property (nonatomic, strong) NSString *remoteID;           ///< 远程 ID - 不传入的话，将保持和 serverAddress 一致
@property (nonatomic, strong) NSString *username;           ///< 用户名 - 不传入的话，将默认使用 UUID
@property (nonatomic, strong) NSString *password;           ///< 密码
@property (nonatomic, strong) NSString *sharedSecret;       ///< 共享密码
@property (nonatomic, strong) NSString *preferenceTitle;    ///< vpn 配置标题 - 不传入的话，将使用默认的 bundleDisplayName

#pragma mark - 额外信息，用作统计，和界面展示

@property (nonatomic, strong) NSString *routeCode;          ///< 线路代码 - 用作统计
@property (nonatomic, strong) NSString *regionCode;         ///< 区域代码 - 转换成本地化字符串
@property (nonatomic, strong) NSString *routeName;          ///< 区别线路 - 如果同一个地区有多个线路才会启用这个字段，先将区域代码转换成本地化字符串再拼接上这个字段
@property (nonatomic, strong) NSString *regionImage;        ///< 显示图片 - 不传的话，将使用 Flags/ + regionCode

@property (nonatomic, assign) BOOL isFree;                  ///< 该 vpn 是否免费

+ (instancetype)infoWithData:(id)data;

+ (NSDictionary *)defaultVPNInfo;

@end
