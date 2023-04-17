//
//  CollectionView.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/16.
//

#import "CollectionView.h"
#import "CollectionTableViewCell.h"
#import "UIImageView+WebCache.h"

#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation CollectionView

- (void) LayoutSelf {
    
    self.arrayURL = [[NSMutableArray alloc] init];
    self.arrayImage = [[NSMutableArray alloc] init];
    self.arrayTitle = [[NSMutableArray alloc] init];
    //1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", doc);
    NSString *fileName = [doc stringByAppendingPathComponent:@"collectionData.sqlite"];
    
    //2.获得数据库
    self.collectionDatabase = [FMDatabase databaseWithPath:fileName];
    
    if ([self.collectionDatabase open]) {
        FMResultSet* resultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        while ([resultSet next]) {
            NSString* URL = [resultSet stringForColumn:@"URL"];
            [self.arrayURL addObject:URL];
            
            NSString* labelStr = [resultSet stringForColumn:@"labelStr"];
            [self.arrayTitle addObject:labelStr];
            
            NSString* imageURL = [resultSet stringForColumn:@"imageURL"];
            [self.arrayImage addObject:imageURL];
        }
        [self.collectionDatabase close];
    }

    
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    
    self.titleLabel.frame = CGRectMake((Width - 200)/2, 45, 200, 30);
    
    [self addSubview:self.titleLabel];
    
    self.titleLabel.text = @"我的收藏";
    
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.returnButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [self.returnButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    
    self.returnButton.frame = CGRectMake(10, 45, 30, 30);
    
    [self addSubview:self.returnButton];
    
    [self.returnButton addTarget:self action:@selector(returnToSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutTableView];
    
    
}


- (void) layoutTableView {
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.frame = CGRectMake(0, 80, Width, Height - 80);
    
    [self addSubview:self.tableView];
    
    
    
}
//高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
//行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = self.arrayURL.count;
    } else if (section == 1) {
        count = 1;
    }
    return count;
}

//组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //自定义cell
    CollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"111"];

    //非自定义cell
    UITableViewCell* cellUnDefine = [tableView dequeueReusableCellWithIdentifier:@"111"];
    
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
    }
    
    
    if (indexPath.section == 0) {
        cell.labelTitle.text = self.arrayTitle[indexPath.row];
        
        [cell.imageMain sd_setImageWithURL:self.arrayImage[indexPath.row] placeholderImage:[UIImage imageNamed:@"grayColor.jpeg"] options:SDWebImageRefreshCached];
        
    }
    
    
    if (indexPath.section == 1) {
        
        
        if (cellUnDefine == nil) {
            //设置为SelectionStyleNone样式使得无法出现被选中效果
            cellUnDefine = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
        }
        UILabel* labelBack = [[UILabel alloc] init];
        if(self.arrayURL.count == 0) {
            labelBack.text = @"暂无收藏文章";
        } else {
            labelBack.text = @"已展示全部收藏";
        }
        
        
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
    
    return  cell;
}


//cell的点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* stringPage = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToScrollView" object:nil userInfo:@{@"page":stringPage}];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//
//- (void) returnToSettings {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"return" object:nil];
//}
//
//- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.arrayURL removeObjectAtIndex: indexPath.row];
//    [self.arrayImage removeObjectAtIndex:indexPath.row];
//    [self.arrayTitle removeObjectAtIndex:indexPath.row];
//
//    [self deleteWithURL:self.arrayURL[indexPath.row]];
//
//    [self.tableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//
//}
//- (BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void) deleteWithURL:url {
//    if ([self.collectionDatabase open]) {
//
//        NSString *sql = @"delete from collectionData WHERE URL = ? ";
//        BOOL result = [self.collectionDatabase executeUpdate:sql, url];
//        if (!result) {
//            NSLog(@"数据删除失败");
//        } else {
//            NSLog(@"数据删除成功");
//        }
//        [self.collectionDatabase close];
//    }
//}
@end
