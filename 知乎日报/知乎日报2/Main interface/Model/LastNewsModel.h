//
//  LastNewsModel.h
//  知乎日报
//
//  Created by 张思扬 on 2022/10/22.
//



@protocol StoriesModel
@end

@protocol Top_StoriesModel
@end



#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LastNewsModel : JSONModel

@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSArray<StoriesModel>* stories;

@property (strong, nonatomic) NSArray<Top_StoriesModel>* top_stories;

@end

@interface StoriesModel : JSONModel

@property (strong, nonatomic) NSString* image_hue;

@property (strong, nonatomic) NSString* title;

@property (strong , nonatomic) NSString* url;

@property (strong, nonatomic) NSString* hint;

@property (strong, nonatomic) NSString* ga_prefix;

@property (strong, nonatomic) NSArray* images;

@property (assign, nonatomic) NSInteger id;

@end

@interface Top_StoriesModel : JSONModel

@property (strong, nonatomic) NSString* image_hue;

@property (strong, nonatomic) NSString* hint;

@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) NSString* image;

@property (strong, nonatomic) NSString* title;

@property (strong, nonatomic) NSString* ga_prefix;

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSInteger id;


@end


NS_ASSUME_NONNULL_END
