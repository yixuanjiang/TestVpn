//
//  ViewController+Keychain.m
//  TestVPN
//
//  Created by 蒋毅轩 on 2017/4/7.
//  Copyright © 2017年 蒋毅轩. All rights reserved.
//

#import "ViewController+Keychain.h"

@implementation ViewController (Keychain)
#pragma mark - kSecClassIdentity

#define kKeychainServiceID [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".keychain.library"]

// got from: http://useyourloaf.com/blog/2010/03/29/simple-iphone-keychain-access.html

- (NSMutableDictionary *)id_buildDefaultDictionaryForIdentity:(NSString*)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassIdentity;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = kKeychainServiceID;
    
    return searchDictionary;
}

// 根据 identifier 获取钥匙串中的数据
- (NSData *)id_getDataInKeychainFromIdentifier:(NSString *)identifier returnReference:(BOOL)referenceOnly {
    
    // get default dictionary
    NSMutableDictionary *dict = [self id_buildDefaultDictionaryForIdentity:identifier];
    
    // set for searching
    dict[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    // need reference
    if (referenceOnly) {
        dict[(__bridge id)kSecReturnPersistentRef] = @YES;
    } else {
        dict[(__bridge id)kSecReturnData] = @YES;
    }
    
    // create result object
    CFTypeRef result = NULL;
    
    // Get result
    SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
    
    // return result
    return (__bridge_transfer NSData *)result;
}

// 根据 identifier 获取钥匙串中的字符串数据
- (NSString*)id_getStringInKeychainFromIdentifier:(NSString*)identifier {
    
    NSData *keychainData = [self id_getDataInKeychainFromIdentifier:identifier returnReference:NO];
    return [[NSString alloc] initWithData:keychainData encoding:NSUTF8StringEncoding];
}

// 根据 identifier 获取钥匙串中的二进制数据
- (NSData *)id_getDataReferenceInKeychainFromIdentifier:(NSString *)identifier {
    
    return [self id_getDataInKeychainFromIdentifier:identifier returnReference:YES];
}

/// 设置钥匙串中的数据
- (BOOL)id_setKeychainWithString:(NSString*)string forIdentifier:(NSString*)identifier {
    
    NSMutableDictionary *searchDictionary = [self id_buildDefaultDictionaryForIdentity:identifier];
    NSData *keychainValue = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([self id_getDataReferenceInKeychainFromIdentifier:identifier] == nil) {
        [searchDictionary setObject:keychainValue forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)searchDictionary, NULL);
        if (status == errSecSuccess) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
        [updateDictionary setObject:keychainValue forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
        if (status == errSecSuccess) {
            return YES;
        } else {
            return NO;
        }
    }
}

#pragma mark - kSecClassGenericPassword

- (NSMutableDictionary *)buildDefaultDictionaryForIdentity:(NSString*)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    searchDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    searchDictionary[(__bridge id)kSecAttrGeneric] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrAccount] = encodedIdentifier;
    searchDictionary[(__bridge id)kSecAttrService] = kKeychainServiceID;
    
    return searchDictionary;
}

// 根据 identifier 获取钥匙串中的数据
- (NSData *)getDataInKeychainFromIdentifier:(NSString *)identifier returnReference:(BOOL)referenceOnly {
    
    // get default dictionary
    NSMutableDictionary *dict = [self buildDefaultDictionaryForIdentity:identifier];
    
    // set for searching
    dict[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    // need reference
    if (referenceOnly) {
        dict[(__bridge id)kSecReturnPersistentRef] = @YES;
    } else {
        dict[(__bridge id)kSecReturnData] = @YES;
    }
    
    // create result object
    CFTypeRef result = NULL;
    
    // Get result
    SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
    
    // return result
    return (__bridge_transfer NSData *)result;
}

// 根据 identifier 获取钥匙串中的字符串数据
- (NSString*)getStringInKeychainFromIdentifier:(NSString*)identifier {
    
    NSData *keychainData = [self getDataInKeychainFromIdentifier:identifier returnReference:NO];
    return [[NSString alloc] initWithData:keychainData encoding:NSUTF8StringEncoding];
}

/// 根据 identifier 获取钥匙串中的二进制数据
- (NSData *)getDataReferenceInKeychainFromIdentifier:(NSString *)identifier {
    
    return [self getDataInKeychainFromIdentifier:identifier returnReference:YES];
}

/// 设置钥匙串中的数据
- (BOOL)setKeychainWithString:(NSString*)string forIdentifier:(NSString*)identifier {
    
    NSMutableDictionary *searchDictionary = [self buildDefaultDictionaryForIdentity:identifier];
    NSData *keychainValue = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([self getDataReferenceInKeychainFromIdentifier:identifier] == nil) {
        [searchDictionary setObject:keychainValue forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)searchDictionary, NULL);
        if (status == errSecSuccess) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
        [updateDictionary setObject:keychainValue forKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
        if (status == errSecSuccess) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
