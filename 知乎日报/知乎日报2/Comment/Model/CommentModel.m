//
//  CommentModel.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import "CommentModel.h"

@implementation CommentModel
+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end


@implementation Comments

+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation Reply

+ (BOOL) propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
