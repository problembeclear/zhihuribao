//
//  MainView.m
//  知乎日报
//
//  Created by 张思扬 on 2022/10/12.
//

#import "MainView.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


#define Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@implementation MainView

- (void) Init {
    
    self.backgroundColor = [UIColor systemGray6Color];
    
    self.cellCount = 1;
    
    
    
    //布局导航栏
    [self LayoutNavigation];
    
    //布局日期
    [self LayoutDate];
    
    //初始化小菊花
    [self initActivityIndicator];
    //布局tableView
    [self LayoutTableView];
    
    
    //布局无限轮播图
    [self LayoutScrollView];
        //计时器
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(turnRight) userInfo:nil repeats:YES];

    
}




//布局假导航栏
- (void) LayoutNavigation {
    //日期
    [self LayoutDate];
    
    //分隔线
    [self LayoutDivideLine];
    
    //知乎日报
    [self LayoutZHIHU];
    
    //头像按钮
    [self LayoutHeadImage];
    
}
//日期
- (void) LayoutDate {
    //创建NSDate
    NSDate* date = [NSDate date];
    NSDateFormatter* formatterMonth = [[NSDateFormatter alloc]init];
    NSDateFormatter* formatterDay = [[NSDateFormatter alloc]init];
    
    [formatterMonth setDateFormat:@"MM"];
    [formatterDay setDateFormat:@"dd"];
    
    NSString* MonthString = [formatterMonth stringFromDate:date];
    NSString* DayString = [formatterDay stringFromDate:date];
    

    
    //通过formatterMonth、formatterDay获取NSString并显示到label
    
    //labelDay
    UILabel* labelDay = [[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.04, Width*0.1, Height*0.045)];
    
    labelDay.text = DayString;
    
    labelDay.font = [UIFont systemFontOfSize:23];
    
    labelDay.textAlignment = NSTextAlignmentCenter;
    
    
    [self addSubview:labelDay];
    //labelMonth
    NSArray* monthArray = [NSArray arrayWithObjects:@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
    
    UILabel* labelMonth = [[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.07, Width*0.1, Height*0.045)];
    
    NSString* ChineseMonth = [NSString stringWithFormat:@"%@", monthArray[[MonthString integerValue] - 1] ];
    
    labelMonth.text = ChineseMonth;
    
    labelMonth.font = [UIFont systemFontOfSize:13];
    
    labelMonth.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:labelMonth];
}
//分隔线
- (void) LayoutDivideLine {
    UIImageView* DivideLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grayColor.jpeg"]];
    
    DivideLine.frame = CGRectMake(Width*0.170, Height*0.045, 1, Height*0.07);
    
    [self addSubview:DivideLine];
}
//知乎日报 四个大字
- (void) LayoutZHIHU {
    //知乎日报
    UILabel* labelZHIHU = [[UILabel alloc]initWithFrame:CGRectMake(Width*0.2, Height*0.03, Width*0.5, Height*0.09)];
    
    labelZHIHU.text = @"知乎日报";
    
    labelZHIHU.textColor = [UIColor blackColor];
    
    labelZHIHU.font = [UIFont systemFontOfSize:32];
    
    [self addSubview:labelZHIHU];
    
}
//右上角头像
- (void) LayoutHeadImage {
    //头像按钮
    self.buttonSetting = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.buttonSetting.frame = CGRectMake(Width-Height*0.05-Width*0.05, Height*0.05, Height*0.05, Height*0.05);
    
    [self.buttonSetting setBackgroundImage:[UIImage imageNamed:@"head.jpeg"] forState:UIControlStateNormal];
    
    self.buttonSetting.layer.cornerRadius = Height*0.025;
    
    self.buttonSetting.layer.masksToBounds = YES;
    
    [self.buttonSetting addTarget:self action:@selector(pressHead) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.buttonSetting];
}



//布局tableView
- (void) LayoutTableView {
    //tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height*0.12, Width, Height*0.88) style:UITableViewStylePlain];
    
    self.tableView.tag = 101;
    

    
    self.tableView.scrollEnabled = YES;
    self.tableView.alwaysBounceHorizontal = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.pagingEnabled = NO;
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"123"];
    

    
    [self addSubview:self.tableView];
    
    //[_tableView reloadData];
}

