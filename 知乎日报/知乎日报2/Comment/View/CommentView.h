//
//  CommentView.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface CommentView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;

@property (copy, nonatomic) NSDictionary* myDictionary;

@property (strong, nonatomic) NSMutableArray* myArray;

@property (strong, nonatomic) NSMutableArray* arrayForHeight;

@property (strong, nonatomic) NSMutableArray* arraySetButton;



- (void) LayoutSelf;

- (void) LayoutReturnButton;

- (void) LayoutTitle;

- (void) LayoutTableView;


@end

NS_ASSUME_NONNULL_END
