//
//  OneScrollView.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import "OneScrollView.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>


#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation OneScrollView
//主布局
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
    

    
    self.idStr = [[NSString alloc] init];
    self.idStr = self.mydict[@"top_stories"][self.page - 1][@"url"];
    
    
    self.backgroundColor = [UIColor systemGray6Color];
    //布局下方栏
    [self LayoutTabBar];
    
    [self setNavigationColor];
    
    [self LayoutScrollView];
    
    
    
    
    
    
}


//布局分栏
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
    
//    NSString* url = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@", self.idStr];
   
    
    //分享
    UIButton* buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonShare setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    
    [buttonShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buttonShare];
    
    //评论数
    self.commentsCount = [[UILabel alloc] init];
    

    
    
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
    
    
    for (int i = 0; i < self.arrayForButtonState.count; i++) {
        NSLog(@"-------%@", self.arrayForButtonState[i]);
        NSLog(@"=======%@", self.idStr);
        
        if ([self.arrayForButtonState[i] isEqualToString: self.idStr]) {
            NSLog(@"被选中");
            self.buttonCollect.selected = true;
            break;
        }
        self.buttonCollect.selected = false;
    }
    if (self.buttonCollect.selected == true) {
        NSLog(@"按钮状态是：YES");
    } else {
        NSLog(@"按钮状态是：NO");
    }
}
//布局导航栏（伪）
- (void) setNavigationColor {
    
    UIView* viewBackground = [[UIView alloc]init];
    
    viewBackground.backgroundColor = [UIColor whiteColor];
    
    viewBackground.frame = CGRectMake(0, 0, Width, Height * 0.92);
    
    [self addSubview:viewBackground];
    
}

//布局滚动视图
- (void) LayoutScrollView {
    self.scrollView = [[UIScrollView alloc]init];
    
    self.scrollView.delegate = self;
    
    self.scrollView.frame = CGRectMake(0, 40, Width, Height * 0.92 - 40);
    
    [self addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(Width * 5, 0);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    
    
    for (int i = 0; i < 5; i++) {
        WKWebView* webView = [[WKWebView alloc]init];
        
        webView.frame = CGRectMake(Width * i, 0, Width, Height* 0.92 - 40);
        
        
        [self.scrollView addSubview:webView];
        //
        NSString* URLString = [NSString stringWithString:self.arrayURL[i]];
        
        NSURL* urlTest = [NSURL URLWithString:URLString];
        
        NSURLRequest* requestTest = [NSURLRequest requestWithURL:urlTest];
        
        [webView loadRequest:requestTest];
    }
    
    self.scrollView.contentOffset = CGPointMake((self.page - 1) * Width, 0);
    
   
}
//滚动视图停止减速
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat LastWidth = (self.page - 1) * Width;
    if (scrollView.contentOffset.x < LastWidth) {
        self.page--;
    }
    if (scrollView.contentOffset.x > LastWidth) {
        self.page++;
    }
    
    self.idStr = self.mydict[@"top_stories"][self.page - 1][@"url"];
    for (int i = 0; i < self.arrayForButtonState.count; i++) {
        NSLog(@"-------%@", self.arrayForButtonState[i]);
        NSLog(@"=======%@", self.idStr);
        
        if ([self.arrayForButtonState[i] isEqualToString: self.idStr]) {
            NSLog(@"被选中");
            self.buttonCollect.selected = true;
            break;
        }
        self.buttonCollect.selected = false;
    }
    if (self.buttonCollect.selected == true) {
        NSLog(@"按钮状态是：YES");
    } else {
        NSLog(@"按钮状态是：NO");
    }
}
//返回主页面
- (void) returnToMainView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnToMainView" object:nil];
}
//进入评论页面
- (void) pushToComment {
    NSInteger page = self.scrollView.contentOffset.x/Width;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToScrollComment" object:nil userInfo:@{@"id":[self.mydict[@"top_stories"][page][@"id"] stringValue]}];
}

//点赞
- (void) likes {
    if (self.buttonLikes.selected == YES) {
        self.buttonLikes.selected = NO;
    } else {
        self.buttonLikes.selected = YES;
    }
    
    
}
//收藏
- (void) collect {
    NSString* stringSelected;
    if (self.buttonCollect.selected == YES) {
        self.buttonCollect.selected = NO;
        
        stringSelected = @"NO";
    } else if(self.buttonCollect.selected == NO){
        self.buttonCollect.selected = YES;
        
        stringSelected = @"YES";
    }
    
    //indexString：0 到 4
    NSString* indexString = [NSString stringWithFormat:@"%ld", self.page - 1];
    
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectByScrollView" object:nil userInfo:@{@"id":self.idStr,@"selected":stringSelected, @"index":indexString }];
    
    
}


@end
