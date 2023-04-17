//
//  CommentViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/9.
//

#import "CommentViewController.h"
#import "Masonry.h"
#import "CommentView.h"
#import "Manage.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popBack) name:@"popBack" object:nil];
    
    CommentView* commentView = [[CommentView alloc] init];
    
    [self.view addSubview:commentView];
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view.frame.size);
    }];
    
    
    
    NSString* idString;
    
    if (self.myID.length > 10) {
        //取出url的数字id
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        idString =[self.myID stringByTrimmingCharactersInSet:nonDigits] ;

    } else {
        idString = self.myID;
    }
    [[Manage shareManage] NetWorkTestWithCommentsDate:^(CommentModel * _Nonnull mainViewModel) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            commentView.myDictionary = [mainViewModel toDictionary];
            
            [commentView LayoutSelf];
            
        });
        
        NSLog(@"请求成功");
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    } JSON:idString];
}


- (void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
