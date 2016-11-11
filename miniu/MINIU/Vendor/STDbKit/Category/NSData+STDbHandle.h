//
//  NSData+STDbHandle.h
//  STDbKit
//
//  Created by yls on 15/3/4.
//  Copyright (c) 2015年 yls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (STDbHandle)

- (NSString *)base64String;
/** encrypt */
- (NSData *)aes256EncryptWithKey:(NSString *)key;
/** decrypt */
- (NSData *)aes256DecryptWithKey:(NSString *)key;

@end