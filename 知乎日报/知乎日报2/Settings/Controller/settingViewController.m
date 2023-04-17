//
//  settingViewController.m
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/2.
//

#import "settingViewController.h"
#import "CollectionViewController.h"


@interface settingViewController ()

@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToCollections:) name:@"pushInSettingViewController" object:nil];
    
    
    settingView* oneView = [[settingView alloc]init];
    
    [oneView LayoutSelf];
    
    oneView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    oneView.delegate = self;
    
    [self.view addSubview:oneView];
    
    
    
}

- (void) popToMainView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) pushToCollections:(NSNotification*) notification {
    CollectionViewController* collectionViewController = [[CollectionViewController alloc] init];
    
    [self.navigationController pushViewController:collectionViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
