//
//  TableViewCell.m
//  知乎日报
//
//  Created by 张思扬 on 2022/10/19.
//

#import "TableViewCell.h"
#import "Masonry.h"

#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation TableViewCell

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
    
    self.cellImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.cellImage];
    
    self.cellLabelTitle = [[UILabel alloc]init];
    [self.contentView addSubview:self.cellLabelTitle];
    
    self.cellLabelDetails = [[UILabel alloc]init];
    [self.contentView addSubview:self.cellLabelDetails];
    
    return self;
    
}

//此方法用来为button label等设置位置、文字、图片、风格颜色等特性
- (void) layoutSubviews {
    //ImageView
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(self.frame.size.width*0.75);
        
        make.top.equalTo(self.contentView).with.offset(15);
        
        make.width.equalTo(@80);
        make.height.equalTo(@80);
   }];
    
    
    
    
    
    
    
    
    //LabelTitle
    [self.cellLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //快捷布局，一行结束
        //顺序是上，左，下，右
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(15, 20, 55, 130));
        
    }];
    
    
    
    self.cellLabelTitle.font = [UIFont systemFontOfSize:19];
    
    //LabelDetails
    [self.cellLabelDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        //仍然用快捷布局，上左下右
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(65, 20, 10, 130));
    }];
    
    
    self.cellLabelDetails.textColor = [UIColor grayColor];
    self.cellLabelDetails.font = [UIFont systemFontOfSize:13];
}






@end
