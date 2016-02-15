//
//  YICommonUtil.h
//  Dobby
//
//  Created by efeng on 15/7/7.
//  Copyright (c) 2015年 weiboyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YICommonUtil : NSObject

+ (void)copyStringToPasteboard:(NSString *)copiedString;

+ (NSString *)appName;

+ (void)suspendAppAndExit;

+ (BOOL)isRegisteredRemoteNotification;

// 应用的版本号
+ (NSString *)appVersion;

+ (UIImage *)appIconImage;

// unix时间戳
+ (NSString *)unixTimestamp;

+ (void)toScorePageOfAppStore;
+ (void)toHomePageOfAppStore;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
