//
//  HMServerTool.m
//  UGOHttpSever
//
//  Created by 张辉 on 15/9/15.
//  Copyright (c) 2015年 huimai. All rights reserved.
//

#import "HMHttpServer.h"
#import "Comment.h"
#import "HMHttpServerManager.h"
#import <CommonCrypto/CommonCrypto.h>

#import "AFHTTPRequestOperationManager.h"

@implementation HMHttpServer : NSObject

+(void)getWithHost:(NSString *)host Path:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    if(host==nil || [@"" isEqualToString:host]){
        host = HuiMaiMall_Mobile_Url;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?",host,path];
    
    urlString = [self UrlEncoding:urlString];
    //添加签名字典
    urlString = [self signaturedStringFromString:urlString];
    
    
       //请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            NSString* result = [responseObject objectForKey:@"code"];
            if (result != nil)
            {
                if ([result isEqualToString:@"0"])
                {
                    NSDictionary * infoDict = [responseObject objectForKey:@"info"];//[rootDict objectForKey:@"info"];
                    success(infoDict);
                   
                }
                else
                {
                    if(failure)
                        failure([NSError errorWithDomain:@"请求错误" code:-1 userInfo:nil]);
                }
            }
            else
            {
                if(failure)
                {
                    //错误冗余（重要）
                    NSString *err_msg = [responseObject objectForKey:@"err_msg"];
                    if (err_msg == nil)
                    {
                        err_msg = @"请求错误";
                    }
                    
                    NSError *error = [NSError errorWithDomain:err_msg code:-1 userInfo:nil];
                    failure(error);
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            error = [NSError errorWithDomain:@"网络不太顺畅" code:-1 userInfo:nil];
            failure( error);
        }
    }];
}

+(void)postWithHost:(NSString *)host Path:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    if(host==nil || [@"" isEqualToString:host]){
        host = HuiMaiMall_Mobile_Url;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?",host,path];
    //添加签名字符串
    urlString = [self signaturedStringFromString:urlString];
    
    urlString = [self UrlEncoding:urlString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            NSString* result = [responseObject objectForKey:@"code"];
            if (result != nil)
            {
                if ([result isEqualToString:@"0"])
                {
                    NSDictionary * infoDict = [responseObject objectForKey:@"info"];//[rootDict objectForKey:@"info"];
                    success(infoDict);
                    
                }
                else
                {
                    if(failure)
                        failure([NSError errorWithDomain:@"请求错误" code:-1 userInfo:nil]);
                }
            }
            else
            {
                if(failure)
                {
                    //错误冗余（重要）
                    NSString *err_msg = [responseObject objectForKey:@"err_msg"];
                    if (err_msg == nil)
                    {
                        err_msg = @"请求错误";
                    }
                    
                    NSError *error = [NSError errorWithDomain:err_msg code:-1 userInfo:nil];
                    failure(error);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure)
        {
            error = [NSError errorWithDomain:@"网络不太顺畅" code:-1 userInfo:nil];
            failure( error);
        }
    }];

    
}
+(void)composeWithImage:(UIImage *)image withUserId:(NSString *)userId success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    //将当前时间日期格式化后作为文件路径
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",formatStr];
    
    //拼接上传URL
    NSString *imgUrl = [NSString stringWithFormat:@"%@/uploadFileFromClient.ugo?userId=%@&uploadType=1&fileName=%@&",@"http://mobile.17ugo.com",userId,fileName];
    
    imgUrl = [self signaturedStringFromString:imgUrl];
    
    NSString *encodeImgurl = [imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //用AFN 上传图片
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:encodeImgurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image !=nil){
            NSData *imageData =UIImagePNGRepresentation(image);
            NSString *fileName = @"uploadFileName.png";
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}
+ (NSString*)getOauthSignature:(NSString *)urlString {
    NSRange range = [urlString rangeOfString:@"?"];
    NSString* oauthString;
    if (range.location == NSNotFound) {
        oauthString = urlString;
    } else {
        oauthString = [urlString substringFromIndex:range.location+1];
    }
    NSArray* arrayParams = [oauthString componentsSeparatedByString:@"&"];
    NSMutableArray* orderedParams = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    for (NSString* param in arrayParams) {
        NSInteger indexEquality = [param rangeOfString:@"="].location;
        if ([[param substringToIndex:indexEquality] isEqualToString:@"oauth_nonce"]) {
            [orderedParams replaceObjectAtIndex:0 withObject:[param substringFromIndex:indexEquality+1]];
        } else if ([[param substringToIndex:indexEquality] isEqualToString:@"oauth_signature_method"]) {
            [orderedParams replaceObjectAtIndex:1 withObject:[param substringFromIndex:indexEquality+1]];
        } else if ([[param substringToIndex:indexEquality] isEqualToString:@"oauth_consumer_key"]) {
            [orderedParams replaceObjectAtIndex:2 withObject:[param substringFromIndex:indexEquality+1]];
        } else if ([[param substringToIndex:indexEquality] isEqualToString:@"oauth_version"]) {
            [orderedParams replaceObjectAtIndex:3 withObject:[param substringFromIndex:indexEquality+1]];
        } else if ([[param substringToIndex:indexEquality] isEqualToString:@"oauth_timestamp"]) {
            [orderedParams replaceObjectAtIndex:4 withObject:[param substringFromIndex:indexEquality+1]];
        }
    }
    oauthString = [[NSString alloc] initWithFormat:@"%@&%@&%@&%@&%@", [orderedParams objectAtIndex:0],[orderedParams objectAtIndex:1],[orderedParams objectAtIndex:2],[orderedParams objectAtIndex:3],[orderedParams objectAtIndex:4]];
    //    [orderedParams release];
    const char *src = [oauthString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (int)strlen(src), result);
    //    [oauthString release];
    NSString * ret = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]];[NSString defaultCStringEncoding];
    return ret;
}


