//
//  CellView.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface CellView : UIView
<
    UIScrollViewDelegate
>




@property (strong, nonatomic) NSMutableArray* allDictionaryArray;

@property (strong, nonatomic) NSString* nowStringDate;

@property (assign) NSIndexPath* indexPath;

@property (assign) NSInteger pageCountInScrollView;

@property (copy, nonatomic) NSString* url;




@property (strong, nonatomic) UIScrollView* scrollView;

@property (strong, nonatomic) UILabel* commentsCount;

@property (strong, nonatomic) UILabel* likesCount;

@property (strong, nonatomic) UIButton* buttonLikes;

@property (strong, nonatomic) UIButton* buttonCollect;


//翻页时防止重复请求卡屏
@property (strong, nonatomic) NSMutableArray* arrayForbidRequest;
//
@property (strong, nonatomic) NSMutableArray* arrayForButtonState;
//数据库
@property (strong, nonatomic) FMDatabase* collectionDatabase;



- (void) LayoutSelf;

- (void) LayoutTabBar;

- (void) LayoutScrollView;

- (void) LayoutWebView;

@end

NS_ASSUME_NONNULL_END
