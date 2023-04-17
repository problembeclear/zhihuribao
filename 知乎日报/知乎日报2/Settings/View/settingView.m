//
//  settingView.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/2.
//

#import "settingView.h"
#import "settingViewController.h"
@implementation settingView

- (void) LayoutSelf {
    self.backgroundColor = [UIColor whiteColor];
    //大头像
    UIImageView* headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head.jpeg"]];
    
    headImage.layer.cornerRadius = 60;
    headImage.clipsToBounds = YES;
    
    [self addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset([UIScreen mainScreen].bounds.size.width * 0.5 - 60);
        make.top.equalTo(self).with.offset([UIScreen mainScreen].bounds.size.height * 0.15);
        
        make.width.equalTo(@120);
        make.height.equalTo(@120);
        
    }];
    //昵称
    UILabel* nameLabel = [[UILabel alloc]init];
    
    [self addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset([UIScreen mainScreen].bounds.size.width * 0.5 - 90);
        make.top.equalTo(self).with.offset([UIScreen mainScreen].bounds.size.height * 0.3 );
        
        make.width.equalTo(@180);
        make.height.equalTo(@40);
    }];
   
    nameLabel.text = @"   这里有一个昵称";
    nameLabel.font = [UIFont systemFontOfSize:20];
    
    //布局tableView
    [self LayoutTableView];
    
    //设置按钮
    
    UIButton* buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonBack setImage:[UIImage imageNamed:@"xiangzuojiantou.png"] forState:UIControlStateNormal];
    
    [self addSubview:buttonBack];
    
    [buttonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(45);
        
        make.width.equalTo(@40);
        make.height.equalTo(@30);
    }];
    
    [buttonBack addTarget:self action:@selector(returnMyMainView) forControlEvents:UIControlEventTouchUpInside];
}



- (void) LayoutTableView {
    self.tableView = [[UITableView alloc]init];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset([UIScreen mainScreen].bounds.size.height * 0.4);
        
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.height.equalTo(@120);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"123"];
    
    //分配内存空间并按复用ID初始化
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    
    //设置一下cell右侧箭头，如果设置，那么
    //上面的cell初始化时的style必须是Default，因为这才是可以设定的style
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel* cellLabel = [[UILabel alloc]init];
    
    cellLabel.font = [UIFont systemFontOfSize:18];
    
    [cell.contentView addSubview:cellLabel];
    
    cellLabel.frame = CGRectMake(15, 5, 150, 50);
    
    if (indexPath.row == 0) {
        cellLabel.text = @"我的收藏";
    } else if (indexPath.row == 1) {
        cellLabel.text = @"消息中心";
    }
    
    return cell;
}



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushInSettingViewController" object:nil userInfo:@{}];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) returnMyMainView {
    [self.delegate popToMainView];
}

@end
