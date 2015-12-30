//
//  FilePathModel.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/18.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "SharedData.h"

@implementation SharedData
+(SharedData *)sharedInstance
{
    static dispatch_once_t pred;
    static SharedData * model = nil;
    dispatch_once(&pred, ^{
        model = [[self alloc]init];
    });
    return model;
}

-(NSMutableArray *)iPAFilesPathArray
{
    if (!_iPAFilesPathArray) {
        _iPAFilesPathArray = [NSMutableArray array];
    }
    return _iPAFilesPathArray;
}


@end
