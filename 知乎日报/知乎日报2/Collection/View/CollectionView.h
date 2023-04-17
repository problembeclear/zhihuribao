//
//  CollectionView.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectionView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UILabel* titleLabel;

@property (strong, nonatomic) UIButton* returnButton;

@property (copy, nonatomic) NSString* url;

@property (strong, nonatomic) UITableView* tableView;


@property (assign) NSInteger cellCount;

@property (strong, nonatomic) FMDatabase* collectionDatabase;

@property (strong, nonatomic) NSMutableArray* arrayTitle;

@property (strong, nonatomic) NSMutableArray* arrayImage;

@property (strong, nonatomic) NSMutableArray* arrayURL;

- (void) LayoutSelf ;

@end

NS_ASSUME_NONNULL_END
