//
//  CollectScrollView.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/26.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectScrollView : UIView <UIScrollViewDelegate>


//@property (strong, nonatomic) NSArray* arrayURL;

@property (assign) NSInteger page;

@property (copy, nonatomic) NSString* idStr;



@property (strong, nonatomic) UIScrollView* scrollView;

@property (strong, nonatomic) UILabel* commentsCount;

@property (strong, nonatomic) UILabel* likesCount;

@property (strong, nonatomic) UIButton* buttonLikes;

@property (strong, nonatomic) UIButton* buttonCollect;

@property (strong, nonatomic) FMDatabase* collectionDatabase;

@property (strong, nonatomic) NSMutableArray* arrayForButtonState;

@property (strong, nonatomic) NSMutableArray* titleArray;

@property (strong, nonatomic) NSMutableArray* imageArray;


- (void) LayoutSelf;

- (void) LayoutTabBar;

- (void) LayoutScrollView;


@end

NS_ASSUME_NONNULL_END
