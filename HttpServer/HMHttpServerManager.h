//
//  HMHttpServerManager.h
//  HuiMaiMall
//
//  Created by guorenqing on 15/7/29.
//  Copyright (c) 2015年 HuiMaiMall. All rights reserved.
//  服务器地址单列类

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface HMHttpServerManager : NSObject

/**
 *  普通服务器地址
 */
@property (nonatomic, copy) NSString *HuiMaiHost;
/**
 *  秒杀服务器地址
 */
@property (nonatomic, copy) NSString *HuiMaiSecondKillHost;

singleton_interface(HMHttpServerManager)

@end
