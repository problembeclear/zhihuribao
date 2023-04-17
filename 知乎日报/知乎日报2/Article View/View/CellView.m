//
//  CellView.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import "CellView.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>


#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation CellView

- (void) LayoutSelf {
    
    //获取数据库路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"collectionData.sqlite"];
    
    //2.获得数据库
    self.collectionDatabase = [FMDatabase databaseWithPath:fileName];
    
    
    self.arrayForButtonState = [[NSMutableArray alloc] init];
    if ([self.collectionDatabase open]) {
        FMResultSet* resultSet = [self.collectionDatabase executeQuery:@"SELECT * FROM collectionData"];
        while([resultSet next]) {
            NSString* URL = [resultSet stringForColumn:@"URL"];
            if (URL != nil) {
                [self.arrayForButtonState addObject:URL];
            }
            
        }
        [self.collectionDatabase close];
    }
    
    self.url = [[NSString alloc] init];
    
    self.arrayForbidRequest = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 1000; i++) {
        [self.arrayForbidRequest addObject:@""];
    }
    
    
    self.backgroundColor = [UIColor systemGray6Color];
    //布局下方栏
    [self LayoutTabBar];
    //布局背景色
    [self setNavigationColor];
    //布局滚动视图
    [self LayoutScrollView];
    
    
  
    
    
}




- (void) LayoutTabBar {
    //返回
    UIButton* buttonReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonReturn setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    
    [buttonReturn addTarget:self action:@selector(returnToMainView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonReturn];
    
    //评论
    UIButton* buttonComment = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [buttonComment setImage:[UIImage imageNamed:@"pinglunxiao.png"] forState:UIControlStateNormal];
    
    [buttonComment addTarget:self action:@selector(pushToComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonComment];
    
    //点赞
    self.buttonLikes = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.buttonLikes setImage:[UIImage imageNamed:@"like1.png"] forState:UIControlStateNormal];
    
    [self.buttonLikes setImage:[UIImage imageNamed:@"like2.png"] forState:UIControlStateSelected];
    
    [self.buttonLikes addTarget:self action:@selector(likes) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.buttonLikes];
    
    //收藏
    self.buttonCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.buttonCollect setImage:[UIImage imageNamed:@"collect1.png"] forState:UIControlStateNormal];
    
    [self.buttonCollect setImage:[UIImage imageNamed:@"collect2.png"] forState:UIControlStateSelected];
    
    [self.buttonCollect addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.buttonCollect];
    
    //分享
    UIButton* buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonShare setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    [buttonShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonShare];
    
    
    
    [buttonReturn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(Height * 0.92 + 10);
        
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [buttonComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10 + 60 * 1 + 30 * 1);
        make.top.equalTo(self).with.offset(Height * 0.92 + 10);
        
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [self.buttonLikes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10 + 60 * 2 + 30 * 2);
        make.top.equalTo(self).with.offset(Height * 0.92 + 10);
        
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [self.buttonCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10 + 60 * 3 + 30 * 3);
        make.top.equalTo(self).with.offset(Height * 0.92 + 10);
        
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [buttonShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10 + 60 * 4 + 30 * 4);
        make.top.equalTo(self).with.offset(Height * 0.92 + 10);
        
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UIImageView* imageGray = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grayColor.jpeg"]];
    
    [self addSubview: imageGray];
    
    [imageGray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(65);
        make.top.equalTo(self).with.offset(Height * 0.92 + 5);
        
        make.width.equalTo(@2);
        make.height.equalTo(@35);
    }];
    
    
    NSInteger theSection = (self.pageCountInScrollView - 1) / 6;

    NSInteger theRow = (self.pageCountInScrollView - 1 ) % 6;
    
    
    self.url = self.allDictionaryArray[theSection][@"stories"][theRow][@"url"];
    for (int i = 0; i < self.arrayForButtonState.count; i++) {

        
        if ([self.arrayForButtonState[i] isEqualToString: self.url]) {
 
            self.buttonCollect.selected = true;
            break;
        }
        
        self.buttonCollect.selected = false;
    }

    
}

- (void) setNavigationColor {
    
    UIView* viewBackground = [[UIView alloc]init];
    
    viewBackground.backgroundColor = [UIColor whiteColor];
    
    viewBackground.frame = CGRectMake(0, 0, Width, Height * 0.92);
    
    [self addSubview:viewBackground];
    
}


