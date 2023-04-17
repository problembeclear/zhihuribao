//
//  TableViewCell.h
//  知乎日报
//
//  Created by 张思扬 on 2022/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* cellImage;

@property (strong, nonatomic) UILabel* cellLabelTitle;

@property (strong, nonatomic) UILabel* cellLabelDetails;

@end

NS_ASSUME_NONNULL_END
