//
//  PreviousModel.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/10/29.
//


@protocol PreviousStoriesModel
@end

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviousModel : JSONModel

@property (copy, nonatomic) NSString* date;

@property (strong, nonatomic) NSArray<PreviousStoriesModel>* stories;


@end

@interface PreviousStoriesModel : JSONModel

@property (strong, nonatomic) NSString* image_hue;

@property (strong, nonatomic) NSString* hint;

@property (strong, nonatomic) NSString* url;

@property (strong, nonatomic) NSArray* images;

@property (strong, nonatomic) NSString* title;

@property (strong, nonatomic) NSString* ga_prefix;

@property (assign) NSInteger id;


@end




NS_ASSUME_NONNULL_END
