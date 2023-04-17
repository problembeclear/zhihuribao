//
//  CommentTableViewCell.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* author;

@property (strong, nonatomic) UIImageView* avatar;

@property (strong, nonatomic) UILabel* content;

@property (strong, nonatomic) UILabel* time;

@property (strong, nonatomic) UIButton* more;

@property (strong, nonatomic) UIButton* likes;

@property (strong, nonatomic) UIButton* replyButton;
 
@property (strong, nonatomic) UILabel* likeCount;

@property (strong, nonatomic) UIView* separatorView;

@property (strong, nonatomic) UILabel* labelReply;

@end

NS_ASSUME_NONNULL_END
