//
//  settingView.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/2.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol popReturn <NSObject>

- (void) popToMainView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface settingView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;

@property (assign, nonatomic) id <popReturn> delegate;

- (void) LayoutSelf;

- (void) LayoutTableView;
@end

NS_ASSUME_NONNULL_END
