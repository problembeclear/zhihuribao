//
//  CollectionTableViewCell.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/21.
//

#import "CollectionTableViewCell.h"

#import "Masonry.h"

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:self.labelTitle];
    
    self.imageMain = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageMain];
    

    return self;
    
    
}


- (void) layoutSubviews {
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        
        make.right.equalTo(self.imageMain).with.offset(-100);
        make.bottom.equalTo(self.contentView).with.offset (-10);
    }];
    
    self.labelTitle.font = [UIFont systemFontOfSize:20];
    self.labelTitle.numberOfLines = 0;
    
    [self.imageMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-30);
        
        
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
}
@end
