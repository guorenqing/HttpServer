//
//  HMServerTool.h
//  UGOHttpSever
//
//  Created by 张辉 on 15/9/15.
//  Copyright (c) 2015年 huimai. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^HttpSuccessBlock)(id JSON);
typedef void(^HttpFailureBlock)(NSError* error);

@interface HMHttpServer : NSObject
/**
 *  这个是惠买http get请求方法
 *
 *  @param host    参数为空或者为空字符串的时候 默认为 HuiMaiMall_Mobile_Url
 *  @param path    如 getThirdCats.ugo
 *  @param appVersion    app版本 [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey]
 *  @param params  这个是业务层传得参数
 *  @param success 这个是请求成功后回调的block
 *  @param failure 这个是请求失败的回调block
 */
+(void)getWithHost:(NSString*)host Path:(NSString*)path params:(NSDictionary*)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
/**
 *  这个是惠买http get请求方法
 *
 *  @param host    参数为空或者为空字符串的时候 默认为 HuiMaiMall_Mobile_Url
 *  @param path    如 getThirdCats.ugo
 *  @param appVersion    app版本 [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey]
 *  @param params  这个是业务层传得参数
 *  @param success 这个是请求成功后回调的block
 *  @param failure 这个是请求失败的回调block
 */
+(void)postWithHost:(NSString*)host Path:(NSString*)path  params:(NSDictionary*)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 *  这个方法是上传头像的方法
 *
 *  @param image   这个是需要上传的图片
 *  @param success 上传成功回调block
 *  @param failure 上传失败回调block
 */
+(void)composeWithImage:(UIImage*)image withUserId:(NSString *)userId success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

@end
