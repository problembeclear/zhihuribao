//
//  MainView.h
//  知乎日报
//
//  Created by 张思扬 on 2022/10/12.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@protocol pushToSetting <NSObject>

- (void) pushControllerToSetting;

@end






@interface MainView : UIView

<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) NSDictionary* dictionaryLastNews;

@property (strong, nonatomic) NSMutableArray* allDictionaryArray;



@property (strong, nonatomic) UILabel* labelHeader;

@property (strong, nonatomic) UIButton* buttonSetting;

@property (strong, nonatomic) UIImageView* buttonImageView;

@property (strong, nonatomic) UIScrollView* scrollView;

@property (strong, nonatomic) UITableView* tableView;



@property (strong, nonatomic) NSTimer* scrollTimer;

@property (strong, nonatomic) UIPageControl* pageControl;

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;

@property (assign) NSInteger cellCount;

@property (copy, nonatomic) NSString* nowStringDate;

@property (assign, nonatomic) id <pushToSetting> pushDelegate;


- (void) Init;

- (void) LayoutNavigation;

- (void) LayoutDate;

- (void) LayoutDivideLine;

- (void) LayoutZHIHU;

- (void) LayoutHeadImage;

- (void) LayoutScrollView;

- (void) LayoutTableView;



@end

NS_ASSUME_NONNULL_END
