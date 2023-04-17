//
//  Manage.h
//  知乎日报
//
//  Created by 张思扬 on 2022/10/22.
//

#import <Foundation/Foundation.h>
#import "LastNewsModel.h"
#import "PreviousModel.h"
#import "CommentModel.h"
//块定义，定义一个block类型的变量SuccessBlock 为输入参数，其需要参数类型是id 返回值是第二个括号的块
//这样可以利用SuccessBlock进行参数的传递或者编辑
typedef void (^succeedBlockTest)(LastNewsModel *_Nonnull mainViewNowModel);
//失败返回error
typedef void (^ErrorBlock)(NSError *_Nonnull error);

typedef void (^succeedBlockPrevious)(PreviousModel *_Nonnull mainViewModel);

typedef void (^succeedBlockComments)(CommentModel *_Nonnull mainViewModel);

NS_ASSUME_NONNULL_BEGIN

@interface Manage : NSObject

+ (instancetype) shareManage;

- (void) NetWorkTestWithData:(succeedBlockTest) succeedBlock error:(ErrorBlock) errorBlock;

- (void) NetWorkTestWithPreviousData:(succeedBlockPrevious) succeedBlock error:(ErrorBlock) error JSON:(NSString*) oneJSON;

- (void) NetWorkTestWithCommentsDate:(succeedBlockComments) succeedBlock error:(ErrorBlock) errorBlock JSON:(NSString*) idString;

- (void) NetWorkTestWithCommentsData:(succeedBlockComments) succeedBlock error:(nonnull ErrorBlock)errorBlock URL:(NSString*) url;
@end

NS_ASSUME_NONNULL_END