+(NSString *)signaturedStringFromString:(NSString *)string
{
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
    unsigned long long timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    NSString* urlString = [[NSString alloc] initWithFormat:@"%@oauth_nonce=%d&oauth_signature_method=MD5&oauth_timestamp=%llu&oauth_version=1.0&deviceType=ios%@&appVersion=%@&screenResolution=%@",
                           string, arc4random(), timestamp, [UIDevice currentDevice].systemVersion,currentVersionCode, kScreenResolution];
    NSString* oauth_signature = [self getOauthSignature:urlString withParaDic:nil];
    NSString* requestUrl = [[NSString alloc] initWithFormat:@"%@&oauth_signature=%@", urlString,oauth_signature];
    return requestUrl;
}
+ (NSString*)getOauthSignature:(NSString *)urlString withParaDic:(NSDictionary *)paraDic
{
    //1.获取要签名的参数字符串
    NSRange range = [urlString rangeOfString:@"?"];
    NSString* oauthString = nil;
    if (range.location == NSNotFound)
    {
        oauthString = urlString;
    } else {
        oauthString = [urlString substringFromIndex:range.location+1];
    }
    
    //2.拼接秘钥
    oauthString = [NSString stringWithFormat:@"%@&oauth_consumer_key=%@", oauthString, oauth_consumer_key];
    
    
    
    //3.分割参数
    NSMutableArray* arrayParams = [NSMutableArray arrayWithArray:[oauthString componentsSeparatedByString:@"&"]];
    //4.添加post字典参数
    if (paraDic != nil)
    {
        for (NSString *key in paraDic)
        {
            NSString *keyValueString = [NSString stringWithFormat:@"%@=%@", key, paraDic[key]];
            [arrayParams addObject:keyValueString];
        }
    }
    
    //5.去除已经签名过的参数
    NSString *oauth_signatureString = nil;
    for (NSString *param in arrayParams)
    {
        if ([param hasPrefix:@"oauth_signature="])
        {
            oauth_signatureString = param;
        }
    }
    if (oauth_signatureString != nil)
    {
        [arrayParams removeObject:oauth_signatureString];
    }
    
    //6.排序参数
    arrayParams = (NSMutableArray *)[arrayParams sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2)
                                     {
                                         return [obj1 compare:obj2];
                                     }];
    
    //7.拼接参数值
    for (int i = 0; i < arrayParams.count; i++)
    {
        NSString *param = arrayParams[i];
        NSRange equalRange = [param rangeOfString:@"="];
        NSInteger indexEquality ;
        if (equalRange.location != NSNotFound) {
            indexEquality = equalRange.location;
            if (i == 0)
            {
                oauthString = [param substringFromIndex:indexEquality+1];
            }
            else
            {
                oauthString = [NSString stringWithFormat:@"%@&%@", oauthString, [param substringFromIndex:indexEquality+1]];
            }
        }
    }
    
    //8.urlencode 解码
    //    oauthString = [oauthString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //9.MD5加密
    const char *src = [oauthString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (int)strlen(src), result);
    NSString * ret = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]];[NSString defaultCStringEncoding];
    return ret;
}

+(NSString * ) UrlEncoding:(NSString *)urlStr
{
    return  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//键值对转换成字典
+ (NSDictionary *)dictionaryFromKeyValuesString:(NSString*)string
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSArray *array = [string componentsSeparatedByString:@"&"];
    for (NSString *keyValuse in array)
    {
        NSArray *keyValue = [keyValuse componentsSeparatedByString:@"="];
        params[keyValue[0]] = keyValue[1];
    }
    
    return params;
}
@end
