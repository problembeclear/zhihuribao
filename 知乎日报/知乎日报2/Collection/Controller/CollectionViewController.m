//
//  CollectionViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/16.
//

#import "CollectionViewController.h"
#import "CollectScrollViewController.h"

#import "Masonry.h"
#import "FMDB.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToSetting) name:@"return" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToCollectScrollView:) name:@"goToScrollView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell) name:@"refresh" object:nil];
    
    self.viewCollection = [[CollectionView alloc] init];
    
    [self.view addSubview:self.viewCollection];
    
    [self.viewCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view.frame.size);
    }];
    
    
    [self.viewCollection LayoutSelf];
    
    
}


- (void) returnToSetting {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) pushToCollectScrollView:(NSNotification*) notification {

    NSDictionary* dict = notification.userInfo;

    CollectScrollViewController* scrollViewController = [[CollectScrollViewController alloc] init];

    scrollViewController.stringPage = dict[@"page"];

    [self.navigationController pushViewController:scrollViewController animated:YES];


}

- (void) refreshCell {
    [self.viewCollection LayoutSelf];
}

@end