//在首个cell布局滚动视图
- (void) LayoutScrollView {
    //滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height*0.5)];
    
    self.scrollView.tag = 102;
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.contentSize = CGSizeMake(Width*7, Height*0.5);
    
    for (int i = 0; i < 7; i++) {
        
        UIImageView* imageView = [[UIImageView alloc]init];
        NSURL* urlImage;
        UILabel* labelOnScrollView = [[UILabel alloc]init];
        UILabel* labelOnScrollViewDetails = [[UILabel alloc]init];
        
        [imageView addSubview:labelOnScrollView];
        [imageView addSubview:labelOnScrollViewDetails];
        
        [labelOnScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageView).with.insets(UIEdgeInsetsMake(300, 20, 60, 80));
        }];
        [labelOnScrollViewDetails mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView).with.offset(20);
            make.top.equalTo(imageView).with.offset(400);
            make.width.equalTo(@200);
            make.height.equalTo(@40);
        }];
        
        labelOnScrollView.font = [UIFont systemFontOfSize:25];
        labelOnScrollView.textColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:100];
        [labelOnScrollView setLineBreakMode:NSLineBreakByWordWrapping];
        labelOnScrollView.numberOfLines = 0;
        
        
        
        labelOnScrollViewDetails.font = [UIFont systemFontOfSize:15];
        labelOnScrollViewDetails.textColor = [UIColor colorWithRed:222.0/255.0 green:230.0/255.0 blue:238.0/255.0 alpha:1.0];
        
        
        if (i == 0) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][4][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][4][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][4][@"hint"];
            NSLog(@"%@", self.dictionaryLastNews[@"top_stories"][4][@"hint"]);
        }
        if (i == 1) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][0][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][0][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][0][@"hint"];
        }
        if (i == 2) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][1][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][1][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][1][@"hint"];
        }
        if (i == 3) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][2][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][2][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][2][@"hint"];
        }
        if (i == 4) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][3][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][3][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][3][@"hint"];
        }
        if (i == 5) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][4][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][4][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][4][@"hint"];
        }
        if (i == 6) {
            urlImage = [NSURL URLWithString:self.dictionaryLastNews[@"top_stories"][0][@"image"]];
            
            labelOnScrollView.text = self.dictionaryLastNews[@"top_stories"][0][@"title"];
            labelOnScrollViewDetails.text = self.dictionaryLastNews[@"top_stories"][0][@"hint"];
        }
        
        
        [imageView sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"position.jpeg"] options:SDWebImageRefreshCached];
        
        imageView.frame = CGRectMake(i*Width, 0, Width, Height*0.5);
        //给imageView添加单击手势
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
        
        [imageView addGestureRecognizer:singleTap];
        
        [self.scrollView addSubview:imageView];
        
    }
    
    
    self.scrollView.delegate = self;
    
    self.scrollView.contentOffset = CGPointMake(Width, 0);
    
    //

    
        //分页器
    self.pageControl = [[UIPageControl alloc]init];
 
    self.pageControl.numberOfPages = 5;

    self.pageControl.tintColor = [UIColor blackColor];
    //
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    self.pageControl.frame = CGRectMake(Width*0.55, Height*0.425, 200, 75);


    self.pageControl.currentPage = 0;
    
    
    
}

- (void) turnRight {
    
    int page = self.scrollView.contentOffset.x/Width;
    
    if (page != 5) {
        [self.scrollView setContentOffset:CGPointMake(Width * (page % 5 + 1), 0) animated:YES];
        self.pageControl.currentPage = page;
        
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self performSelector:@selector(turnRight) withObject:nil afterDelay:0];
    }
}

//滚动视图将被拖动
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
   
}


//滚动视图停止滚动
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 102) {
        int page = scrollView.contentOffset.x / Width;
        if (page == 0) {
            //滚到最后一页
            //重新设置偏移量
            [scrollView setContentOffset:CGPointMake(Width * 5, 0) animated:NO];
            
            self.pageControl.currentPage = 4;
        } else if (page == 6) {
            //此时应滚到第一页
            [scrollView setContentOffset:CGPointMake(Width, 0) animated:NO];

            self.pageControl.currentPage = 0;
        } else {
            self.pageControl.currentPage = page - 1;
        }
    }
    

}
//滚动视图停止被拖动
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.tag == 102) {
        //_scrollView
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(turnRight) userInfo:nil repeats:YES];
      
        //三秒后重新启动定时器
        NSRunLoop* runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
    }
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.activityIndicator startAnimating];
    if (scrollView.tag == 101) {
        if (scrollView.contentOffset.y >= Height * 0.5 + (self.cellCount - 1) * 120 * 6 + 120 + (self.cellCount - 1)*47) {
            
            [self refreshCell];
        }
    }
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.activityIndicator stopAnimating];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return Height*0.5;
    } else {
        return 120;
    }
   
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == self.cellCount) {
        //最后一组带小菊花
        return 7;
    } else {
        //不带小菊花
        return 6;
    }
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellCount + 1;
}

