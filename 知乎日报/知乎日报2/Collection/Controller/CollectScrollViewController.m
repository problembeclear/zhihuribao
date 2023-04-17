//
//  CollectScrollViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/26.
//

#import "CollectScrollViewController.h"
#import "CollectScrollView.h"
#import "CommentViewController.h"
#import "Masonry.h"
#import "FMDB.h"
@interface CollectScrollViewController ()

@property (strong, nonatomic) FMDatabase* collectionDatabase;

@end

@implementation CollectScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnBack) name:@"returnToCollectionView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Collect:) name:@"collectByScrollView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToComments:) name:@"pushToScrollComment" object:nil];
    
    
    CollectScrollView* collectView = [[CollectScrollView alloc] init];
    
    collectView.page = [self.stringPage integerValue];
    
    [self.view addSubview:collectView];
    
    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [collectView LayoutSelf];
    
    
    
    
}

- (void) returnBack {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
}
- (void) pushToComments:(NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    CommentViewController* commentViewController = [[CommentViewController alloc] init];
    
    commentViewController.myID = [NSString stringWithString:dict[@"url"]];
    
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}


- (void) Collect:(NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    NSString* stringURL = dict[@"url"];
    NSString* stringTitle = dict[@"title"];
    NSString* stringImage = dict[@"imageURL"];
    
    NSString* stringSelected = dict[@"selected"];
    NSString* stringIndex = dict[@"index"];
    
    
    
//    NSInteger index = [stringIndex integerValue];
    
    NSLog(@"index是:%@", stringIndex);
    
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
//    NSInteger theSection = index / 6;
//
//    NSInteger theRow = index % 6;

    
    if ([stringSelected isEqualToString: @"YES"]) {
        
        //插入数据的方法
        [self insertDataWithURL:stringURL withTitle:stringTitle withImageURL:stringImage withSelected:@"YES"];
        
    }
    
    if ([stringSelected isEqualToString: @"NO"]) {
        //删除数据的方法
        [self deleteDataWithURL:stringURL withTitle:stringTitle withImageURL:stringImage withSelected:@"NO"];
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
