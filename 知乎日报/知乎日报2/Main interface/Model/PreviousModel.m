//
//  PreviousModel.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/10/29.
//

#import "PreviousModel.h"

@implementation PreviousModel


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


@end


@implementation PreviousStoriesModel 

+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
