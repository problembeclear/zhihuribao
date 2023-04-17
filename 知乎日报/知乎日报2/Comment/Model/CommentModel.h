//
//  CommentModel.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

@protocol Comments
@end
@protocol Reply
@end



#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : JSONModel

@property (strong, nonatomic) NSArray<Comments>* comments;

@end

@interface Reply : JSONModel

@property (copy, nonatomic) NSString* content;

@property (copy, nonatomic) NSString* author;

@property (copy, nonatomic) NSString* id;

@property (copy, nonatomic) NSString* status;


@end



@interface Comments : JSONModel

@property (copy, nonatomic) NSString* author;

@property (copy, nonatomic) NSString* content;

@property (copy, nonatomic) NSString* avatar;

@property (assign, nonatomic) NSInteger likes;

@property (assign, nonatomic) NSInteger time;

@property (assign, nonatomic) NSInteger id;

@property (strong, nonatomic) Reply* reply_to;

@end





NS_ASSUME_NONNULL_END
