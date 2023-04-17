//
//  CommentView.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import "CommentView.h"
#import "Masonry.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"


#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation CommentView

- (void) LayoutSelf {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.myArray = [[NSMutableArray alloc] init];
    
    self.myArray = self.myDictionary[@"comments"];
    
    self.arraySetButton = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.myArray.count; i++) {
        [self.arraySetButton addObject:@"0"];
    }
    

    
    
    [self LayoutReturnButton];
    
    [self LayoutTitle];
    
    [self LayoutTableView];
    
}
//设置按钮
- (void) LayoutReturnButton {
    UIButton* buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonBack setImage:[UIImage imageNamed:@"xiangzuojiantou.png"] forState:UIControlStateNormal];
    
    [self addSubview:buttonBack];
    
    [buttonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(45);
        
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
    [buttonBack addTarget:self action:@selector(returnLastView) forControlEvents:UIControlEventTouchUpInside];
    
}

//设置标题
- (void) LayoutTitle {
    UILabel* titleLabel = [[UILabel alloc] init];
    
    NSString* stringTitle = [NSString stringWithFormat:@"%ld条短评", self.myArray.count];
    
    titleLabel.text = stringTitle;
    
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(150);
        
        make.top.equalTo(self).with.offset(45);
        
        make.width.equalTo(@128);
        
        make.height.equalTo(@30);
    }];
    
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
}

//返回按钮点击事件
- (void) returnLastView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popBack" object:nil];
}


//布局tableView
- (void) LayoutTableView {
    self.tableView = [[UITableView alloc]init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(75);
        
        make.width.equalTo(@(Width));
        make.height.equalTo(@(Height));
    }];
}


//组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    
    if (section == 0) {
        rowCount = self.myArray.count;
    }
    if (section == 1) {
        rowCount = 1;
    }
    return  rowCount;
}
//设置cell
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //自定义cell
    NSString* idString = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row];
    CommentTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:idString];
    //非自定义cell
    UITableViewCell* cellUnDefine = [self.tableView dequeueReusableCellWithIdentifier:@"111"];
    
    if (indexPath.section == 0) {
        
        
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"123"];
        }
        
      
        cell.author.text = self.myDictionary[@"comments"][indexPath.row][@"author"];
        
        cell.content.text = self.myDictionary[@"comments"][indexPath.row][@"content"];
        
        [cell.avatar sd_setImageWithURL:self.myDictionary[@"comments"][indexPath.row][@"avatar"] placeholderImage:[UIImage imageNamed:@"head.jpeg"] options:SDWebImageRefreshCached];
        
        //如何将数字时间转化为正常时间
        NSString *time = self.myDictionary[@"comments"][indexPath.row][@"time"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
        
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.time.text = confromTimespStr;
        
        cell.time.textColor = [UIColor grayColor];
        
        //点赞数
        NSString* stringCount = [NSString stringWithFormat:@"%@", self.myDictionary[@"comments"][indexPath.row][@"likes"]];
        if ([stringCount isEqualToString:@"0"]) {
            
        } else {
            cell.likeCount.text = stringCount;
        }
        
        //有回复
        if (self.myDictionary[@"comments"][indexPath.row][@"reply_to"] != nil) {
            

            NSMutableString* stringReply = [NSMutableString stringWithFormat:@"// %@: %@", self.myDictionary[@"comments"][indexPath.row][@"reply_to"][@"author"], self.myDictionary[@"comments"][indexPath.row][@"reply_to"][@"content"]];
            
            cell.labelReply.text = stringReply;
     
            
            CGSize labelReplySize = [cell.labelReply.text boundingRectWithSize:CGSizeMake(Width - 40 - 50 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            
            [cell.contentView addSubview:cell.labelReply];
            
            
            //修改高度数组。并确定需不需要展开按钮
            if (labelReplySize.height > 55) {
                
                CGFloat heightMod = [self.arrayForHeight[indexPath.row] floatValue] + 55;
                self.arrayForHeight[indexPath.row] = [NSString stringWithFormat:@"%lf", heightMod];
                
                
                //展开按钮
                
                UIButton* buttonExtend ;
                if (buttonExtend == nil) {
                    buttonExtend = [UIButton buttonWithType:UIButtonTypeCustom];
                }
                
                buttonExtend.tag = indexPath.row;
                
                [buttonExtend addTarget:self action:@selector(extend:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:buttonExtend];
                
                [buttonExtend mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.time.mas_right).with.offset(0);
                    make.bottom.equalTo(cell.contentView).with.offset(-5);
                    
                    make.width.equalTo(@40);
                    make.height.equalTo(@30);
                }];
                
                [buttonExtend setTitle:@"展开" forState:UIControlStateNormal];
                [buttonExtend setTitle:@"收起" forState:UIControlStateSelected];
                
                [buttonExtend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
                if ([self.arraySetButton[indexPath.row] isEqualToString:@"1"]) {
                    buttonExtend.selected = YES;
                    cell.labelReply.numberOfLines = 0;
                } else {
                    buttonExtend.selected = NO;
                    cell.labelReply.numberOfLines = 2;
                }
            }
            
            
            
            
            
        } else {
            //无回复
            
        }
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        
        if (cellUnDefine == nil) {
            //设置为SelectionStyleNone样式使得无法出现被选中效果
            cellUnDefine = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
        }
        UILabel* labelBack = [[UILabel alloc] init];
        
        labelBack.text = @"已显示全部短评";
        
        labelBack.textColor = [UIColor grayColor];
        
        labelBack.frame = CGRectMake(0, 0, Width, 80);
        
        [cellUnDefine.contentView addSubview:labelBack];
        
        labelBack.textAlignment = NSTextAlignmentCenter;
        
        labelBack.font = [UIFont systemFontOfSize:17];
        
        cellUnDefine.selected = NO ;
        //给cell设置选中样式
        cellUnDefine.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cellUnDefine;
    }
    

    return cell;
}


- (void) extend:(UIButton *) button{
    
    if(button.selected == YES) {
        button.selected = NO;
        self.arraySetButton[button.tag] = @"0";
        
    } else {
        button.selected = YES;
        self.arraySetButton[button.tag] = @"1";
    }
    
 
    [self.tableView reloadData];
    
}



@end
