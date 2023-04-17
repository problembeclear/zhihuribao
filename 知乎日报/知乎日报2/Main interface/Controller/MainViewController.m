//
//  ViewController.m
//  知乎日报
//
//  Created by 张思扬 on 2022/10/12.
//

#import "MainViewController.h"
#import "FMDB.h"
#import "Manage.h"
#import "settingViewController.h"
#import "ScrollViewController.h"
#import "CellViewController.h"

#define width self.view.frame.size.width
#define height self.view.frame.size.height
@interface MainViewController ()


@property (nonatomic, strong) NSLock* lock;


@property (strong, nonatomic) MainView* mainView;



@property (strong, nonatomic) NSString* stringMutable;

@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lock = [[NSLock alloc] init];
    
    
   
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCell:) name:@"Refresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getToScroll:) name:@"getToScrollView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getToCell:) name:@"getToCellView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNews:) name:@"getDictionary" object:nil];
    
    [self LayoutMainView];
    
    
}
//布局MainView
- (void) LayoutMainView {
    
    self.mainView = [[MainView alloc]init];
    self.mainView.dictionaryLastNews = [[NSDictionary alloc]init];

    self.mainView.allDictionaryArray = [[NSMutableArray alloc]init];
    
    self.mainView.nowStringDate = [[NSString alloc]init];
    
    //签订对象
    self.mainView.pushDelegate = self;
    
    
    //网络请求一个字典给mainView
    [[Manage shareManage] NetWorkTestWithData:^(LastNewsModel * _Nonnull mainViewNowModel) {
        self.mainView.dictionaryLastNews = [mainViewNowModel toDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mainView.dictionaryLastNews = [mainViewNowModel toDictionary];
            //获取最新一组文章时间
            self.mainView.nowStringDate = self.mainView.dictionaryLastNews[@"date"];
            
            
            
            [self.mainView Init];
        });
        NSLog(@"请求成功");
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
    self.mainView.frame = CGRectMake(0, 0, width, height);
    
    [self.view addSubview:self.mainView];
    
    
}



- (void) pushControllerToSetting {
    
    settingViewController* settingController = [[settingViewController alloc]init];
    
//    settingController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self.navigationController pushViewController:settingController animated:YES];
}
//上拉获取更多cell
- (void) RefreshCell:(NSNotification*) notification {
    
    // 网络请求
    
    NSDictionary* dict = notification.userInfo;
    
    //前缀
    NSString* stringTest = @"https://news-at.zhihu.com/api/4/news/before/";
    //可变的URL的字符串
    self.stringMutable = [[NSString alloc]initWithString:stringTest];
    //给字符串拼接日期字符串
    self.stringMutable = [self.stringMutable stringByAppendingString: dict[@"Date"]];
    //
    
    NSString* dateString = [NSString stringWithString:dict[@"Date"]];
    //循环三次网络请求然后添加cell，然后保留一个只含数字的日期字符串
    for (int i = 0; i < 3; i++) {
        [self.lock lock];
        
        [[Manage shareManage] NetWorkTestWithPreviousData:^(PreviousModel * _Nonnull mainViewModel) {

            [self.mainView.allDictionaryArray addObject:[mainViewModel toDictionary]];
            
            self.mainView.cellCount += 1;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainView.tableView reloadData];
            });
        [self.lock unlock];
            
            
            
            NSLog(@"请求成功");
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        } JSON:(NSString*) self.stringMutable];
        
        //然后让日期向前挪一天，加起来一共请求三天数据
        
        NSDate* date = [self getTimeBeforeWithDay:1 string:dateString];
        
        NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
        //获取了前一天的的日期字符串
        [myFormatter setDateFormat:@"YYYYMMdd"];
        dateString = [myFormatter stringFromDate:date];
        
        //再把stringMuatble重新赋值
        self.stringMutable = [stringTest stringByAppendingString:dateString];
        
        //最后属性传值把MainView中的nowStringDate修改成一天前，下次申请从一天前的日期开始向前
        self.mainView.nowStringDate = dateString;
        

    }

    
    
   
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


- (void) getToScroll: (NSNotification*) notification {
    
    NSDictionary* dict = notification.userInfo;
    
    NSInteger page = [dict[@"page"] integerValue];
    
    ScrollViewController* scrollViewController = [[ScrollViewController alloc]init];

    
    scrollViewController.dictFromMainViewController = [[NSDictionary alloc]initWithDictionary:self.mainView.dictionaryLastNews];
    //page: 1到5
    scrollViewController.page = page;
    
    [self.navigationController pushViewController:scrollViewController animated:YES];
    
}


- (void) getToCell: (NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    CellViewController* cellViewController = [[CellViewController alloc]init];
    
    cellViewController.testDictionary = dict[@"LastNews"];
    cellViewController.testArray = dict[@"PreviousNews"];
    cellViewController.testIndex = dict[@"index"];
    
    
    [self.navigationController pushViewController:cellViewController animated:YES];
}


- (void) addNews:(NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    
    [self.mainView.allDictionaryArray addObject:dict];
    
    self.mainView.cellCount += 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainView.tableView reloadData];
    });
    
}
@end
