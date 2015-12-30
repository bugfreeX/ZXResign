//
//  MobileprovisionPerform.h
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileprovisionPerform : NSObject
+(void)creatEntitlementsPlistByMobileprovisionPath:(NSString *)mobileprovisionPath WorkPath:(NSString *)workPath;
+(void)replaceMobileprovision;
@end
