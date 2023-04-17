//
//  Manage.m
//  知乎日报
//
//  Created by 张思扬 on 2022/10/22.
//

#import "Manage.h"

static Manage* managerTest = nil;

@implementation Manage

+ (instancetype)shareManage {
    if (!managerTest) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            managerTest = [Manage new];
        });
    }
    return managerTest;
}
//请求最新信息
- (void) NetWorkTestWithData:(succeedBlockTest) succeedBlock error:(ErrorBlock) errorBlock {
    
    NSString* json = @"https://news-at.zhihu.com/api/4/news/latest";
    
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* testURL = [NSURL URLWithString:json];
    NSURLRequest* testRequest = [NSURLRequest requestWithURL:testURL];
    NSURLSession* testSession = [NSURLSession sharedSession];
    NSURLSessionTask* testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LastNewsModel* allData = [[LastNewsModel alloc]initWithData:data error:nil];
            succeedBlock(allData);
        } else {
            errorBlock(error);
        }
    }];
    
    [testDataTask resume];

}
//请求过去信息
- (void) NetWorkTestWithPreviousData:(succeedBlockPrevious)succeedBlock error:(ErrorBlock)errorBlock JSON:(NSString*) oneJSON {
    
    NSString* json = oneJSON;
    
    NSLog(@"%@", json);
    
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* testURL = [NSURL URLWithString:json];
    NSURLRequest* testRequest = [NSURLRequest requestWithURL:testURL];
    NSURLSession* testSession = [NSURLSession sharedSession];
    NSURLSessionTask* testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            PreviousModel* allData = [[PreviousModel alloc]initWithData:data error:nil];
            succeedBlock(allData);
        } else {
            errorBlock(error);
        }
    }];
    
    [testDataTask resume];
}

//请求评论信息
- (void) NetWorkTestWithCommentsDate:(succeedBlockComments)succeedBlock error:(ErrorBlock) errorBlock JSON:(NSString*) idString {
    
    NSString* json = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/short-comments", idString];

    
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* testURL = [NSURL URLWithString:json];
    NSURLRequest* testRequest = [NSURLRequest requestWithURL:testURL];
    NSURLSession* testSession = [NSURLSession sharedSession];
    NSURLSessionTask* testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            CommentModel* allData = [[CommentModel alloc]initWithData:data error:nil];
            succeedBlock(allData);
        } else {
            errorBlock(error);
        }
    }];
    
    [testDataTask resume];
}
//请求评论信息,直接传url值
- (void) NetWorkTestWithCommentsData:(succeedBlockComments) succeedBlock error:(nonnull ErrorBlock)errorBlock URL:(NSString*) url {
    NSString* json = url;
    
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL* testURL = [NSURL URLWithString:json];
    NSURLRequest* testRequest = [NSURLRequest requestWithURL:testURL];
    NSURLSession* testSession = [NSURLSession sharedSession];
    NSURLSessionTask* testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            CommentModel* allData = [[CommentModel alloc]initWithData:data error:nil];
            succeedBlock(allData);
        } else {
            errorBlock(error);
        }
    }];
    
    [testDataTask resume];
}

@end

