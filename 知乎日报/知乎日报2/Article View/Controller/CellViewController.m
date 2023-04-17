//
//  CellViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import "CellViewController.h"
#import "CellView.h"
#import "Masonry.h"
#import "CommentViewController.h"
#import "Manage.h"

@interface CellViewController ()

@property (strong, nonatomic) CellView* viewFromCell;

@property (strong, nonatomic) FMDatabase* collectionDatabase;

@end

@implementation CellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoMyPop) name:@"returnToMainView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoMyPush:) name:@"pushToCellComment" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyNews:) name:@"getNews" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Collect:) name:@"collectByCellView" object:nil];
    
    self.arrayToStoreDictionary = [[NSMutableArray alloc] init];
    //添加第一个字典
    [self.arrayToStoreDictionary addObject:self.testDictionary];
    //添加数组里的字典
    [self.arrayToStoreDictionary addObjectsFromArray:self.testArray];
    
    self.page = (self.testIndex.section - 1) * 6 + self.testIndex.row + 1;

    [self LayoutCellView];
}

- (void) LayoutCellView {
    self.viewFromCell = [[CellView alloc]init];
  
    self.viewFromCell.allDictionaryArray = [[NSMutableArray alloc] init];
    
    self.viewFromCell.indexPath = self.testIndex;
    [self.viewFromCell.allDictionaryArray addObject:self.testDictionary];
    for (NSInteger i = 0; i < self.testArray.count; i++) {
        [self.viewFromCell.allDictionaryArray addObject:self.testArray[i]];
    }
    
    self.viewFromCell.pageCountInScrollView = (self.testIndex.section - 1) * 6 + self.testIndex.row+1;
    
    
 
    
    if (self.testArray.count == 0) {
        self.viewFromCell.nowStringDate = [NSString stringWithString:self.testDictionary[@"date"]];
    } else {
        if (self.testIndex.section == 1) {
            self.viewFromCell.nowStringDate = [NSString stringWithString:self.testDictionary[@"date"]];
        } else if (self.testIndex.section > 1) {
            self.viewFromCell.nowStringDate = [NSString stringWithString:self.testArray[self.testIndex.section - 2][@"date"]];
        }
        
    }

    
    [self.viewFromCell LayoutSelf];
    
    [self.view addSubview:self.viewFromCell];
    
    [self.viewFromCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).width.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
//返回
- (void) DoMyPop {
    [self.viewFromCell removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

//进入评论界面
- (void) DoMyPush: (NSNotification*) notification {
    
    NSDictionary* dict = notification.userInfo;
    
    CommentViewController* commentViewController = [[CommentViewController alloc] init];
    
    commentViewController.myID = [NSString stringWithString:dict[@"id"]];
    
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}
//获取新的信息
- (void) getMyNews:(NSNotification*) notification {
    
    
    NSDictionary* dict = notification.userInfo;
    
    //前缀
    NSString* stringTest = @"https://news-at.zhihu.com/api/4/news/before/";
    //可变的URL的字符串
    self.stringMutable = [[NSString alloc]initWithString:stringTest];
    //给字符串拼接日期字符串
    self.stringMutable = [self.stringMutable stringByAppendingString: dict[@"date"]];
    //
    
    NSString* dateString = [NSString stringWithString:dict[@"date"]];
    //循环三次网络请求然后添加cell，然后保留一个只含数字的日期字符串

    [[Manage shareManage] NetWorkTestWithPreviousData:^(PreviousModel * _Nonnull mainViewModel) {
        //向MainViewController传值
        NSDictionary* dictionary = [mainViewModel toDictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDictionary" object:nil userInfo:dictionary];
        
    
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加字典
            [self.viewFromCell.allDictionaryArray addObject:[mainViewModel toDictionary]];
            
            self.viewFromCell.pageCountInScrollView += 1;
            
            [self.viewFromCell LayoutSelf];
        });
        
        
        
        NSLog(@"请求成功");
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } JSON:self.stringMutable];
    
    //然后让日期向前挪一天，加起来一共请求三天数据
    
    NSDate* date = [self getTimeBeforeWithDay:1 string:dateString];
    
    NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
    //获取了前一天的的日期字符串
    [myFormatter setDateFormat:@"YYYYMMdd"];
    dateString = [myFormatter stringFromDate:date];
    
    //再把stringMuatble重新赋值
    self.stringMutable = [stringTest stringByAppendingString:dateString];
    
    //最后属性传值把MainView中的nowStringDate修改成一天前，下次申请从一天前的日期开始向前
    self.viewFromCell.nowStringDate = dateString;
    
    
}

//得到当天的前一天的日期
- (NSDate*) getTimeBeforeWithDay: (NSInteger) day string:(NSString*) stringDate {
    NSDateFormatter* formatterTest = [[NSDateFormatter alloc]init];
    [formatterTest setDateFormat:@"YYYYMMdd"];
    
    NSDate* nowDate = [formatterTest dateFromString:stringDate];
    NSDate* theDate;
    
    if (day != 0) {
        NSTimeInterval oneDay = 24 * 60 * 60;
        
        theDate = [nowDate dateByAddingTimeInterval: - oneDay * day];
        
    } else {
        theDate = nowDate;
    }
    return theDate;
}

- (void) Collect:(NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    NSString* stringURL = dict[@"url"];
    NSString* stringSelected = dict[@"selected"];

    
  
    if (self.collectionDatabase == nil) {
        //1.获得数据库文件的路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@", doc);
        NSString *fileName = [doc stringByAppendingPathComponent:@"collectionData.sqlite"];
        
        //2.获得数据库
        self.collectionDatabase = [FMDatabase databaseWithPath:fileName];
        
        //3.打开数据库
        if ([self.collectionDatabase open]) {
            BOOL result = [self.collectionDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS collectionData (URL text NOT NULL, labelStr text NOT NULL, imageURL text NOT NULL, isSelected text NOT NULL);"];
            if (result) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
        }
    }
    
    NSInteger theSection = (self.viewFromCell.pageCountInScrollView - 1) / 6;
    
    NSInteger theRow = (self.viewFromCell.pageCountInScrollView - 1) % 6;

    
    if ([stringSelected isEqualToString: @"YES"]) {
        
        //插入数据的方法
        [self insertDataWithURL:stringURL withTitle:self.arrayToStoreDictionary[theSection][@"stories"][theRow][@"title"] withImageURL:self.arrayToStoreDictionary[theSection][@"stories"][theRow][@"images"][0] withSelected:@"YES"];
        
    }
    
    if ([stringSelected isEqualToString: @"NO"]) {
        //删除数据的方法
        [self deleteDataWithURL:stringURL withTitle:self.arrayToStoreDictionary[theSection][@"stories"][theRow][@"title"] withImageURL:self.arrayToStoreDictionary[theSection][@"stories"][theRow][@"images"] withSelected:@"NO"];
    }
}



//插入数据
- (void)insertDataWithURL:(NSString*) url withTitle:(NSString*) stringTitle withImageURL:(NSString*) imageURL withSelected:(NSString*) stringSelected {
    if ([self.collectionDatabase open]) {
        FMResultSet *resultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        //判断数据是否已经添加过了
        NSInteger numForDetermineToSet = 1;
        while ([resultSet next]) {
            NSString* URL = [resultSet stringForColumn:@"URL"];
            if ([URL isEqualToString:url]) {
                numForDetermineToSet = 0;
            }
        }
        if (numForDetermineToSet == 1) {
            BOOL result = [self.collectionDatabase executeUpdate:@"INSERT INTO collectionData (URL, labelStr, imageURL, isSelected) VALUES (?, ?, ?, ?);", url, stringTitle, imageURL, stringSelected];
            if (!result) {
                NSLog(@"增加数据失败");
            }else{
                NSLog(@"增加数据成功");
            }
        }
            [self.collectionDatabase close];
    }
}

//删除数据
- (void) deleteDataWithURL:(NSString*) url withTitle:(NSString*) stringTitle withImageURL:(NSString*) imageURL withSelected:(NSString*) stringSelected {
    if ([self.collectionDatabase open]) {
        
        NSString *sql = @"delete from collectionData WHERE URL = ? ";
        BOOL result = [self.collectionDatabase executeUpdate:sql, url];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.collectionDatabase close];
    }
}
@end