//cell上方头标题
- (void) tableView:(UITableView*)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    if (section > 1) {
        UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*) view;
        header.contentView.backgroundColor = [UIColor clearColor];
        
        const char* Cstring = [self.allDictionaryArray[section - 2][@"date"] UTF8String];
        //————————————
        NSString* date = [NSString stringWithFormat:@"%c%c月%c%c日", Cstring[4], Cstring[5], Cstring[6], Cstring[7]];
        
        header.textLabel.text = date;
        
        [header.textLabel setFont:[UIFont systemFontOfSize:20]];
        
    }
}
//与上面一起作用
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section > 1) {
        return @"日期";
    }
    return nil;
}
//头标题高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        return 20;
    }
    return 0;
}
//是否允许头标题移动
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //给每一个cell标上id，防止串用
    NSString* cellIdentifier = [NSString stringWithFormat:@"%ld%ldcell", indexPath.row, indexPath.section];
    
    
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        if (indexPath.section != 0) {
            cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        } else {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"111"];
        }
        
    }
    //圆角的图片
    cell.cellImage.layer.cornerRadius = 5;
    cell.cellImage.clipsToBounds = YES;
    
    //设置文字换行
    [cell.cellLabelTitle setLineBreakMode:NSLineBreakByWordWrapping];
    
    cell.cellLabelTitle.numberOfLines = 0;
    
    if (indexPath.section == 0) {
        //scrollView
        [self LayoutScrollView];
        [cell.contentView addSubview:self.scrollView];
        [self.tableView addSubview:self.pageControl];
        
    } else if (indexPath.section != self.cellCount) {
        
        //中间的setion,没有小菊花
        if(indexPath.section == 1) {
            //文章cell
            cell.cellLabelTitle.text = self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"title"];
            cell.cellLabelDetails.text = self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"hint"];
            
           
            NSURL* URL = [NSURL URLWithString:self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"images"][0]];
            
            [cell.cellImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"position.jpeg"] options:SDWebImageRefreshCached];
        } else {
            //文章cell
            cell.cellLabelTitle.text = self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"title"];
            cell.cellLabelDetails.text = self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"hint"];
            
            NSURL* URL = [NSURL URLWithString:self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"images"][0]];
            
            
            [cell.cellImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"position.jpeg"] options:SDWebImageRefreshCached];
            
        }
        
    } else {

        //最后一组cell
        if (indexPath.row == 6) {
            //小菊花
            [cell.contentView addSubview:self.activityIndicator];
        } else {
            //先判断是不是第1组
            if (indexPath.section == 1) {
                //文章cell
                cell.cellLabelTitle.text = self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"title"];
                cell.cellLabelDetails.text = self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"hint"];
              
                NSURL* URL = [NSURL URLWithString:self.dictionaryLastNews[@"stories"][indexPath.row % 6][@"images"][0]];
                
                [cell.cellImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"position.jpeg"] options:SDWebImageRefreshCached];
            } else {
                //文章cell
                cell.cellLabelTitle.text = self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"title"];
                cell.cellLabelDetails.text = self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"hint"];
                
 
                NSURL* URL = [NSURL URLWithString:self.allDictionaryArray[indexPath.section - 2][@"stories"][indexPath.row % 6][@"images"][0]];
                
                [cell.cellImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"position.jpeg"] options:SDWebImageRefreshCached];
            }
            
        }
        
    }
    
    return cell;
}

//初始化UIActivityIndicatorView
- (void) initActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleMedium)];
    
    self.activityIndicator.frame = CGRectMake(Width*0.4, 20, 100, 100);
    
    [self.activityIndicator sizeThatFits:CGSizeMake(100, 100)];
    
    self.activityIndicator.color = [UIColor grayColor];
    
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = NO;
    
}







//---------------以下是添加的事件，没有其他布局了--------------//


//按下导航栏头像
- (void) pressHead {

    [self.pushDelegate pushControllerToSetting];
    
}

//上拉获取新数据
- (void) refreshCell {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil userInfo:@{@"Date":self.nowStringDate}];

}


//给scrollView的imageView添加的单击手势事件
- (void) handleSingleTap {
    
    NSInteger page = self.scrollView.contentOffset.x / Width;
    
    NSString* pageString = [NSString stringWithFormat:@"%ld", page];
    
    NSLog(@"%@", pageString);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getToScrollView" object:nil userInfo:@{@"page":pageString}];
}

//点击cell触发事件函数
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getToCellView" object:nil userInfo:@{@"index":indexPath, @"LastNews":self.dictionaryLastNews, @"PreviousNews":self.allDictionaryArray}];
    }
    
    
}
@end
