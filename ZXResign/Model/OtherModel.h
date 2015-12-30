//
//  OtherModel.h
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherModel : NSObject
+(void)StartCheckScriptFiles;
+(BOOL)checkVersion;
+(void)removeOtherFiles;
+(void)copyResignediPAToNewPath;
@end
