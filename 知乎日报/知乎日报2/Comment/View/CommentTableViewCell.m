//
//  CommentTableViewCell.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import "CommentTableViewCell.h"
#import "Masonry.h"

#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    
    self.author = [[UILabel alloc] init];
    [self.contentView addSubview:self.author];
    
    self.avatar = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatar];
    
    self.content = [[UILabel alloc] init];
    [self.contentView addSubview: self.content];
    
    self.time = [[UILabel alloc] init];
    [self.contentView addSubview: self.time];
    
    self.more = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview: self.more];
    
    self.likes = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview: self.likes];
    
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview: self.replyButton];
    
    self.likeCount = [[UILabel alloc] init];
    [self.contentView addSubview:self.likeCount];
    
    self.separatorView = [[UIView alloc] init];
    [self.contentView addSubview:self.separatorView];
    
    self.labelReply = [[UILabel alloc] init];
    [self.contentView addSubview:self.labelReply];
    
    
    self.content.numberOfLines = 0;
    [self.content setLineBreakMode:NSLineBreakByWordWrapping];
    self.content.font = [UIFont systemFontOfSize:17];


    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        //由于要自适应的cell，所以不用宽高约束
        make.left.equalTo(self.author).with.offset(0);
        make.top.equalTo(self.contentView).with.offset(50);
        make.right.equalTo(self.contentView).with.offset(-40);
        make.bottom.equalTo(self.labelReply.mas_top).offset(-10);
    }];
    
    
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);

        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

    self.avatar.layer.cornerRadius = 15;
    self.avatar.clipsToBounds = YES;


    [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar).with.offset(30 + 10);
        make.top.equalTo(self.avatar).with.offset(0);

        make.width.equalTo(@180);
        make.height.equalTo(@30);

    }];

    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(50);
        make.bottom.equalTo(self.contentView).with.offset(-10);

        make.width.equalTo(@100);
        make.height.equalTo(@20);

    }];

    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(Width - 30 - 10);
        make.top.equalTo(self.contentView).with.offset(10);

        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.likes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-50);
        make.bottom.equalTo(self.contentView).with.offset(-10);

        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-10);

        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(Width - 60 - 20 - 30);
        make.bottom.equalTo(self.contentView).with.offset(-10);

        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];

    self.likeCount.textAlignment = NSTextAlignmentCenter;

    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(-1);

        make.width.equalTo(@(Width));
        make.height.equalTo(@0.4);
    }];
    
    [self.labelReply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left).with.offset(0);
        make.right.equalTo(self.content.mas_right).with.offset(0);

        make.top.equalTo(self.content.mas_bottom).with.offset(10);

        make.bottom.equalTo(self.time.mas_top).offset(-15);
    }];
    
    //行数是2
    self.labelReply.numberOfLines = 2;
    
    self.labelReply.font = [UIFont systemFontOfSize:17];
    
    self.labelReply.textColor = [UIColor grayColor];
    
    [self.labelReply setLineBreakMode:NSLineBreakByWordWrapping];
    
    return self;
}

- (void) layoutSubviews {

    
    
    self.separatorView.backgroundColor = [UIColor grayColor];

    [self.more setImage:[UIImage imageNamed:@"gengduo.png"] forState:UIControlStateNormal];

    [self.replyButton setImage:[UIImage imageNamed:@"pinglunxiao.png"] forState:UIControlStateNormal];
    
    [self.likes setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];


}


@end
