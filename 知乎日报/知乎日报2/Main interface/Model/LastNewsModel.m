//
//  LastNewsModel.m
//  知乎日报
//
//  Created by 张思扬 on 2022/10/22.
//

#import "LastNewsModel.h"



@implementation LastNewsModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end



@implementation StoriesModel

+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Top_StoriesModel

+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end








