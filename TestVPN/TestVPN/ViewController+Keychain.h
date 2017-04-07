//
//  ViewController+Keychain.h
//  TestVPN
//
//  Created by 蒋毅轩 on 2017/4/7.
//  Copyright © 2017年 蒋毅轩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Keychain)

#pragma mark - kSecClassIdentity

/// 根据 identifier 获取钥匙串中的二进制数据
- (NSData *)id_getDataReferenceInKeychainFromIdentifier:(NSString *)identifier;
/// 设置钥匙串中的数据
- (BOOL)id_setKeychainWithString:(NSString*)string forIdentifier:(NSString*)identifier;

#pragma mark - kSecClassGenericPassword

/// 根据 identifier 获取钥匙串中的二进制数据
- (NSData *)getDataReferenceInKeychainFromIdentifier:(NSString *)identifier;
/// 设置钥匙串中的数据
- (BOOL)setKeychainWithString:(NSString*)string forIdentifier:(NSString*)identifier;

@end