- (void) LayoutScrollView {
    
    self.scrollView = [[UIScrollView alloc]init];
    
    
    self.scrollView.delegate = self;
    
    self.scrollView.frame = CGRectMake(0, 40, Width, Height * 0.92 - 40);
    
    [self addSubview: self.scrollView];
    
    CGFloat contentWidth = Width * (self.allDictionaryArray.count * 6);
    
    //将contentSize高度设为0，在横向拖动时就不会发生纵向的移动
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.scrollEnabled = YES;
    
    if ([self.arrayForbidRequest[self.pageCountInScrollView] isEqualToString:@""]) {
        WKWebView* wkWebView = [[WKWebView alloc]init];
        
        [self.scrollView addSubview:wkWebView];
        
        [self.scrollView setContentOffset:CGPointMake((self.pageCountInScrollView - 1) * Width, 0)];
        
        wkWebView.frame = CGRectMake((self.pageCountInScrollView - 1) * Width, 0, Width, Height * 0.92);
        
        NSString* urlString = [[NSString alloc] init];
        
        self.url = [[NSString alloc] init];
        
        NSInteger theSection = (self.pageCountInScrollView - 1) / 6;
        
        NSInteger theRow = (self.pageCountInScrollView - 1 ) % 6;
        
      
        self.url = self.allDictionaryArray[theSection][@"stories"][theRow][@"url"];
        
        urlString = self.url;
        
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
        
        [wkWebView loadRequest:request];
        
        self.arrayForbidRequest[self.pageCountInScrollView] = @"completed";
    }
    
    
    
   
    
}

//当滚动视图开始减速
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat LastWidth = (self.pageCountInScrollView - 1) * Width;
    
    //视图向左滑动触发
    if(scrollView.contentOffset.x < LastWidth) {
        self.pageCountInScrollView --;
        NSLog(@"%ld", self.pageCountInScrollView);
//        [self LayoutWebView];
    }
    //视图向右滑动触发
    if(scrollView.contentOffset.x > LastWidth ) {
        self.pageCountInScrollView ++;
        NSLog(@"%ld", self.pageCountInScrollView);
//        [self LayoutWebView];
    } else if (scrollView.contentOffset.x > LastWidth - Width * 1 + 20 && self.pageCountInScrollView >= self.allDictionaryArray.count * 6) {
        
        //获取新的article
        self.nowStringDate = [NSString stringWithString:self.allDictionaryArray.lastObject[@"date"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getNews" object:nil userInfo:@{@"date":self.nowStringDate}];
    }
    [self LayoutWebView];
    
    NSInteger theSection = (self.pageCountInScrollView - 1) / 6;
    
    NSInteger theRow = (self.pageCountInScrollView - 1 ) % 6;
    
  
    self.url = self.allDictionaryArray[theSection][@"stories"][theRow][@"url"];
    
    for (int i = 0; i < self.arrayForButtonState.count; i++) {
        
        if ([self.arrayForButtonState[i] isEqualToString: self.url]) {
            self.buttonCollect.selected = true;
            break;
        }
        self.buttonCollect.selected = false;
    }

    
}

- (void) LayoutWebView {
    if ([self.arrayForbidRequest[self.pageCountInScrollView] isEqualToString: @""]) {
        WKWebView* wkWebView = [[WKWebView alloc]init];
        
        wkWebView.frame = CGRectMake((self.pageCountInScrollView - 1) * Width, 0, Width, Height * 0.92);
        
        NSString* urlString = [[NSString alloc] init];
        
        
        
        NSInteger theSection = (self.pageCountInScrollView - 1) / 6;

        NSInteger theRow = (self.pageCountInScrollView - 1 ) % 6;
        
        
        self.url = self.allDictionaryArray[theSection][@"stories"][theRow][@"url"];
        
        urlString = self.url;
        
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
        
        [wkWebView loadRequest:request];
        
        self.arrayForbidRequest[self.pageCountInScrollView] = @"completed";
        
        [self.scrollView addSubview:wkWebView];
        
        wkWebView.frame = CGRectMake((self.pageCountInScrollView - 1) * Width, 0, Width, Height * 0.92);
    }
    

    
}


- (void) returnToMainView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnToMainView" object:nil];
}

- (void) pushToComment {
    NSInteger theSection = (self.pageCountInScrollView - 1) / 6;
    
    NSInteger theRow = (self.pageCountInScrollView - 1 ) % 6;
    
    NSString* idStr = [[NSString alloc] init];
    
    idStr = [self.allDictionaryArray[theSection][@"stories"][theRow][@"id"] stringValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToCellComment" object:nil userInfo:@{@"id":idStr}];

}


- (void) likes {
    if (self.buttonLikes.selected == YES) {
        self.buttonLikes.selected = NO;
    } else {
        self.buttonLikes.selected = YES;
    }
}

- (void) collect {
    NSString* stringSelected;
    if (self.buttonCollect.selected == YES) {
        self.buttonCollect.selected = NO;
        
        stringSelected = @"NO";
    } else {
        self.buttonCollect.selected = YES;
        
        stringSelected = @"YES";
    }
    
    NSString* stringIndex = [NSString stringWithFormat:@"%ld", self.pageCountInScrollView - 1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectByCellView" object:nil userInfo:@{@"url":self.url, @"selected":stringSelected, @"index":stringIndex}];
    
    
    
    
    
}

- (void) share {
    
}

@end
