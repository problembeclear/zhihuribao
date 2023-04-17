//
//  ScrollViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import "ScrollViewController.h"
#import "OneScrollView.h"
#import "Masonry.h"
#import "CommentViewController.h"
#import "Manage.h"
#import "FMDB.h"


@interface ScrollViewController ()

@property (strong, nonatomic) FMDatabase* collectionDatabase;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoMyPop) name:@"returnToMainView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoMyPush:) name:@"pushToScrollComment" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Collect:) name:@"collectByScrollView" object:nil];
    
    
    
    [[Manage shareManage] NetWorkTestWithData:^(LastNewsModel * _Nonnull mainViewNowModel) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                OneScrollView* viewFromScrollView = [[OneScrollView alloc]init];
                viewFromScrollView.page = self.page;
                
                viewFromScrollView.mydict = [mainViewNowModel toDictionary];
                
                viewFromScrollView.arrayURL = [NSArray arrayWithObjects: self.dictFromMainViewController[@"top_stories"][0][@"url"], self.dictFromMainViewController[@"top_stories"][1][@"url"], self.dictFromMainViewController[@"top_stories"][2][@"url"], self.dictFromMainViewController[@"top_stories"][3][@"url"], self.dictFromMainViewController[@"top_stories"][4][@"url"], nil];
                
                
                [viewFromScrollView LayoutSelf];
                
                [self.view addSubview: viewFromScrollView];
                
                [viewFromScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
            });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    
    
    
    
    
    
    
    
}

- (void) DoMyPop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) DoMyPush:(NSNotification*) notification {
    
    NSDictionary* dict = notification.userInfo;
    
    CommentViewController* commentViewController = [[CommentViewController alloc] init];
    
    commentViewController.myID = [NSString stringWithString:dict[@"id"]];
    
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}


- (void) Collect:(NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    NSString* stringID = dict[@"id"];
    NSString* stringSelected = dict[@"selected"];
    NSString* stringIndex = dict[@"index"];
    
    
    if (self.collectionDatabase == nil) {
        //1.获得数据库文件的路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@", doc);
        NSString *fileName = [doc stringByAppendingPathComponent:@"collectionData.sqlite"];
        
        //2.获得数据库
        self.collectionDatabase = [FMDatabase databaseWithPath:fileName];
        
        //3.打开数据库
        if ([self.collectionDatabase open]) {
            BOOL result = [self.collectionDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS collectionData (URL text NOT NULL, labelStr text NOT NULL, imageURL texr NOT NULL, isSelected text NOT NULL);"];
            if (result) {
                NSLog(@"创表成功");
            } else {
                NSLog(@"创表失败");
            }
        }
    }
    
    if ([stringSelected isEqualToString: @"YES"]) {
        

        //插入数据的方法
        [self insertDataWithID:stringID withTitle:self.dictFromMainViewController[@"top_stories"][[stringIndex integerValue]][@"title"] withImageURL:self.dictFromMainViewController[@"top_stories"][[stringIndex integerValue]][@"image"]
            withSelected:@"YES"];
    }
    
    if ([stringSelected isEqualToString: @"NO"]) {

        //删除数据的方法
        [self deleteDataWithID:stringID withTitle:self.dictFromMainViewController[@"top_stories"][[stringIndex integerValue]][@"title"] withImageURL:self.dictFromMainViewController[@"top_stories"][[stringIndex integerValue]][@"image"]
            withSelected:@"NO"];
    }
    
    
    
    
}

//插入数据
- (void)insertDataWithID:(NSString*) idStr withTitle:(NSString*) stringTitle withImageURL:(NSString*) imageURL withSelected: (NSString*) stringSelected {
    if ([self.collectionDatabase open]) {
        FMResultSet *resultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        //判断数据是否已经添加过了
        NSInteger numForDetermineToSet = 1;
        while ([resultSet next]) {
            NSString* URL = [resultSet stringForColumn:@"URL"];
            if ([URL isEqualToString:idStr]) {
                numForDetermineToSet = 0;
            }
        }
        if (numForDetermineToSet == 1) {
            //添加没有重复的数据
//            NSString* stringURL = [NSString stringWithFormat:@"%@", idStr];
           
            BOOL result = [self.collectionDatabase executeUpdate:@"INSERT INTO collectionData (URL, labelStr, imageURL, isSelected) VALUES (?, ?, ?, ?);", idStr, stringTitle, imageURL, stringSelected];
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
- (void) deleteDataWithID:(NSString*) idStr withTitle:(NSString*) stringTitle withImageURL:(NSString*) imageURL withSelected: (NSString*) stringSelected {
    if ([self.collectionDatabase open]) {
//
//        NSString* stringURL = [NSString stringWithFormat:@"%@", idStr];
        
        NSString *sql = @"delete from collectionData WHERE URL = ? ";
        BOOL result = [self.collectionDatabase executeUpdate:sql, idStr];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            NSLog(@"数据删除成功");
        }
        [self.collectionDatabase close];
    }
}

@end
