//
//  StringToMD5.h
//  TinhteRSS
//
//  Created by Tran Cong Vuong on 11/18/13.
//  Copyright (c) 2013 Tran Cong Vuong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface StringToMD5 : NSObject{}
- (NSString *)MD5String:(NSString *)string;

@end

