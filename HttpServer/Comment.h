//
//  Comment.h
//  UGOHttpSever
//
//  Created by 张辉 on 15/9/15.
//  Copyright (c) 2015年 huimai. All rights reserved.
//

#ifndef UGOHttpSever_Comment_h
#define UGOHttpSever_Comment_h

//优品惠官方地址(固定,勿动)
#define HuiMaiMall_Mobile_Host  @"http://mobile.17ugo.com"
//#define HuiMaiMall_Mobile_Host  @"http://mobiletest.17ugo.com"

#define HuiMaiMall_Mobile_SecondKill_Host  @"http://activity.17ugo.com"
//#define HuiMaiMall_Mobile_SecondKill_Host  @"http://mobiletest.17ugo.com"


//主机宏定义
#define HuiMaiMall_Mobile_Url  [HMHttpServerManager sharedHMHttpServerManager].HuiMaiHost
#define HuiMaiMall_SecondKill_Url [HMHttpServerManager sharedHMHttpServerManager].HuiMaiSecondKillHost


#define HuiMaiMall_Web_Url_Postfix         @".ugo"
#define iPhone_HuiMaiMall_CustomService_Tel     @"400-707-0707"
#define oauth_consumer_key          @"20150407"
#define oauth_version               @"1.0"
#define oauth_signature_method      @"MD5"

/*
 专门用来保存单例代码
 最后一行不要加 \
 20131216 zhu
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance = nil; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

//屏幕分辨率
#define kScreenResolution  ([NSString stringWithFormat:@"%.0f*%.0f", [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale , [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale])
#endif
